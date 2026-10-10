import 'package:flutter/material.dart';

/// Semantic colours that Material's [ColorScheme] does not provide.
///
/// Feature widgets read them with `AppColors.of(context)`; they never use
/// literal colours. Shift colours are the *defaults* for the built-in shift
/// kinds; a user-defined shift type stores its own colour value.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.shiftEarly,
    required this.onShiftEarly,
    required this.shiftLate,
    required this.onShiftLate,
    required this.shiftNight,
    required this.onShiftNight,
    required this.shiftOff,
    required this.onShiftOff,
    required this.success,
    required this.onSuccess,
    required this.successContainer,
    required this.onSuccessContainer,
    required this.warning,
    required this.onWarning,
    required this.warningContainer,
    required this.onWarningContainer,
    required this.surfaceElevated,
    required this.outlineSoft,
    required this.holiday,
    required this.schoolHoliday,
  });

  final Color shiftEarly;
  final Color onShiftEarly;
  final Color shiftLate;
  final Color onShiftLate;
  final Color shiftNight;
  final Color onShiftNight;
  final Color shiftOff;
  final Color onShiftOff;
  final Color success;
  final Color onSuccess;
  final Color successContainer;
  final Color onSuccessContainer;
  final Color warning;
  final Color onWarning;
  final Color warningContainer;
  final Color onWarningContainer;

  /// Card surface that sits visibly above the scaffold background.
  final Color surfaceElevated;

  /// Hairline dividers and card borders.
  final Color outlineSoft;

  /// Public holidays in the calendar (ring and day number); text contrast
  /// on the surface.
  final Color holiday;

  /// Band below school holiday days; graphic contrast on the surface.
  final Color schoolHoliday;

  static AppColors of(BuildContext context) {
    final ext = Theme.of(context).extension<AppColors>();
    assert(ext != null, 'AppColors is not registered in the ThemeData');
    return ext ?? light;
  }

  /// Light palette – every (bg, on) pair ≥ 4.5:1.
  static const AppColors light = AppColors(
    shiftEarly: Color(0xFF9A5E0B), // amber-ochre (sunrise), 5.3:1 on white
    onShiftEarly: Color(0xFFFFFFFF),
    shiftLate: Color(0xFFB4473C), // terracotta (sunset)
    onShiftLate: Color(0xFFFFFFFF),
    shiftNight: Color(0xFF3B4A8C), // indigo (night)
    onShiftNight: Color(0xFFFFFFFF),
    shiftOff: Color(0xFF3F7D5A), // sage green (free)
    onShiftOff: Color(0xFFFFFFFF),
    success: Color(0xFF2E7D4F),
    onSuccess: Color(0xFFFFFFFF),
    successContainer: Color(0xFFD7F0E0),
    onSuccessContainer: Color(0xFF0C3B22),
    warning: Color(0xFF9A5B00),
    onWarning: Color(0xFFFFFFFF),
    warningContainer: Color(0xFFFFE3B8),
    onWarningContainer: Color(0xFF3F2500),
    surfaceElevated: Color(0xFFFFFFFF),
    outlineSoft: Color(0xFFE2E4E8),
    holiday: Color(0xFFB3261E),
    schoolHoliday: Color(0xFF00796B),
  );

  /// Dark palette – lighter accents, dark "on" colours ≥ 4.5:1.
  static const AppColors dark = AppColors(
    shiftEarly: Color(0xFFF2B35B),
    onShiftEarly: Color(0xFF2E1D00),
    shiftLate: Color(0xFFF08A7E),
    onShiftLate: Color(0xFF3A0E09),
    shiftNight: Color(0xFF9FAAE8),
    onShiftNight: Color(0xFF0D1440),
    shiftOff: Color(0xFF8ACBA6),
    onShiftOff: Color(0xFF07301A),
    success: Color(0xFF7FD4A2),
    onSuccess: Color(0xFF063B20),
    successContainer: Color(0xFF1C4A31),
    onSuccessContainer: Color(0xFFCBF2DB),
    warning: Color(0xFFF5C26B),
    onWarning: Color(0xFF3F2500),
    warningContainer: Color(0xFF4F3500),
    onWarningContainer: Color(0xFFFFE3B8),
    surfaceElevated: Color(0xFF1C1F24),
    outlineSoft: Color(0xFF2E3238),
    holiday: Color(0xFFF2B8B5),
    schoolHoliday: Color(0xFF80CBC4),
  );

  @override
  AppColors copyWith({
    Color? shiftEarly,
    Color? onShiftEarly,
    Color? shiftLate,
    Color? onShiftLate,
    Color? shiftNight,
    Color? onShiftNight,
    Color? shiftOff,
    Color? onShiftOff,
    Color? success,
    Color? onSuccess,
    Color? successContainer,
    Color? onSuccessContainer,
    Color? warning,
    Color? onWarning,
    Color? warningContainer,
    Color? onWarningContainer,
    Color? surfaceElevated,
    Color? outlineSoft,
    Color? holiday,
    Color? schoolHoliday,
  }) {
    return AppColors(
      shiftEarly: shiftEarly ?? this.shiftEarly,
      onShiftEarly: onShiftEarly ?? this.onShiftEarly,
      shiftLate: shiftLate ?? this.shiftLate,
      onShiftLate: onShiftLate ?? this.onShiftLate,
      shiftNight: shiftNight ?? this.shiftNight,
      onShiftNight: onShiftNight ?? this.onShiftNight,
      shiftOff: shiftOff ?? this.shiftOff,
      onShiftOff: onShiftOff ?? this.onShiftOff,
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      successContainer: successContainer ?? this.successContainer,
      onSuccessContainer: onSuccessContainer ?? this.onSuccessContainer,
      warning: warning ?? this.warning,
      onWarning: onWarning ?? this.onWarning,
      warningContainer: warningContainer ?? this.warningContainer,
      onWarningContainer: onWarningContainer ?? this.onWarningContainer,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      outlineSoft: outlineSoft ?? this.outlineSoft,
      holiday: holiday ?? this.holiday,
      schoolHoliday: schoolHoliday ?? this.schoolHoliday,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t) ?? a;
    return AppColors(
      shiftEarly: l(shiftEarly, other.shiftEarly),
      onShiftEarly: l(onShiftEarly, other.onShiftEarly),
      shiftLate: l(shiftLate, other.shiftLate),
      onShiftLate: l(onShiftLate, other.onShiftLate),
      shiftNight: l(shiftNight, other.shiftNight),
      onShiftNight: l(onShiftNight, other.onShiftNight),
      shiftOff: l(shiftOff, other.shiftOff),
      onShiftOff: l(onShiftOff, other.onShiftOff),
      success: l(success, other.success),
      onSuccess: l(onSuccess, other.onSuccess),
      successContainer: l(successContainer, other.successContainer),
      onSuccessContainer: l(onSuccessContainer, other.onSuccessContainer),
      warning: l(warning, other.warning),
      onWarning: l(onWarning, other.onWarning),
      warningContainer: l(warningContainer, other.warningContainer),
      onWarningContainer: l(onWarningContainer, other.onWarningContainer),
      surfaceElevated: l(surfaceElevated, other.surfaceElevated),
      outlineSoft: l(outlineSoft, other.outlineSoft),
      holiday: l(holiday, other.holiday),
      schoolHoliday: l(schoolHoliday, other.schoolHoliday),
    );
  }
}

/// Contrast ratio per WCAG 2.x. Exposed for tests and the colour tokens.
double contrastRatio(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  final lighter = la > lb ? la : lb;
  final darker = la > lb ? lb : la;
  return (lighter + 0.05) / (darker + 0.05);
}
