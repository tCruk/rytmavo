import '../../../../core/date/local_date.dart';
import '../../../habits/domain/entities/habit_plan.dart';
import '../../../habits/domain/entities/habit_rule.dart';
import '../../../shifts/domain/entities/shift_setup.dart';
import '../entities/planned_reminder.dart';

/// Computes the reminders for a rolling window of days. Pure: the caller
/// supplies "now" and the snapshots.
///
/// A habit is reminded on a day when it is due there, not yet completed,
/// and its rule carries a time for that day's shift (or the wildcard
/// [HabitRule.anyShiftReminderKey]).
abstract final class ReminderPlanner {
  /// Days ahead (including today) that get scheduled. Short enough to stay
  /// well under iOS's 64 pending notifications even with several habits.
  static const int windowDays = 14;

  /// Hard cap on scheduled notifications (iOS keeps at most 64).
  static const int maxScheduled = 60;

  static List<PlannedReminder> plan({
    required ShiftSetup setup,
    required HabitPlan plan,
    required DateTime now,
  }) {
    final today = LocalDate.fromDateTime(now);
    final result = <PlannedReminder>[];
    for (var i = 0; i < windowDays; i++) {
      final date = today.addDays(i);
      final day = setup.dayOn(date);
      for (final due in plan.dueOn(day)) {
        if (due.isCompleted) continue;
        final time = due.rule.reminderFor(day.shift?.id);
        if (time == null) continue;
        final at = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
        if (!at.isAfter(now)) continue;
        result.add(
          PlannedReminder(
            id: PlannedReminder.idFor(due.habit.id, date),
            habitId: due.habit.id,
            habitName: due.habit.name,
            date: date,
            at: at,
            shiftTypeId: day.shift?.id,
          ),
        );
      }
    }
    result.sort((a, b) => a.at.compareTo(b.at));
    return result.length > maxScheduled
        ? result.sublist(0, maxScheduled)
        : result;
  }
}
