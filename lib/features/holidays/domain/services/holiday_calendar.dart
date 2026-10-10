import '../../../../core/date/local_date.dart';
import '../entities/day_marks.dart';
import '../entities/german_state.dart';
import '../entities/public_holiday.dart';
import '../entities/school_holiday.dart';
import 'german_public_holidays.dart';

/// Answers "is day X a public holiday / within school holidays?" for the
/// user's state. Pure and offline; school holidays come from bundled data.
final class HolidayCalendar {
  HolidayCalendar({
    this.state,
    this.showSchoolHolidays = false,
    this.holidaysAreDaysOff = false,
    Map<GermanState, List<SchoolHolidayPeriod>> schoolHolidays = const {},
  }) : _schoolPeriods = state == null || !showSchoolHolidays
           ? const []
           : schoolHolidays[state] ?? const [];

  /// `null`: only the nationwide holidays.
  final GermanState? state;

  /// Whether school holidays are marked (requires [state]).
  final bool showSchoolHolidays;

  /// Whether public holidays replace work shifts with a day off.
  final bool holidaysAreDaysOff;

  final List<SchoolHolidayPeriod> _schoolPeriods;
  final Map<int, Map<LocalDate, PublicHoliday>> _byYear = {};

  PublicHoliday? publicHolidayOn(LocalDate date) => _byYear.putIfAbsent(
    date.year,
    () => {
      for (final h in GermanPublicHolidays.forYear(date.year, state: state))
        h.date: h,
    },
  )[date];

  /// The school holiday period containing [date], if marked.
  SchoolHolidayPeriod? schoolHolidayOn(LocalDate date) {
    for (final p in _schoolPeriods) {
      if (p.start.isAfter(date)) break;
      if (p.contains(date)) return p;
    }
    return null;
  }

  DayMarks marksOn(LocalDate date) {
    final holiday = publicHolidayOn(date);
    final school = schoolHolidayOn(date);
    if (holiday == null && school == null) return DayMarks.none;
    return DayMarks(publicHoliday: holiday, schoolHoliday: school);
  }

  /// True when the user is free on public holidays and [date] is one.
  bool isDayOff(LocalDate date) =>
      holidaysAreDaysOff && publicHolidayOn(date) != null;

  /// Last day covered by the bundled school holiday data, or `null` when
  /// school holidays are not shown.
  LocalDate? get schoolDataEnd {
    LocalDate? last;
    for (final p in _schoolPeriods) {
      if (last == null || p.end.isAfter(last)) last = p.end;
    }
    return last;
  }
}
