import 'package:flutter_test/flutter_test.dart';
import 'package:rytmavo/core/date/local_date.dart';
import 'package:rytmavo/features/holidays/domain/entities/german_state.dart';
import 'package:rytmavo/features/holidays/domain/entities/public_holiday.dart';
import 'package:rytmavo/features/holidays/domain/services/german_public_holidays.dart';

void main() {
  Map<LocalDate, PublicHolidayKind> days(int year, [GermanState? state]) => {
    for (final h in GermanPublicHolidays.forYear(year, state: state))
      h.date: h.kind,
  };

  test('Easter Sunday matches published dates', () {
    const known = {
      2000: LocalDate(2000, 4, 23),
      2008: LocalDate(2008, 3, 23), // early Easter
      2011: LocalDate(2011, 4, 24), // late Easter
      2019: LocalDate(2019, 4, 21),
      2024: LocalDate(2024, 3, 31),
      2025: LocalDate(2025, 4, 20),
      2026: LocalDate(2026, 4, 5),
      2027: LocalDate(2027, 3, 28),
      2038: LocalDate(2038, 4, 25),
    };
    known.forEach((year, date) {
      expect(GermanPublicHolidays.easterSunday(year), date, reason: '$year');
    });
  });

  test('nine nationwide holidays in 2026, movable ones from Easter', () {
    final d = days(2026);
    expect(d, {
      const LocalDate(2026, 1, 1): PublicHolidayKind.newYear,
      const LocalDate(2026, 4, 3): PublicHolidayKind.goodFriday,
      const LocalDate(2026, 4, 6): PublicHolidayKind.easterMonday,
      const LocalDate(2026, 5, 1): PublicHolidayKind.labourDay,
      const LocalDate(2026, 5, 14): PublicHolidayKind.ascension,
      const LocalDate(2026, 5, 25): PublicHolidayKind.whitMonday,
      const LocalDate(2026, 10, 3): PublicHolidayKind.germanUnity,
      const LocalDate(2026, 12, 25): PublicHolidayKind.christmas,
      const LocalDate(2026, 12, 26): PublicHolidayKind.boxingDay,
    });
    expect(
      GermanPublicHolidays.forYear(2026).every((h) => h.nationwide),
      isTrue,
    );
  });

  test('state holidays are added and flagged as regional', () {
    final nw = GermanPublicHolidays.forYear(2026, state: GermanState.nw);
    expect(nw, hasLength(11));
    final regional = nw.where((h) => !h.nationwide).map((h) => h.kind);
    expect(regional, [
      PublicHolidayKind.corpusChristi, // 4 June
      PublicHolidayKind.allSaints,
    ]);
    expect(days(2026, GermanState.nw)[const LocalDate(2026, 6, 4)], isNotNull);

    expect(days(2026, GermanState.by), hasLength(12));
    expect(days(2026, GermanState.bw), hasLength(12));
    expect(
      days(2026, GermanState.sl)[const LocalDate(2026, 8, 15)],
      PublicHolidayKind.assumption,
    );
    expect(
      days(2026, GermanState.th)[const LocalDate(2026, 9, 20)],
      PublicHolidayKind.childrensDay,
    );
    expect(
      days(2026, GermanState.bb)[const LocalDate(2026, 4, 5)],
      PublicHolidayKind.easterSunday,
    );
    // Hamburg has no extra holiday besides Reformation Day.
    expect(days(2026, GermanState.hh), hasLength(10));
  });

  test('Day of Repentance is the Wednesday before 23 November', () {
    expect(
      GermanPublicHolidays.repentanceDay(2026),
      const LocalDate(2026, 11, 18),
    );
    // 22 November itself is a Wednesday.
    expect(
      GermanPublicHolidays.repentanceDay(2023),
      const LocalDate(2023, 11, 22),
    );
    expect(
      days(2026, GermanState.sn)[const LocalDate(2026, 11, 18)],
      PublicHolidayKind.repentance,
    );
    expect(days(2026, GermanState.by)[const LocalDate(2026, 11, 18)], isNull);
  });

  test('holidays introduced later respect their first year', () {
    expect(days(2018, GermanState.be)[const LocalDate(2018, 3, 8)], isNull);
    expect(days(2019, GermanState.be)[const LocalDate(2019, 3, 8)], isNotNull);
    expect(days(2022, GermanState.mv)[const LocalDate(2022, 3, 8)], isNull);
    expect(days(2023, GermanState.mv)[const LocalDate(2023, 3, 8)], isNotNull);
    expect(
      days(2017, GermanState.ni)[const LocalDate(2017, 10, 31)],
      PublicHolidayKind.reformation,
    );
    expect(days(2016, GermanState.ni)[const LocalDate(2016, 10, 31)], isNull);
    expect(
      days(2018, GermanState.ni)[const LocalDate(2018, 10, 31)],
      isNotNull,
    );
    // 2017: Reformation Day once nationwide.
    expect(days(2017)[const LocalDate(2017, 10, 31)], isNotNull);
    expect(
      days(2025, GermanState.be)[const LocalDate(2025, 5, 8)],
      PublicHolidayKind.liberationDay,
    );
    expect(days(2026, GermanState.be)[const LocalDate(2026, 5, 8)], isNull);
  });

  test('results are sorted and cover the year boundary cleanly', () {
    for (final state in [null, ...GermanState.values]) {
      final list = GermanPublicHolidays.forYear(2027, state: state);
      for (var i = 1; i < list.length; i++) {
        expect(list[i - 1].date.isBefore(list[i].date), isTrue);
      }
      expect(list.first.date, const LocalDate(2027, 1, 1));
      expect(list.last.date, const LocalDate(2027, 12, 26));
    }
  });
}
