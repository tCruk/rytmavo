import 'package:flutter_test/flutter_test.dart';
import 'package:rytmavo/core/date/local_date.dart';
import 'package:rytmavo/features/device_calendar/domain/entities/calendar_event.dart';
import 'package:rytmavo/features/device_calendar/domain/services/calendar_event_days.dart';

void main() {
  CalendarEvent e(
    String id,
    DateTime start,
    DateTime end, {
    bool allDay = false,
  }) => CalendarEvent(
    id: id,
    calendarId: 'c',
    title: id,
    start: start,
    end: end,
    isAllDay: allDay,
  );
  const from = LocalDate(2026, 10, 1);

  Map<LocalDate, List<String>> ids(
    List<CalendarEvent> events, {
    int days = 31,
  }) => CalendarEventDays.group(
    events,
    from: from,
    days: days,
  ).map((k, v) => MapEntry(k, v.map((x) => x.id).toList()));

  test('timed event lands on its day', () {
    expect(ids([e('a', DateTime(2026, 10, 5, 9), DateTime(2026, 10, 5, 10))]), {
      const LocalDate(2026, 10, 5): ['a'],
    });
  });

  test('event over midnight shows on both days', () {
    expect(
      ids([e('a', DateTime(2026, 10, 5, 22), DateTime(2026, 10, 6, 2))]).keys,
      [const LocalDate(2026, 10, 5), const LocalDate(2026, 10, 6)],
    );
  });

  test('ending exactly at midnight does not touch the next day', () {
    expect(
      ids([e('a', DateTime(2026, 10, 5, 22), DateTime(2026, 10, 6))]).keys,
      [const LocalDate(2026, 10, 5)],
    );
  });

  test('all-day end date is exclusive', () {
    expect(
      ids([e('a', DateTime(2026, 10, 5), DateTime(2026, 10, 7), allDay: true)])
          .keys,
      [const LocalDate(2026, 10, 5), const LocalDate(2026, 10, 6)],
    );
  });

  test('days outside the span are dropped; all-day sorts first', () {
    final grouped = ids([
      e('late', DateTime(2026, 9, 30, 20), DateTime(2026, 10, 1, 9)),
      e('allday', DateTime(2026, 10), DateTime(2026, 10, 2), allDay: true),
      e('next', DateTime(2026, 11, 1, 9), DateTime(2026, 11, 1, 10)),
    ]);
    expect(grouped, {
      const LocalDate(2026, 10, 1): ['allday', 'late'],
    });
  });

  test('year change', () {
    final grouped = CalendarEventDays.group(
      [e('nye', DateTime(2026, 12, 31, 22), DateTime(2027, 1, 1, 1))],
      from: const LocalDate(2026, 12, 31),
      days: 2,
    );
    expect(grouped.keys, [
      const LocalDate(2026, 12, 31),
      const LocalDate(2027, 1, 1),
    ]);
  });
}
