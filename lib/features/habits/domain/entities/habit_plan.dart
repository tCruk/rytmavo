import '../../../../core/date/local_date.dart';
import '../../../shifts/domain/entities/scheduled_day.dart';
import '../../../shifts/domain/entities/shift_setup.dart';
import 'habit.dart';
import 'habit_completion.dart';
import 'habit_rule.dart';

/// A habit's state on one day.
final class DueHabit {
  const DueHabit({
    required this.habit,
    required this.rule,
    required this.date,
    required this.isCompleted,
  });

  final Habit habit;
  final HabitRule rule;
  final LocalDate date;
  final bool isCompleted;
}

/// Immutable snapshot of all habits, rule versions and completions.
/// Answers "which habits are due on day X and were they done?".
final class HabitPlan {
  HabitPlan({
    required List<Habit> habits,
    required List<HabitRule> rules,
    required List<HabitCompletion> completions,
  }) : habits = List.unmodifiable(
         <Habit>[...habits]..sort((a, b) => a.sortOrder.compareTo(b.sortOrder)),
       ),
       _rulesByHabit = _groupRules(rules),
       _completions = {for (final c in completions) (c.habitId, c.date): c};

  static final HabitPlan empty = HabitPlan(
    habits: const [],
    rules: const [],
    completions: const [],
  );

  /// All habits incl. archived, by `sortOrder`.
  final List<Habit> habits;
  final Map<String, List<HabitRule>> _rulesByHabit;
  final Map<(String, LocalDate), HabitCompletion> _completions;

  static Map<String, List<HabitRule>> _groupRules(List<HabitRule> rules) {
    final map = <String, List<HabitRule>>{};
    for (final r in rules) {
      (map[r.habitId] ??= []).add(r);
    }
    for (final list in map.values) {
      list.sort((a, b) => a.validFrom.compareTo(b.validFrom));
    }
    return {for (final e in map.entries) e.key: List.unmodifiable(e.value)};
  }

  /// Habits that are not archived (what the list screen shows).
  List<Habit> get activeHabits =>
      habits.where((h) => !h.isArchived).toList(growable: false);

  Habit? habitById(String id) {
    for (final h in habits) {
      if (h.id == id) return h;
    }
    return null;
  }

  /// All rule versions of a habit, oldest first.
  List<HabitRule> rulesOf(String habitId) => _rulesByHabit[habitId] ?? const [];

  /// The rule version in effect on [date]: greatest `validFrom <= date`.
  HabitRule? ruleOn(String habitId, LocalDate date) {
    HabitRule? result;
    for (final r in rulesOf(habitId)) {
      if (r.validFrom.isAfter(date)) break;
      result = r;
    }
    return result;
  }

  /// The latest rule version (what the user edits).
  HabitRule? currentRule(String habitId) {
    final rules = rulesOf(habitId);
    return rules.isEmpty ? null : rules.last;
  }

  bool isCompleted(String habitId, LocalDate date) =>
      _completions.containsKey((habitId, date));

  /// Whether [habit] is due on [day]. Pure; the caller supplies the resolved
  /// shift so this layer never depends on the shift repository.
  HabitRule? dueRuleFor(Habit habit, ScheduledDay day) {
    if (habit.createdOn.isAfter(day.date)) return null;
    if (habit.isArchivedOn(day.date)) return null;
    final rule = ruleOn(habit.id, day.date);
    if (rule == null) return null;
    final matches = rule.matches(
      shiftTypeId: day.shift?.id,
      weekday: day.date.weekday,
    );
    return matches ? rule : null;
  }

  /// Habits due on [day], in list order, with completion state.
  List<DueHabit> dueOn(ScheduledDay day) => [
    for (final habit in habits)
      if (dueRuleFor(habit, day) case final rule?)
        DueHabit(
          habit: habit,
          rule: rule,
          date: day.date,
          isCompleted: isCompleted(habit.id, day.date),
        ),
  ];

  /// Convenience: due habits for [date] using [setup] to resolve the shift.
  List<DueHabit> dueOnDate(LocalDate date, ShiftSetup setup) =>
      dueOn(setup.dayOn(date));
}
