import 'package:flutter_test/flutter_test.dart';
import 'package:rytmavo/core/date/local_date.dart';
import 'package:rytmavo/features/habits/domain/entities/habit.dart';
import 'package:rytmavo/features/habits/domain/entities/habit_completion.dart';
import 'package:rytmavo/features/habits/domain/entities/habit_plan.dart';
import 'package:rytmavo/features/habits/domain/entities/habit_rule.dart';
import 'package:rytmavo/features/habits/domain/services/habit_statistics.dart';
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
  const created = LocalDate(2026, 1, 1);
  const walk = Habit(
    id: 'walk',
    name: 'Spaziergang',
    iconKey: 'walk',
    colorValue: 0xFF000000,
    createdOn: created,
    sortOrder: 0,
  );

  HabitRule rule({
    Set<String> targets = const {},
    Set<int>? weekdays,
    LocalDate validFrom = created,
    String id = 'r1',
  }) => HabitRule(
    id: id,
    habitId: 'walk',
    validFrom: validFrom,
    targetShiftTypeIds: targets,
    weekdays: weekdays,
  );

  HabitCompletion done(LocalDate d) =>
      HabitCompletion(habitId: 'walk', date: d, completedAt: DateTime(2026));

  group('eligibility', () {
    test('empty targets → due every day, also without a shift', () {
      final plan = HabitPlan(habits: [walk], rules: [rule()], completions: []);
      for (var i = 0; i < 8; i++) {
        expect(plan.dueOn(setup.dayOn(anchor.addDays(i))), hasLength(1));
      }
      expect(plan.dueOn(ShiftSetup.empty.dayOn(anchor)), hasLength(1));
    });

    test('targets restrict to shifts', () {
      final plan = HabitPlan(
        habits: [walk],
        rules: [
          rule(targets: {'night'}),
        ],
        completions: [],
      );
      expect(plan.dueOn(setup.dayOn(anchor)), isEmpty); // early
      expect(plan.dueOn(setup.dayOn(anchor.addDays(4))), hasLength(1));
      expect(plan.dueOn(setup.dayOn(anchor.addDays(5))), hasLength(1));
      expect(plan.dueOn(setup.dayOn(anchor.addDays(6))), isEmpty); // off
      // No resolved shift → a shift-bound habit is not due.
      expect(plan.dueOn(ShiftSetup.empty.dayOn(anchor)), isEmpty);
    });

    test('weekdays further restrict', () {
      final plan = HabitPlan(
        habits: [walk],
        rules: [
          rule(targets: {'early'}, weekdays: {1}),
        ],
        completions: [],
      );
      expect(plan.dueOn(setup.dayOn(anchor)), hasLength(1)); // Mon, early
      expect(plan.dueOn(setup.dayOn(anchor.addDays(1))), isEmpty); // Tue
    });

    test('not due before creation or from archive day on', () {
      final archived = walk.copyWith(archivedOn: anchor.addDays(2));
      final plan = HabitPlan(
        habits: [archived],
        rules: [rule()],
        completions: [],
      );
      expect(plan.dueOn(setup.dayOn(created.addDays(-1))), isEmpty);
      expect(plan.dueOn(setup.dayOn(anchor.addDays(1))), hasLength(1));
      expect(plan.dueOn(setup.dayOn(anchor.addDays(2))), isEmpty);
      expect(plan.activeHabits, isEmpty);
    });

    test('rule versions: the past keeps the old rule', () {
      final change = anchor.addDays(4);
      final plan = HabitPlan(
        habits: [walk],
        rules: [
          rule(targets: {'early'}),
          rule(targets: {'night'}, validFrom: change, id: 'r2'),
        ],
        completions: [],
      );
      expect(plan.dueOn(setup.dayOn(anchor)), hasLength(1)); // early, old
      expect(plan.dueOn(setup.dayOn(change)), hasLength(1)); // night, new
      expect(plan.dueOn(setup.dayOn(anchor.addDays(8))), isEmpty); // early
      expect(plan.currentRule('walk')?.id, 'r2');
      expect(plan.ruleOn('walk', anchor)?.id, 'r1');
    });

    test('completion state is per day', () {
      final plan = HabitPlan(
        habits: [walk],
        rules: [rule()],
        completions: [done(anchor)],
      );
      expect(plan.dueOn(setup.dayOn(anchor)).single.isCompleted, isTrue);
      expect(
        plan.dueOn(setup.dayOn(anchor.addDays(1))).single.isCompleted,
        isFalse,
      );
    });
  });

  group('statistics', () {
    HabitStats stats(HabitPlan plan, LocalDate today, {int days = 8}) =>
        HabitStatistics.forHabit(
          habit: walk,
          plan: plan,
          setup: setup,
          from: anchor,
          to: anchor.addDays(days - 1),
          today: today,
        );

    test('rate counts only due days', () {
      final plan = HabitPlan(
        habits: [walk],
        rules: [
          rule(targets: {'early', 'late'}),
        ],
        completions: [done(anchor), done(anchor.addDays(2))],
      );
      final s = stats(plan, anchor.addDays(10));
      expect(s.dueDays, 4);
      expect(s.completedDays, 2);
      expect(s.rate, 0.5);
      expect(s.missedDays, 2);
    });

    test('nothing due → rate null, not zero', () {
      final plan = HabitPlan(
        habits: [walk],
        rules: [
          rule(targets: {'custom'}),
        ],
        completions: [],
      );
      expect(stats(plan, anchor.addDays(10)).rate, isNull);
    });

    test('future days are not counted', () {
      final plan = HabitPlan(habits: [walk], rules: [rule()], completions: []);
      expect(stats(plan, anchor.addDays(2)).dueDays, 3);
    });

    test('streaks: open today does not break the current streak', () {
      final plan = HabitPlan(
        habits: [walk],
        rules: [rule()],
        completions: [
          done(anchor),
          done(anchor.addDays(1)),
          // day 2 missed
          done(anchor.addDays(3)),
          done(anchor.addDays(4)),
          done(anchor.addDays(5)),
          // day 6 = today, open
        ],
      );
      final s = stats(plan, anchor.addDays(6), days: 7);
      expect(s.bestStreak, 3);
      expect(s.currentStreak, 3);
      // Same data, but today is day 7: day 6 is a real miss.
      final s2 = stats(plan, anchor.addDays(7), days: 7);
      expect(s2.currentStreak, 0);
    });

    test('overall aggregates across habits', () {
      const run = Habit(
        id: 'run',
        name: 'Laufen',
        iconKey: 'run',
        colorValue: 0,
        createdOn: created,
        sortOrder: 1,
      );
      final plan = HabitPlan(
        habits: [walk, run],
        rules: [
          rule(),
          HabitRule(
            id: 'r-run',
            habitId: 'run',
            validFrom: created,
            targetShiftTypeIds: const {'off'},
          ),
        ],
        completions: [done(anchor)],
      );
      final all = HabitStatistics.forAll(
        plan: plan,
        setup: setup,
        from: anchor,
        to: anchor.addDays(7),
        today: anchor.addDays(20),
      );
      expect(all, hasLength(2));
      final overall = HabitStatistics.overall(all);
      expect(overall.dueDays, 8 + 2);
      expect(overall.completedDays, 1);
    });
  });
}
