import '../../../../core/date/local_date.dart';
import '../../../shifts/domain/entities/scheduled_day.dart';
import '../../../shifts/domain/entities/shift_setup.dart';
import '../entities/calendar_event.dart';
import '../entities/shift_conflict.dart';

/// Finds calendar events that overlap working time. Pure.
///
/// Only work shifts with start and end time are checked; a night shift
/// (22:00–06:00) covers the evening of its own day and the morning of the
/// next. All-day events are ignored: birthdays or holidays are not
/// appointments, and an all-day entry would flag every shift that day.
abstract final class ShiftConflictDetector {
  /// The working time of [day], or `null` for days off, unknown days and
  /// shifts without times.
  static ({DateTime start, DateTime end})? workWindow(ScheduledDay day) {
    final shift = day.shift;
    if (shift == null || !shift.isWorkShift || !shift.hasTimes) return null;
    final d = day.date;
    final endDate = shift.crossesMidnight ? d.addDays(1) : d;
    return (
      start: DateTime(
        d.year,
        d.month,
        d.day,
        shift.start!.hour,
        shift.start!.minute,
      ),
      end: DateTime(
        endDate.year,
        endDate.month,
        endDate.day,
        shift.end!.hour,
        shift.end!.minute,
      ),
    );
  }

  /// The instant range whose events can collide with shifts on
  /// `[from, from + days)`: includes the next morning for a night shift on
  /// the last day.
  static ({DateTime start, DateTime end}) eventRange(LocalDate from, int days) {
    final last = from.addDays(days + 1);
    return (start: from.toLocalDateTime(), end: last.toLocalDateTime());
  }

  /// Conflicts for shifts on `[from, from + days)`, ordered by shift date
  /// and event start.
  static List<ShiftConflict> detect({
    required ShiftSetup setup,
    required List<CalendarEvent> events,
    required LocalDate from,
    required int days,
  }) {
    final timed = [
      for (final e in events)
        if (!e.isAllDay && e.end.isAfter(e.start)) e,
    ]..sort((a, b) => a.start.compareTo(b.start));
    if (timed.isEmpty) return const [];

    final result = <ShiftConflict>[];
    for (var i = 0; i < days; i++) {
      final day = setup.dayOn(from.addDays(i));
      final window = workWindow(day);
      if (window == null) continue;
      for (final event in timed) {
        if (!event.start.isBefore(window.end)) break;
        if (!event.end.isAfter(window.start)) continue;
        result.add(
          ShiftConflict(
            date: day.date,
            shift: day.shift!,
            shiftStart: window.start,
            shiftEnd: window.end,
            event: event,
          ),
        );
      }
    }
    return List.unmodifiable(result);
  }
}
