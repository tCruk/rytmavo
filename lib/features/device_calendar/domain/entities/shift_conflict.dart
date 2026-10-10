import '../../../../core/date/local_date.dart';
import '../../../shifts/domain/entities/shift_type.dart';
import 'calendar_event.dart';

/// A device calendar event that overlaps the working time of a shift.
final class ShiftConflict {
  const ShiftConflict({
    required this.date,
    required this.shift,
    required this.shiftStart,
    required this.shiftEnd,
    required this.event,
  });

  /// The day the shift belongs to (its start day, also for night shifts).
  final LocalDate date;
  final ShiftType shift;
  final DateTime shiftStart;
  final DateTime shiftEnd;
  final CalendarEvent event;

  @override
  bool operator ==(Object other) =>
      other is ShiftConflict &&
      other.date == date &&
      other.shift == shift &&
      other.shiftStart == shiftStart &&
      other.shiftEnd == shiftEnd &&
      other.event == event;

  @override
  int get hashCode => Object.hash(date, shift, shiftStart, shiftEnd, event);

  @override
  String toString() => 'ShiftConflict($date, ${shift.id}, ${event.title})';
}
