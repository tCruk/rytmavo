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

  static const AppSettings defaults = AppSettings();

  AppSettings copyWith({
    AppThemeMode? themeMode,
    AppLanguage? language,
    bool? onboardingCompleted,
    bool? remindersEnabled,
    bool? calendarConflictsEnabled,
    List<String>? conflictCalendarIds,
    bool? conflictRemindersEnabled,
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
      other.conflictRemindersEnabled == conflictRemindersEnabled;

  @override
  int get hashCode => Object.hash(
    themeMode,
    language,
    onboardingCompleted,
    remindersEnabled,
    calendarConflictsEnabled,
    Object.hashAll(conflictCalendarIds),
    conflictRemindersEnabled,
  );

  static bool _sameIds(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
