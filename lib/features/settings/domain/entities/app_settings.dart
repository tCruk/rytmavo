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
  });

  final AppThemeMode themeMode;
  final AppLanguage language;
  final bool onboardingCompleted;

  /// Global opt-in for local notifications. Individual reminders are
  /// configured per shift type / habit and only fire when this is true.
  final bool remindersEnabled;

  static const AppSettings defaults = AppSettings();

  AppSettings copyWith({
    AppThemeMode? themeMode,
    AppLanguage? language,
    bool? onboardingCompleted,
    bool? remindersEnabled,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      language: language ?? this.language,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      remindersEnabled: remindersEnabled ?? this.remindersEnabled,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is AppSettings &&
      other.themeMode == themeMode &&
      other.language == language &&
      other.onboardingCompleted == onboardingCompleted &&
      other.remindersEnabled == remindersEnabled;

  @override
  int get hashCode =>
      Object.hash(themeMode, language, onboardingCompleted, remindersEnabled);
}
