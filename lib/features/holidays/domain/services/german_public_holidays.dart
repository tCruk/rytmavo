import '../../../../core/date/local_date.dart';
import '../entities/german_state.dart';
import '../entities/public_holiday.dart';

/// Computes German statutory public holidays offline: fixed dates plus the
/// movable feasts derived from Easter (Gregorian computus).
///
/// Holidays that only apply in some municipalities (Assumption in parts of
/// Bavaria, Corpus Christi in parts of Saxony and Thuringia, Augsburg's
/// Peace Festival) are not included, because the app only knows the state.
abstract final class GermanPublicHolidays {
  /// Holidays of [year], sorted by date. With [state] `null` only the
  /// nationwide holidays are returned.
  static List<PublicHoliday> forYear(int year, {GermanState? state}) {
    final easter = easterSunday(year);
    final result = <PublicHoliday>[];

    void add(
      LocalDate date,
      PublicHolidayKind kind, {
      bool nationwide = false,
      Set<GermanState> states = const {},
    }) {
      if (nationwide || states.contains(state)) {
        result.add(
          PublicHoliday(date: date, kind: kind, nationwide: nationwide),
        );
      }
    }

    Set<GermanState> only(List<GermanState> list) => list.toSet();

    add(LocalDate(year, 1, 1), PublicHolidayKind.newYear, nationwide: true);
    add(
      LocalDate(year, 1, 6),
      PublicHolidayKind.epiphany,
      states: only([GermanState.bw, GermanState.by, GermanState.st]),
    );
    add(
      LocalDate(year, 3, 8),
      PublicHolidayKind.womensDay,
      states: {
        if (year >= 2019) GermanState.be,
        if (year >= 2023) GermanState.mv,
      },
    );
    add(easter.addDays(-2), PublicHolidayKind.goodFriday, nationwide: true);
    add(easter, PublicHolidayKind.easterSunday, states: only([GermanState.bb]));
    add(easter.addDays(1), PublicHolidayKind.easterMonday, nationwide: true);
    add(LocalDate(year, 5, 1), PublicHolidayKind.labourDay, nationwide: true);
    add(
      LocalDate(year, 5, 8),
      PublicHolidayKind.liberationDay,
      states: {if (year == 2020 || year == 2025) GermanState.be},
    );
    add(easter.addDays(39), PublicHolidayKind.ascension, nationwide: true);
    add(
      easter.addDays(49),
      PublicHolidayKind.whitSunday,
      states: only([GermanState.bb]),
    );
    add(easter.addDays(50), PublicHolidayKind.whitMonday, nationwide: true);
    add(
      easter.addDays(60),
      PublicHolidayKind.corpusChristi,
      states: only([
        GermanState.bw,
        GermanState.by,
        GermanState.he,
        GermanState.nw,
        GermanState.rp,
        GermanState.sl,
      ]),
    );
    add(
      LocalDate(year, 8, 15),
      PublicHolidayKind.assumption,
      states: only([GermanState.sl]),
    );
    add(
      LocalDate(year, 9, 20),
      PublicHolidayKind.childrensDay,
      states: {if (year >= 2019) GermanState.th},
    );
    if (year >= 1990) {
      add(
        LocalDate(year, 10, 3),
        PublicHolidayKind.germanUnity,
        nationwide: true,
      );
    }
    add(
      LocalDate(year, 10, 31),
      PublicHolidayKind.reformation,
      // 500th anniversary of the Reformation: once nationwide.
      nationwide: year == 2017,
      states: {
        GermanState.bb,
        GermanState.mv,
        GermanState.sn,
        GermanState.st,
        GermanState.th,
        if (year >= 2018) ...[
          GermanState.hb,
          GermanState.hh,
          GermanState.ni,
          GermanState.sh,
        ],
      },
    );
    add(
      LocalDate(year, 11, 1),
      PublicHolidayKind.allSaints,
      states: only([
        GermanState.bw,
        GermanState.by,
        GermanState.nw,
        GermanState.rp,
        GermanState.sl,
      ]),
    );
    add(
      repentanceDay(year),
      PublicHolidayKind.repentance,
      // Nationwide until 1994, since then only in Saxony.
      nationwide: year <= 1994,
      states: {if (year > 1994) GermanState.sn},
    );
    add(LocalDate(year, 12, 25), PublicHolidayKind.christmas, nationwide: true);
    add(LocalDate(year, 12, 26), PublicHolidayKind.boxingDay, nationwide: true);

    result.sort((a, b) => a.date.compareTo(b.date));
    return result;
  }

  /// Easter Sunday in the Gregorian calendar (anonymous Gregorian
  /// algorithm, valid for all years after 1582).
  static LocalDate easterSunday(int year) {
    final a = year % 19;
    final b = year ~/ 100;
    final c = year % 100;
    final d = b ~/ 4;
    final e = b % 4;
    final f = (b + 8) ~/ 25;
    final g = (b - f + 1) ~/ 3;
    final h = (19 * a + b - d - g + 15) % 30;
    final i = c ~/ 4;
    final k = c % 4;
    final l = (32 + 2 * e + 2 * i - h - k) % 7;
    final m = (a + 11 * h + 22 * l) ~/ 451;
    final month = (h + l - 7 * m + 114) ~/ 31;
    final day = (h + l - 7 * m + 114) % 31 + 1;
    return LocalDate(year, month, day);
  }

  /// Day of Repentance and Prayer: the Wednesday before 23 November.
  static LocalDate repentanceDay(int year) {
    final nov22 = LocalDate(year, 11, 22);
    // ISO weekday: Wednesday = 3.
    return nov22.addDays(-floorMod(nov22.weekday - 3, 7));
  }
}
