import '../../../../core/date/local_date.dart';
import '../../../device_calendar/domain/entities/shift_conflict.dart';

/// One local notification the app wants delivered.
final class PlannedReminder {
  const PlannedReminder({
    required this.id,
    required this.habitId,
    required this.habitName,
    required this.date,
    required this.at,
    this.shiftTypeId,
  }) : conflicts = const [];

  /// Evening-before warning about appointments that overlap the shift on
  /// [date]. Delivered at [at] on the previous day.
  PlannedReminder.conflict({
    required this.date,
    required this.at,
    required this.conflicts,
  }) : id = idFor(conflictKey, date),
       habitId = '',
       habitName = '',
       shiftTypeId = conflicts.first.shift.id;

  /// Pseudo habit id that keeps conflict notification ids apart from habit
  /// ones.
  static const String conflictKey = 'shift-conflict';

  /// Stable notification id derived from habit and date, so rescheduling
  /// the same reminder replaces instead of duplicating it.
  final int id;
  final String habitId;
  final String habitName;

  /// The calendar day the reminder is for.
  final LocalDate date;

  /// Delivery instant in the device's local time zone.
  final DateTime at;

  /// Shift on that day, if any (used for the notification body).
  final String? shiftTypeId;

  /// Non-empty for a conflict warning instead of a habit reminder.
  final List<ShiftConflict> conflicts;

  bool get isConflictWarning => conflicts.isNotEmpty;

  static int idFor(String habitId, LocalDate date) {
    // 31-bit FNV-1a over "habitId|date": fits Android's int ids.
    var hash = 0x811C9DC5;
    for (final unit in '$habitId|${date.toIsoString()}'.codeUnits) {
      hash ^= unit;
      hash = (hash * 0x01000193) & 0x7FFFFFFF;
    }
    return hash;
  }

  @override
  bool operator ==(Object other) =>
      other is PlannedReminder &&
      other.id == id &&
      other.habitId == habitId &&
      other.date == date &&
      other.at == at;

  @override
  int get hashCode => Object.hash(id, habitId, date, at);

  @override
  String toString() => 'PlannedReminder($habitName, $at)';
}
