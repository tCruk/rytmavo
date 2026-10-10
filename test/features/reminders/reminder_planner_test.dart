import 'package:flutter_test/flutter_test.dart';
import 'package:rytmavo/core/date/local_date.dart';
import 'package:rytmavo/core/date/local_time.dart';
import 'package:rytmavo/features/habits/domain/entities/habit.dart';
import 'package:rytmavo/features/habits/domain/entities/habit_completion.dart';
import 'package:rytmavo/features/habits/domain/entities/habit_plan.dart';
import 'package:rytmavo/features/habits/domain/entities/habit_rule.dart';
import 'package:rytmavo/features/reminders/domain/entities/planned_reminder.dart';
import 'package:rytmavo/features/reminders/domain/services/reminder_planner.dart';
import 'package:rytmavo/features/shifts/domain/entities/rotation_pattern.dart';
import 'package:rytmavo/features/shifts/domain/entities/rotation_preset.dart';
import 'package:rytmavo/features/shifts/domain/entities/shift_setup.dart';
import 'package:rytmavo/features/shifts/domain/entities/shift_type.dart';
import 'package:rytmavo/features/shifts/domain/services/rotation_rules.dart';

void main() {
  // Monday 2026-03-02 = slot 0 of conti4: E E L L N N O O
  const anchor = LocalDate(2026, 3, 2);
  final setup = ShiftSetup(
    types: ShiftType.defaults,
    patterns: [
      RotationPattern(
        id: 'p',
        validFrom: RotationRules.firstVersionValidFrom,
        anchorDate: anchor,
        slots: RotationPreset.conti4.slots,
      ),
    ],
    overrides: const [],
  );
  const habit = Habit(
    id: 'h',
    name: 'Dehnen',
    iconKey: 'gym',
    colorValue: 0,
    createdOn: LocalDate(2026, 1, 1),
    sortOrder: 0,
  );
  HabitRule rule(
    Map<String, LocalTime> reminders, {
    Set<String> targets = const {},
  }) => HabitRule(
    id: 'r',
    habitId: 'h',
    validFrom: const LocalDate(2026, 1, 1),
    targetShiftTypeIds: targets,
    reminders: reminders,
  );
  final now = DateTime(2026, 3, 2, 8); // Monday 08:00, early shift

  test('wildcard reminder: one per due day in the window, future only', () {
    final plan = HabitPlan(
      habits: [habit],
      rules: [
        rule({HabitRule.anyShiftReminderKey: const LocalTime(7, 0)}),
      ],
      completions: [],
    );
    final reminders = ReminderPlanner.plan(setup: setup, plan: plan, now: now);
    // Today's 07:00 is already past → 13 remaining days.
    expect(reminders, hasLength(ReminderPlanner.windowDays - 1));
    expect(reminders.first.at, DateTime(2026, 3, 3, 7));
    expect(reminders.first.shiftTypeId, 'early');
    expect(reminders.last.date, anchor.addDays(13));
  });

  test('shift-specific times win over the wildcard; off days skipped', () {
    final plan = HabitPlan(
      habits: [habit],
      rules: [
        rule(
          {
            HabitRule.anyShiftReminderKey: const LocalTime(9, 0),
            'night': const LocalTime(20, 30),
          },
          targets: {'early', 'night'},
        ),
      ],
      completions: [],
    );
    final reminders = ReminderPlanner.plan(setup: setup, plan: plan, now: now);
    final byDate = {for (final r in reminders) r.date: r};
    expect(byDate[anchor]?.at, DateTime(2026, 3, 2, 9)); // early, today
    expect(byDate[anchor.addDays(4)]?.at, DateTime(2026, 3, 6, 20, 30));
    expect(byDate.containsKey(anchor.addDays(2)), isFalse); // late: not due
    expect(byDate.containsKey(anchor.addDays(6)), isFalse); // off
  });

  test('completed days and habits without reminder are not scheduled', () {
    final plan = HabitPlan(
      habits: [habit],
      rules: [
        rule({HabitRule.anyShiftReminderKey: const LocalTime(12, 0)}),
      ],
      completions: [
        HabitCompletion(habitId: 'h', date: anchor, completedAt: now),
      ],
    );
    final reminders = ReminderPlanner.plan(setup: setup, plan: plan, now: now);
    expect(reminders.any((r) => r.date == anchor), isFalse);

    final silent = HabitPlan(
      habits: [habit],
      rules: [rule({})],
      completions: [],
    );
    expect(ReminderPlanner.plan(setup: setup, plan: silent, now: now), isEmpty);
  });

  test('ids are stable per habit and day, and the total is capped', () {
    expect(
      PlannedReminder.idFor('h', anchor),
      PlannedReminder.idFor('h', anchor),
    );
    expect(
      PlannedReminder.idFor('h', anchor),
      isNot(PlannedReminder.idFor('h', anchor.addDays(1))),
    );
    expect(PlannedReminder.idFor('h', anchor), lessThan(1 << 31));

    final many = [
      for (var i = 0; i < 10; i++)
        Habit(
          id: 'h$i',
          name: 'H$i',
          iconKey: 'check',
          colorValue: 0,
          createdOn: const LocalDate(2026, 1, 1),
          sortOrder: i,
        ),
    ];
    final plan = HabitPlan(
      habits: many,
      rules: [
        for (final h in many)
          HabitRule(
            id: 'r${h.id}',
            habitId: h.id,
            validFrom: const LocalDate(2026, 1, 1),
            targetShiftTypeIds: const {},
            reminders: const {HabitRule.anyShiftReminderKey: LocalTime(22, 0)},
          ),
      ],
      completions: [],
    );
    final reminders = ReminderPlanner.plan(setup: setup, plan: plan, now: now);
    expect(reminders, hasLength(ReminderPlanner.maxScheduled));
    // Earliest first, so the near future is never dropped.
    expect(reminders.first.date, anchor);
    expect(reminders.last.date, anchor.addDays(5));
  });
}
