import '../../../../core/date/local_date.dart';
import '../../../device_calendar/domain/entities/shift_conflict.dart';
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
    return capped(result);
  }

  /// Hour on the evening before a shift at which appointment conflicts
  /// are announced.
  static const int conflictWarningHour = 18;

  /// One warning per shift day with overlapping appointments, delivered at
  /// [conflictWarningHour] on the day before. Warnings whose time has
  /// passed are dropped; the app shows the conflict anyway.
  static List<PlannedReminder> planConflicts({
    required List<ShiftConflict> conflicts,
    required DateTime now,
  }) {
    final byDate = <LocalDate, List<ShiftConflict>>{};
    for (final c in conflicts) {
      (byDate[c.date] ??= []).add(c);
    }
    final result = <PlannedReminder>[];
    for (final MapEntry(key: date, value: dayConflicts) in byDate.entries) {
      final eve = date.addDays(-1);
      final at = DateTime(eve.year, eve.month, eve.day, conflictWarningHour);
      if (!at.isAfter(now)) continue;
      result.add(
        PlannedReminder.conflict(
          date: date,
          at: at,
          conflicts: List.unmodifiable(dayConflicts),
        ),
      );
    }
    return capped(result);
  }

  /// Sorts by delivery time and keeps the earliest [maxScheduled].
  static List<PlannedReminder> capped(List<PlannedReminder> reminders) {
    final sorted = [...reminders]..sort((a, b) => a.at.compareTo(b.at));
    return sorted.length > maxScheduled
        ? sorted.sublist(0, maxScheduled)
        : sorted;
  }
}
