import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rytmavo/app/app.dart';
import 'package:rytmavo/app/di/providers.dart';
import 'package:rytmavo/core/date/clock.dart';
import 'package:rytmavo/core/date/local_date.dart';
import 'package:rytmavo/features/holidays/domain/entities/german_state.dart';
import 'package:rytmavo/features/reminders/domain/gateways/notification_gateway.dart';
import 'package:rytmavo/features/reminders/presentation/reminder_scheduler.dart';
import 'package:rytmavo/features/settings/domain/entities/app_settings.dart';
import 'package:rytmavo/features/shifts/domain/entities/rotation_pattern.dart';
import 'package:rytmavo/features/shifts/domain/entities/rotation_preset.dart';
import 'package:rytmavo/features/shifts/domain/entities/shift_type.dart';
import 'package:rytmavo/features/shifts/domain/services/rotation_rules.dart';

import '../../support/in_memory_habit_repository.dart';
import '../../support/in_memory_settings_repository.dart';
import '../../support/in_memory_shift_repository.dart';

void main() {
  // Saturday 2026-10-10 = slot 0 of conti4: E E L L N N O O, so Saturday
  // 3 October (seven days earlier) is an early shift in the rhythm.
  const today = LocalDate(2026, 10, 10);
  final clock = FixedClock(DateTime(2026, 10, 10, 7));
  late InMemorySettingsRepository settingsRepo;
  late InMemoryShiftRepository shiftRepo;
  late InMemoryHabitRepository habitRepo;

  setUp(() {
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
    habitRepo = InMemoryHabitRepository();
  });
  tearDown(() async {
    await settingsRepo.dispose();
    await shiftRepo.dispose();
    await habitRepo.dispose();
  });

  Widget app() => ProviderScope(
    overrides: [
      settingsRepositoryProvider.overrideWithValue(settingsRepo),
      shiftRepositoryProvider.overrideWithValue(shiftRepo),
      habitRepositoryProvider.overrideWithValue(habitRepo),
      notificationGatewayProvider.overrideWithValue(
        const NoopNotificationGateway(),
      ),
      clockProvider.overrideWithValue(clock),
    ],
    child: const RytmavoApp(),
  );

  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 6; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  Future<void> start(WidgetTester tester) async {
    tester.platformDispatcher.localesTestValue = const [Locale('de', 'DE')];
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
    tester.view.physicalSize = const Size(1200, 3600);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox.shrink());
      await settle(tester);
    });
    await tester.pumpWidget(app());
    await settle(tester);
  }

  Future<void> tap(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await settle(tester);
    await tester.tap(finder);
    await settle(tester);
  }

  Finder unityDay() =>
      find.bySemanticsLabel(RegExp('Feiertag: Tag der Deutschen Einheit'));

  testWidgets('nationwide holidays are marked and the calendar asks once', (
    tester,
  ) async {
    settingsRepo = InMemorySettingsRepository(
      const AppSettings(onboardingCompleted: true),
    );
    await start(tester);
    await tap(tester, find.text('Kalender'));

    expect(unityDay(), findsOneWidget);
    expect(find.byKey(const ValueKey('holiday-day')), findsWidgets);
    // Not free by default: the rhythm's early shift stays.
    expect(find.bySemanticsLabel(RegExp('Feiertag, frei')), findsNothing);
    expect(find.byKey(const ValueKey('school-holiday-band')), findsNothing);
    expect(find.text('Feiertage und Ferien markieren?'), findsOneWidget);

    await tap(tester, find.text('Nicht jetzt'));
    expect(find.text('Feiertage und Ferien markieren?'), findsNothing);
    expect(settingsRepo.current.holidaySetupDone, isTrue);
    expect(settingsRepo.current.holidayState, isNull);
  });

  testWidgets('choosing a state adds school holidays and days off', (
    tester,
  ) async {
    settingsRepo = InMemorySettingsRepository(
      const AppSettings(onboardingCompleted: true),
    );
    await start(tester);
    await tap(tester, find.text('Kalender'));
    await tap(tester, find.text('Auswählen'));

    await tap(tester, find.text('Nordrhein-Westfalen'));
    await tap(
      tester,
      find.widgetWithText(SwitchListTile, 'An Feiertagen frei'),
    );
    await tap(tester, find.text('Speichern'));

    expect(settingsRepo.current.holidayState, GermanState.nw);
    expect(settingsRepo.current.showSchoolHolidays, isTrue);
    expect(settingsRepo.current.holidaysAreDaysOff, isTrue);
    expect(settingsRepo.current.holidaySetupDone, isTrue);

    expect(find.text('Feiertage und Ferien markieren?'), findsNothing);
    // NRW autumn holidays start on 17 October 2026.
    expect(find.byKey(const ValueKey('school-holiday-band')), findsWidgets);
    expect(find.bySemanticsLabel(RegExp('Herbstferien')), findsWidgets);
    expect(find.bySemanticsLabel(RegExp('Feiertag, frei')), findsOneWidget);
  });

  testWidgets('a holiday off can be worked again from the day sheet', (
    tester,
  ) async {
    settingsRepo = InMemorySettingsRepository(
      const AppSettings(
        onboardingCompleted: true,
        holidaysAreDaysOff: true,
        holidaySetupDone: true,
      ),
    );
    await start(tester);
    await tap(tester, find.text('Kalender'));
    await tester.tap(unityDay());
    await settle(tester);

    expect(
      find.textContaining('Tag der Deutschen Einheit · An Feiertagen frei'),
      findsOneWidget,
    );
    await tap(tester, find.widgetWithText(RadioListTile<String>, 'Früh'));
    expect(
      (await shiftRepo.load()).dayOn(const LocalDate(2026, 10, 3)).shift?.id,
      'early',
    );
    expect(
      (await shiftRepo.load()).overrideCount,
      1,
      reason: 'working on a free holiday needs an override',
    );
  });
}
