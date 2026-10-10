import 'package:flutter_test/flutter_test.dart';
import 'package:rytmavo/core/date/local_date.dart';
import 'package:rytmavo/features/device_calendar/domain/entities/calendar_event.dart';
import 'package:rytmavo/features/device_calendar/domain/entities/shift_conflict.dart';
import 'package:rytmavo/features/reminders/domain/entities/planned_reminder.dart';
import 'package:rytmavo/features/reminders/domain/services/reminder_planner.dart';
import 'package:rytmavo/features/shifts/domain/entities/shift_type.dart';

void main() {
  final early = ShiftType.defaults.first;
  ShiftConflict conflict(LocalDate date, String id) {
    final d = date.toLocalDateTime();
    return ShiftConflict(
      date: date,
      shift: early,
      shiftStart: d.add(const Duration(hours: 6)),
      shiftEnd: d.add(const Duration(hours: 14)),
      event: CalendarEvent(
        id: id,
        calendarId: 'c',
        title: id,
        start: d.add(const Duration(hours: 9)),
        end: d.add(const Duration(hours: 10)),
      ),
    );
  }

  test('one warning per shift day at 18:00 the evening before', () {
    final now = DateTime(2026, 3, 2, 12);
    final reminders = ReminderPlanner.planConflicts(
      conflicts: [
        conflict(const LocalDate(2026, 3, 4), 'b'),
        conflict(const LocalDate(2026, 3, 3), 'a1'),
        conflict(const LocalDate(2026, 3, 3), 'a2'),
      ],
      now: now,
    );
    expect(reminders.map((r) => r.at), [
      DateTime(2026, 3, 2, 18),
      DateTime(2026, 3, 3, 18),
    ]);
    expect(reminders.first.isConflictWarning, isTrue);
    expect(reminders.first.conflicts.map((c) => c.event.id), ['a1', 'a2']);
    expect(reminders.first.shiftTypeId, 'early');
    expect(reminders.map((r) => r.id).toSet(), hasLength(2));
  });

  test('warnings whose evening has passed are dropped', () {
    final reminders = ReminderPlanner.planConflicts(
      conflicts: [conflict(const LocalDate(2026, 3, 3), 'a')],
      now: DateTime(2026, 3, 2, 18, 30),
    );
    expect(reminders, isEmpty);
  });

  test('conflict ids never collide with habit reminder ids', () {
    const date = LocalDate(2026, 3, 3);
    expect(
      PlannedReminder.idFor(PlannedReminder.conflictKey, date),
      isNot(PlannedReminder.idFor('h', date)),
    );
  });
}
