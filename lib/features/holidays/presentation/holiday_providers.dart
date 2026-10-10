import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../settings/presentation/controllers/settings_controller.dart';
import '../data/school_holiday_data.dart';
import '../domain/services/holiday_calendar.dart';

/// Public and school holidays for the user's state. Only rebuilt when a
/// holiday preference changes.
final holidayCalendarProvider = Provider<HolidayCalendar>((ref) {
  final prefs = ref.watch(
    settingsControllerProvider.select(
      (s) => (
        state: s.value?.holidayState,
        school: s.value?.showSchoolHolidays ?? false,
        daysOff: s.value?.holidaysAreDaysOff ?? false,
      ),
    ),
  );
  return HolidayCalendar(
    state: prefs.state,
    showSchoolHolidays: prefs.school,
    holidaysAreDaysOff: prefs.daysOff,
    schoolHolidays: schoolHolidayData,
  );
});
