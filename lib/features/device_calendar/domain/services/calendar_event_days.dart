import '../../../../core/date/local_date.dart';
import '../entities/calendar_event.dart';

/// Assigns device calendar events to the local days they touch. Pure.
abstract final class CalendarEventDays {
  /// Events per day for `[from, from + days)`, each list ordered all-day
  /// first, then by start. A timed event appears on every day it overlaps
  /// (a 22:00–02:00 party shows on both days); an all-day event on each of
  /// its dates (its end is exclusive, as calendars store it).
  static Map<LocalDate, List<CalendarEvent>> group(
    List<CalendarEvent> events, {
    required LocalDate from,
    required int days,
  }) {
    final last = from.addDays(days - 1);
    final result = <LocalDate, List<CalendarEvent>>{};
    for (final e in events) {
      for (final date in _dates(e)) {
        if (date.isBefore(from)) continue;
        if (date.isAfter(last)) break;
        (result[date] ??= []).add(e);
      }
    }
    for (final list in result.values) {
      list.sort((a, b) {
        if (a.isAllDay != b.isAllDay) return a.isAllDay ? -1 : 1;
        return a.start.compareTo(b.start);
      });
    }
    return result;
  }

  static Iterable<LocalDate> _dates(CalendarEvent e) sync* {
    final first = LocalDate.fromDateTime(e.start);
    final LocalDate lastIncl;
    if (e.isAllDay) {
      // Floating dates: end is the exclusive day after the last one.
      final end = LocalDate.fromDateTime(e.end);
      lastIncl = end.isAfter(first) ? end.addDays(-1) : first;
    } else if (!e.end.isAfter(e.start)) {
      lastIncl = first;
    } else {
      // An event ending exactly at midnight does not touch the next day.
      final endDay = LocalDate.fromDateTime(e.end);
      final endsAtMidnight = e.end == endDay.toLocalDateTime();
      lastIncl = endsAtMidnight && endDay.isAfter(first)
          ? endDay.addDays(-1)
          : endDay;
    }
    // Guard against absurd ranges (multi-year events).
    final span = lastIncl.daysSince(first).clamp(0, 366);
    for (var i = 0; i <= span; i++) {
      yield first.addDays(i);
    }
  }
}
