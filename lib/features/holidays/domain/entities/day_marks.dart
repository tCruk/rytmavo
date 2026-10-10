import 'public_holiday.dart';
import 'school_holiday.dart';

/// What the calendar marks on one day besides the shift.
final class DayMarks {
  const DayMarks({this.publicHoliday, this.schoolHoliday});

  static const DayMarks none = DayMarks();

  final PublicHoliday? publicHoliday;
  final SchoolHolidayPeriod? schoolHoliday;

  bool get isEmpty => publicHoliday == null && schoolHoliday == null;

  @override
  bool operator ==(Object other) =>
      other is DayMarks &&
      other.publicHoliday == publicHoliday &&
      other.schoolHoliday == schoolHoliday;

  @override
  int get hashCode => Object.hash(publicHoliday, schoolHoliday);
}
