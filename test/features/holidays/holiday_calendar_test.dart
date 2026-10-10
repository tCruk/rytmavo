import 'package:flutter_test/flutter_test.dart';
import 'package:rytmavo/core/date/local_date.dart';
import 'package:rytmavo/features/holidays/data/school_holiday_data.dart';
import 'package:rytmavo/features/holidays/domain/entities/german_state.dart';
import 'package:rytmavo/features/holidays/domain/entities/public_holiday.dart';
import 'package:rytmavo/features/holidays/domain/entities/school_holiday.dart';
import 'package:rytmavo/features/holidays/domain/services/holiday_calendar.dart';

void main() {
  HolidayCalendar calendar(
    GermanState? state, {
    bool school = true,
    bool daysOff = false,
  }) => HolidayCalendar(
    state: state,
    showSchoolHolidays: school,
    holidaysAreDaysOff: daysOff,
    schoolHolidays: schoolHolidayData,
  );

  test('nationwide holidays are marked without a state', () {
    final c = calendar(null);
    expect(
      c.marksOn(const LocalDate(2026, 10, 3)).publicHoliday?.kind,
      PublicHolidayKind.germanUnity,
    );
    // Corpus Christi is regional.
    expect(c.marksOn(const LocalDate(2026, 6, 4)).publicHoliday, isNull);
    // No school holidays without a state.
    expect(c.schoolHolidayOn(const LocalDate(2026, 8, 1)), isNull);
    expect(c.schoolDataEnd, isNull);
  });

  test('school holidays of the chosen state, inclusive bounds', () {
    final c = calendar(GermanState.nw);
    expect(c.schoolHolidayOn(const LocalDate(2026, 10, 16)), isNull);
    expect(
      c.schoolHolidayOn(const LocalDate(2026, 10, 17))?.kind,
      SchoolHolidayKind.autumn,
    );
    expect(
      c.schoolHolidayOn(const LocalDate(2026, 10, 31))?.kind,
      SchoolHolidayKind.autumn,
    );
    expect(c.schoolHolidayOn(const LocalDate(2026, 11, 1)), isNull);
    // Christmas holidays across the year boundary.
    expect(
      c.schoolHolidayOn(const LocalDate(2027, 1, 4))?.kind,
      SchoolHolidayKind.christmas,
    );
    // Both marks on one day.
    final marks = c.marksOn(const LocalDate(2026, 12, 25));
    expect(marks.publicHoliday?.kind, PublicHolidayKind.christmas);
    expect(marks.schoolHoliday?.kind, SchoolHolidayKind.christmas);
  });

  test('school holidays can be switched off', () {
    final c = calendar(GermanState.nw, school: false);
    expect(c.schoolHolidayOn(const LocalDate(2026, 10, 20)), isNull);
    expect(c.publicHolidayOn(const LocalDate(2026, 11, 1)), isNotNull);
  });

  test('island-only and vocational-school periods are not used', () {
    // Schleswig-Holstein islands start autumn holidays on 5 Oct 2026, the
    // mainland on 12 Oct.
    final sh = calendar(GermanState.sh);
    expect(sh.schoolHolidayOn(const LocalDate(2026, 10, 5)), isNull);
    expect(sh.schoolHolidayOn(const LocalDate(2026, 10, 12)), isNotNull);
    // Mecklenburg-Vorpommern: general schools have Whitsun holidays,
    // vocational schools do not.
    final mv = calendar(GermanState.mv);
    expect(
      mv.schoolHolidayOn(const LocalDate(2026, 5, 22))?.kind,
      SchoolHolidayKind.whitsun,
    );
  });

  test('days off only when chosen', () {
    expect(calendar(null).isDayOff(const LocalDate(2026, 10, 3)), isFalse);
    final c = calendar(GermanState.by, daysOff: true);
    expect(c.isDayOff(const LocalDate(2026, 10, 3)), isTrue);
    expect(c.isDayOff(const LocalDate(2026, 1, 6)), isTrue);
    expect(c.isDayOff(const LocalDate(2026, 1, 7)), isFalse);
  });

  test('bundled data is consistent for every state', () {
    expect(schoolHolidayData.keys.toSet(), GermanState.values.toSet());
    for (final MapEntry(key: state, value: periods)
        in schoolHolidayData.entries) {
      for (var i = 0; i < periods.length; i++) {
        final p = periods[i];
        expect(p.end.isBefore(p.start), isFalse, reason: '$state $p');
        // Not longer than any real holiday (summer ≈ 6.5 weeks).
        expect(p.end.daysSince(p.start), lessThan(50), reason: '$state $p');
        if (i > 0) {
          expect(
            periods[i - 1].start.isAfter(p.start),
            isFalse,
            reason: 'sorted: $state $p',
          );
        }
      }
      for (var year = 2025; year <= 2030; year++) {
        expect(
          periods.where(
            (p) => p.kind == SchoolHolidayKind.summer && p.start.year == year,
          ),
          hasLength(1),
          reason: '$state summer $year',
        );
      }
      expect(
        calendar(state).schoolDataEnd!.isBefore(const LocalDate(2030, 8, 1)),
        isFalse,
        reason: '$state data end',
      );
    }
  });
}
