import '../../../holidays/domain/entities/german_state.dart';

enum AppThemeMode { system, light, dark }

/// `system` follows the device locale; otherwise a fixed UI language.
enum AppLanguage { system, de, en }

/// User preferences. Immutable; use [copyWith].
final class AppSettings {
  const AppSettings({
    this.themeMode = AppThemeMode.system,
    this.language = AppLanguage.system,
    this.onboardingCompleted = false,
    this.remindersEnabled = false,
    this.calendarConflictsEnabled = false,
    this.conflictCalendarIds = const [],
    this.conflictRemindersEnabled = false,
    this.holidayState,
    this.showSchoolHolidays = false,
    this.holidaysAreDaysOff = false,
    this.holidaySetupDone = false,
  });

  final AppThemeMode themeMode;
  final AppLanguage language;
  final bool onboardingCompleted;

  /// Global opt-in for local notifications. Individual reminders are
  /// configured per shift type / habit and only fire when this is true.
  final bool remindersEnabled;

  /// Read device calendar events and flag those that overlap a work shift.
  /// Turning it on asks the OS for calendar access.
  final bool calendarConflictsEnabled;

  /// Device calendars checked for conflicts; empty means all calendars.
  /// Ids are device-specific and therefore not part of backups.
  final List<String> conflictCalendarIds;

  /// Notify on the evening before a shift that has a conflicting event.
  /// Only effective while [remindersEnabled] is on.
  final bool conflictRemindersEnabled;

  /// State whose public (and school) holidays are marked; `null` marks
  /// only the nationwide public holidays.
  final GermanState? holidayState;

  /// Mark the school holidays of [holidayState] in the calendar.
  final bool showSchoolHolidays;

  /// Public holidays replace work shifts of the rotation with a day off.
  final bool holidaysAreDaysOff;

  /// The user answered the holiday questions once; until then the
  /// calendar asks.
  final bool holidaySetupDone;

  static const AppSettings defaults = AppSettings();

  AppSettings copyWith({
    AppThemeMode? themeMode,
    AppLanguage? language,
    bool? onboardingCompleted,
    bool? remindersEnabled,
    bool? calendarConflictsEnabled,
    List<String>? conflictCalendarIds,
    bool? conflictRemindersEnabled,
    GermanState? holidayState,
    bool clearHolidayState = false,
    bool? showSchoolHolidays,
    bool? holidaysAreDaysOff,
    bool? holidaySetupDone,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      language: language ?? this.language,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      remindersEnabled: remindersEnabled ?? this.remindersEnabled,
      calendarConflictsEnabled:
          calendarConflictsEnabled ?? this.calendarConflictsEnabled,
      conflictCalendarIds: conflictCalendarIds ?? this.conflictCalendarIds,
      conflictRemindersEnabled:
          conflictRemindersEnabled ?? this.conflictRemindersEnabled,
      holidayState: clearHolidayState
          ? null
          : holidayState ?? this.holidayState,
      showSchoolHolidays: showSchoolHolidays ?? this.showSchoolHolidays,
      holidaysAreDaysOff: holidaysAreDaysOff ?? this.holidaysAreDaysOff,
      holidaySetupDone: holidaySetupDone ?? this.holidaySetupDone,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is AppSettings &&
      other.themeMode == themeMode &&
      other.language == language &&
      other.onboardingCompleted == onboardingCompleted &&
      other.remindersEnabled == remindersEnabled &&
      other.calendarConflictsEnabled == calendarConflictsEnabled &&
      _sameIds(other.conflictCalendarIds, conflictCalendarIds) &&
      other.conflictRemindersEnabled == conflictRemindersEnabled &&
      other.holidayState == holidayState &&
      other.showSchoolHolidays == showSchoolHolidays &&
      other.holidaysAreDaysOff == holidaysAreDaysOff &&
      other.holidaySetupDone == holidaySetupDone;

  @override
  int get hashCode => Object.hash(
    themeMode,
    language,
    onboardingCompleted,
    remindersEnabled,
    calendarConflictsEnabled,
    Object.hashAll(conflictCalendarIds),
    conflictRemindersEnabled,
    holidayState,
    showSchoolHolidays,
    holidaysAreDaysOff,
    holidaySetupDone,
  );

  static bool _sameIds(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
