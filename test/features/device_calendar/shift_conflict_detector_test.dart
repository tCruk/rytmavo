import 'package:flutter_test/flutter_test.dart';
import 'package:rytmavo/core/date/local_date.dart';
import 'package:rytmavo/features/device_calendar/domain/entities/calendar_event.dart';
import 'package:rytmavo/features/device_calendar/domain/services/shift_conflict_detector.dart';
import 'package:rytmavo/features/shifts/domain/entities/rotation_pattern.dart';
import 'package:rytmavo/features/shifts/domain/entities/rotation_preset.dart';
import 'package:rytmavo/features/shifts/domain/entities/shift_override.dart';
import 'package:rytmavo/features/shifts/domain/entities/shift_setup.dart';
import 'package:rytmavo/features/shifts/domain/entities/shift_type.dart';
import 'package:rytmavo/features/shifts/domain/services/rotation_rules.dart';

void main() {
  // Monday 2026-03-02 = slot 0 of conti4: E E L L N N O O
  // early 06–14, late 14–22, night 22–06.
  const anchor = LocalDate(2026, 3, 2);
  ShiftSetup setup({List<ShiftOverride> overrides = const []}) => ShiftSetup(
    types: [
      ...ShiftType.defaults,
      const ShiftType(
        id: 'custom',
        kind: ShiftKind.custom,
        colorValue: 0xFF000000,
        sortOrder: 4,
        name: 'Bereitschaft',
      ),
    ],
    patterns: [
      RotationPattern(
        id: 'p',
        validFrom: RotationRules.firstVersionValidFrom,
        anchorDate: anchor,
        slots: RotationPreset.conti4.slots,
      ),
    ],
    overrides: overrides,
  );

  var seq = 0;
  CalendarEvent event(DateTime start, DateTime end, {bool allDay = false}) =>
      CalendarEvent(
        id: 'e${seq++}',
        calendarId: 'c',
        title: 'Termin',
        start: start,
        end: end,
        isAllDay: allDay,
      );

  test('event inside an early shift conflicts', () {
    final e = event(DateTime(2026, 3, 2, 10), DateTime(2026, 3, 2, 11));
    final conflicts = ShiftConflictDetector.detect(
      setup: setup(),
      events: [e],
      from: anchor,
      days: 1,
    );
    expect(conflicts, hasLength(1));
    expect(conflicts.single.date, anchor);
    expect(conflicts.single.shift.id, 'early');
    expect(conflicts.single.shiftStart, DateTime(2026, 3, 2, 6));
    expect(conflicts.single.shiftEnd, DateTime(2026, 3, 2, 14));
    expect(conflicts.single.event, e);
  });

  test('touching the shift edges is no conflict', () {
    final before = event(DateTime(2026, 3, 2, 5), DateTime(2026, 3, 2, 6));
    final after = event(DateTime(2026, 3, 2, 14), DateTime(2026, 3, 2, 15));
    expect(
      ShiftConflictDetector.detect(
        setup: setup(),
        events: [before, after],
        from: anchor,
        days: 1,
      ),
      isEmpty,
    );
  });

  test('partial overlap at either end conflicts', () {
    final start = event(DateTime(2026, 3, 2, 5), DateTime(2026, 3, 2, 7));
    final end = event(DateTime(2026, 3, 2, 13), DateTime(2026, 3, 2, 16));
    expect(
      ShiftConflictDetector.detect(
        setup: setup(),
        events: [end, start],
        from: anchor,
        days: 1,
      ).map((c) => c.event),
      [start, end],
    );
  });

  test('night shift: next-morning event belongs to the start day', () {
    // 2026-03-06 is a night shift (22:00 → 06:00 on 03-07).
    final e = event(DateTime(2026, 3, 7, 2), DateTime(2026, 3, 7, 3));
    final conflicts = ShiftConflictDetector.detect(
      setup: setup(),
      events: [e],
      from: const LocalDate(2026, 3, 6),
      days: 1,
    );
    expect(conflicts.single.date, const LocalDate(2026, 3, 6));
    expect(conflicts.single.shiftEnd, DateTime(2026, 3, 7, 6));
  });

  test('event range covers the morning after the last day', () {
    final range = ShiftConflictDetector.eventRange(
      const LocalDate(2026, 3, 6),
      1,
    );
    expect(range.start, DateTime(2026, 3, 6));
    expect(range.end, DateTime(2026, 3, 8));
  });

  test('days off, all-day events and shifts without times are ignored', () {
    // 2026-03-08 is off.
    final onDayOff = event(DateTime(2026, 3, 8, 10), DateTime(2026, 3, 8, 11));
    final allDay = event(
      DateTime(2026, 3, 2),
      DateTime(2026, 3, 3),
      allDay: true,
    );
    final onCustom = event(DateTime(2026, 3, 3, 10), DateTime(2026, 3, 3, 11));
    expect(
      ShiftConflictDetector.detect(
        setup: setup(
          overrides: [
            const ShiftOverride(
              date: LocalDate(2026, 3, 3),
              shiftTypeId: 'custom',
            ),
          ],
        ),
        events: [onDayOff, allDay, onCustom],
        from: anchor,
        days: 8,
      ),
      isEmpty,
    );
  });

  test('overrides decide the working time', () {
    // Day off 2026-03-08 overridden to late (14–22).
    final e = event(DateTime(2026, 3, 8, 15), DateTime(2026, 3, 8, 16));
    final conflicts = ShiftConflictDetector.detect(
      setup: setup(
        overrides: [
          const ShiftOverride(date: LocalDate(2026, 3, 8), shiftTypeId: 'late'),
        ],
      ),
      events: [e],
      from: const LocalDate(2026, 3, 8),
      days: 1,
    );
    expect(conflicts.single.shift.id, 'late');
  });

  test('a long event conflicts with every shift it spans', () {
    final trip = event(DateTime(2026, 3, 2, 12), DateTime(2026, 3, 4, 15));
    final conflicts = ShiftConflictDetector.detect(
      setup: setup(),
      events: [trip],
      from: anchor,
      days: 3,
    );
    expect(conflicts.map((c) => c.date), const [
      LocalDate(2026, 3, 2),
      LocalDate(2026, 3, 3),
      LocalDate(2026, 3, 4),
    ]);
  });
}
