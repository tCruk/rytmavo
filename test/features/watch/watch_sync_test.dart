import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rytmavo/app/di/providers.dart';
import 'package:rytmavo/core/date/clock.dart';
import 'package:rytmavo/core/date/local_date.dart';
import 'package:rytmavo/features/settings/domain/entities/app_settings.dart';
import 'package:rytmavo/features/settings/presentation/controllers/settings_controller.dart';
import 'package:rytmavo/features/shifts/domain/entities/rotation_pattern.dart';
import 'package:rytmavo/features/shifts/domain/entities/rotation_preset.dart';
import 'package:rytmavo/features/shifts/domain/entities/shift_override.dart';
import 'package:rytmavo/features/shifts/domain/entities/shift_type.dart';
import 'package:rytmavo/features/shifts/domain/services/rotation_rules.dart';
import 'package:rytmavo/features/shifts/presentation/controllers/shift_providers.dart';
import 'package:rytmavo/features/watch/domain/gateways/watch_gateway.dart';
import 'package:rytmavo/features/watch/presentation/watch_sync.dart';

import '../../support/in_memory_settings_repository.dart';
import '../../support/in_memory_shift_repository.dart';

final class RecordingWatchGateway implements WatchGateway {
  final List<String> sent = [];

  @override
  Future<void> publish(String json) async => sent.add(json);
}

void main() {
  const today = LocalDate(2026, 10, 10);
  late RecordingWatchGateway gateway;
  late InMemorySettingsRepository settingsRepo;
  late InMemoryShiftRepository shiftRepo;
  late ProviderContainer container;

  setUp(() {
    gateway = RecordingWatchGateway();
    settingsRepo = InMemorySettingsRepository(
      const AppSettings(language: AppLanguage.de),
    );
    shiftRepo = InMemoryShiftRepository(
      types: ShiftType.defaults,
      patterns: [
        RotationPattern(
          id: 'p',
          validFrom: RotationRules.firstVersionValidFrom,
          anchorDate: today,
          slots: RotationPreset.conti4.slots,
        ),
      ],
    );
    container = ProviderContainer(
      overrides: [
        clockProvider.overrideWithValue(FixedClock(DateTime(2026, 10, 10, 6))),
        watchGatewayProvider.overrideWithValue(gateway),
        settingsRepositoryProvider.overrideWithValue(settingsRepo),
        shiftRepositoryProvider.overrideWithValue(shiftRepo),
      ],
    );
  });
  tearDown(() async {
    container.dispose();
    await settingsRepo.dispose();
    await shiftRepo.dispose();
  });

  Future<void> warmUp() async {
    container.listen(settingsControllerProvider, (_, _) {});
    container.listen(shiftSetupProvider, (_, _) {});
    container.read(watchSyncProvider);
    for (var i = 0; i < 50; i++) {
      await pumpEventQueue();
      if (container.read(settingsControllerProvider).hasValue &&
          container.read(shiftSetupProvider).hasValue) {
        break;
      }
    }
  }

  Map<String, Object?> firstDay(String json) =>
      ((jsonDecode(json) as Map<String, Object?>)['days']! as List<Object?>)
              .first!
          as Map<String, Object?>;

  test('sends localized days and skips unchanged snapshots', () async {
    await warmUp();
    await container.read(watchSyncProvider).sync();
    await container.read(watchSyncProvider).sync();
    expect(gateway.sent, hasLength(1));
    expect(firstDay(gateway.sent.single), containsPair('name', 'Früh'));
    expect(firstDay(gateway.sent.single), containsPair('date', '2026-10-10'));
  });

  test('re-sends after a shift change', () async {
    await warmUp();
    await container.read(watchSyncProvider).sync();
    await shiftRepo.setOverride(
      const ShiftOverride(date: today, shiftTypeId: 'off'),
    );
    await pumpEventQueue();
    await container.read(watchSyncProvider).sync();
    expect(gateway.sent, hasLength(2));
    expect(firstDay(gateway.sent.last), containsPair('override', true));
  });

  test('follows the app language', () async {
    await settingsRepo.save(const AppSettings(language: AppLanguage.en));
    await warmUp();
    await container.read(watchSyncProvider).sync();
    expect(firstDay(gateway.sent.single), containsPair('name', 'Early'));
  });
}
