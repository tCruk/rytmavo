import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rytmavo/app/di/providers.dart';
import 'package:rytmavo/core/date/clock.dart';
import 'package:rytmavo/core/date/local_date.dart';
import 'package:rytmavo/core/date/local_time.dart';
import 'package:rytmavo/features/habits/domain/entities/habit.dart';
import 'package:rytmavo/features/habits/domain/entities/habit_rule.dart';
import 'package:rytmavo/features/habits/presentation/controllers/habit_providers.dart';
import 'package:rytmavo/features/reminders/domain/entities/planned_reminder.dart';
import 'package:rytmavo/features/reminders/domain/gateways/notification_gateway.dart';
import 'package:rytmavo/features/reminders/presentation/reminder_scheduler.dart';
import 'package:rytmavo/features/settings/domain/entities/app_settings.dart';
import 'package:rytmavo/features/settings/presentation/controllers/settings_controller.dart';
import 'package:rytmavo/features/shifts/domain/entities/rotation_pattern.dart';
import 'package:rytmavo/features/shifts/domain/entities/rotation_preset.dart';
import 'package:rytmavo/features/shifts/domain/entities/shift_type.dart';
import 'package:rytmavo/features/shifts/domain/services/rotation_rules.dart';
import 'package:rytmavo/features/shifts/presentation/controllers/shift_providers.dart';

import '../../support/in_memory_habit_repository.dart';
import '../../support/in_memory_settings_repository.dart';
import '../../support/in_memory_shift_repository.dart';

final class RecordingGateway implements NotificationGateway {
  List<PlannedReminder>? scheduled;
  List<ReminderText> texts = [];
  int cancelAllCalls = 0;

  @override
  Future<bool> hasPermission() async => true;

  @override
  Future<bool> requestPermission() async => true;

  @override
  Future<void> replaceAll(
    List<PlannedReminder> reminders,
    ReminderText Function(PlannedReminder reminder) textFor,
  ) async {
    scheduled = reminders;
    texts = reminders.map(textFor).toList();
  }

  @override
  Future<void> cancelAll() async {
    cancelAllCalls++;
    scheduled = null;
  }
}

void main() {
  const today = LocalDate(2026, 10, 10); // Saturday, slot 0 → early
  final clock = FixedClock(DateTime(2026, 10, 10, 6));
  late RecordingGateway gateway;
  late InMemorySettingsRepository settingsRepo;
  late InMemoryShiftRepository shiftRepo;
  late InMemoryHabitRepository habitRepo;
  late ProviderContainer container;

  const habit = Habit(
    id: 'h',
    name: 'Wasser',
    iconKey: 'water',
    colorValue: 0,
    createdOn: today,
    sortOrder: 0,
  );
  final rule = HabitRule(
    id: 'r',
    habitId: 'h',
    validFrom: today,
    targetShiftTypeIds: const {'early'},
    reminders: const {'early': LocalTime(7, 0)},
  );

  setUp(() {
    gateway = RecordingGateway();
    settingsRepo = InMemorySettingsRepository(
      const AppSettings(remindersEnabled: true, language: AppLanguage.de),
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
    habitRepo = InMemoryHabitRepository(habits: [habit], rules: [rule]);
    container = ProviderContainer(
      overrides: [
        clockProvider.overrideWithValue(clock),
        notificationGatewayProvider.overrideWithValue(gateway),
        settingsRepositoryProvider.overrideWithValue(settingsRepo),
        shiftRepositoryProvider.overrideWithValue(shiftRepo),
        habitRepositoryProvider.overrideWithValue(habitRepo),
      ],
    );
  });
  tearDown(() async {
    container.dispose();
    await settingsRepo.dispose();
    await shiftRepo.dispose();
    await habitRepo.dispose();
  });

  Future<void> warmUp() async {
    // Keep the data providers alive like the widget tree would.
    container.listen(settingsControllerProvider, (_, _) {});
    container.listen(shiftSetupProvider, (_, _) {});
    container.listen(habitPlanProvider, (_, _) {});
    container.read(reminderSchedulerProvider);
    // Wait for settings, shifts and habits to load, then sync explicitly.
    for (var i = 0; i < 50; i++) {
      await pumpEventQueue();
      if (container.read(settingsControllerProvider).hasValue &&
          container.read(shiftSetupProvider).hasValue &&
          container.read(habitPlanProvider).hasValue) {
        break;
      }
    }
    await container.read(reminderSchedulerProvider).sync();
  }

  test('schedules reminders with localized text', () async {
    await warmUp();
    final scheduled = gateway.scheduled!;
    // Early shift on days 0, 1 and 8, 9 of the 14-day window.
    expect(scheduled.map((r) => r.date), [
      today,
      today.addDays(1),
      today.addDays(8),
      today.addDays(9),
    ]);
    expect(scheduled.first.at, DateTime(2026, 10, 10, 7));
    expect(gateway.texts.first, (
      title: 'Wasser',
      body: 'Heute fällig (Früh).',
    ));
  });

  test('completing today removes today\'s reminder on the next sync', () async {
    await warmUp();
    await habitRepo.setCompleted('h', today, completed: true, now: clock.now());
    await pumpEventQueue();
    await container.read(reminderSchedulerProvider).sync();
    expect(gateway.scheduled!.map((r) => r.date).contains(today), isFalse);
  });

  test('disabled reminders cancel everything', () async {
    await warmUp();
    expect(gateway.scheduled, isNotEmpty);
    await settingsRepo.save(AppSettings.defaults);
    await pumpEventQueue();
    await container.read(reminderSchedulerProvider).sync();
    expect(gateway.scheduled, isNull);
    expect(gateway.cancelAllCalls, greaterThanOrEqualTo(1));
  });

  test('English texts when the app language is English', () async {
    await settingsRepo.save(
      const AppSettings(remindersEnabled: true, language: AppLanguage.en),
    );
    await warmUp();
    expect(gateway.texts.first.body, 'Due today (Early).');
  });
}
