import '../../../../core/date/local_date.dart';
import '../../../shifts/domain/entities/shift_setup.dart';
import '../entities/habit.dart';
import '../entities/habit_plan.dart';

/// Success numbers for one habit over a date range.
final class HabitStats {
  const HabitStats({
    required this.habit,
    required this.dueDays,
    required this.completedDays,
    required this.currentStreak,
    required this.bestStreak,
  });

  final Habit habit;

  /// Days in the range on which the habit was due.
  final int dueDays;
  final int completedDays;

  /// Consecutive due days completed, counted backwards from the range end.
  /// A due day that is still today and not yet completed does not break
  /// the streak.
  final int currentStreak;
  final int bestStreak;

  /// `completed / due`, or `null` when nothing was due (never 0 % for
  /// "not applicable").
  double? get rate => dueDays == 0 ? null : completedDays / dueDays;

  int get missedDays => dueDays - completedDays;
}

/// Overall numbers across all habits for a range.
final class OverallStats {
  const OverallStats({required this.dueDays, required this.completedDays});

  final int dueDays;
  final int completedDays;

  double? get rate => dueDays == 0 ? null : completedDays / dueDays;
}

/// Pure statistics over a [HabitPlan] and [ShiftSetup]. Only due days count;
/// a day on which a habit is not due never lowers the rate.
abstract final class HabitStatistics {
  /// Stats for [habit] over `from … to` (inclusive). [today] caps the range
  /// (future days are never counted) and keeps today's open item from
  /// breaking the current streak.
  static HabitStats forHabit({
    required Habit habit,
    required HabitPlan plan,
    required ShiftSetup setup,
    required LocalDate from,
    required LocalDate to,
    required LocalDate today,
  }) {
    final end = to.isAfter(today) ? today : to;
    var due = 0;
    var done = 0;
    var best = 0;
    var run = 0;
    final dueFlags = <bool>[]; // completion per due day, chronological
    for (var d = from; !d.isAfter(end); d = d.addDays(1)) {
      final day = setup.dayOn(d);
      if (plan.dueRuleFor(habit, day) == null) continue;
      due++;
      final completed = plan.isCompleted(habit.id, d);
      dueFlags.add(completed);
      if (completed) {
        done++;
        run++;
        if (run > best) best = run;
      } else {
        run = 0;
      }
    }
    var current = 0;
    for (var i = dueFlags.length - 1; i >= 0; i--) {
      if (dueFlags[i]) {
        current++;
      } else if (i == dueFlags.length - 1 && end == today) {
        // Today is due but still open: look further back.
        continue;
      } else {
        break;
      }
    }
    return HabitStats(
      habit: habit,
      dueDays: due,
      completedDays: done,
      currentStreak: current,
      bestStreak: best,
    );
  }

  static List<HabitStats> forAll({
    required HabitPlan plan,
    required ShiftSetup setup,
    required LocalDate from,
    required LocalDate to,
    required LocalDate today,
  }) => [
    for (final habit in plan.habits)
      if (!habit.isArchived || !habit.archivedOn!.isBefore(from))
        forHabit(
          habit: habit,
          plan: plan,
          setup: setup,
          from: from,
          to: to,
          today: today,
        ),
  ];

  static OverallStats overall(List<HabitStats> stats) => OverallStats(
    dueDays: stats.fold(0, (sum, s) => sum + s.dueDays),
    completedDays: stats.fold(0, (sum, s) => sum + s.completedDays),
  );
}
