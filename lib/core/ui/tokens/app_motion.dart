import 'package:flutter/animation.dart';

/// Motion tokens. Widgets must respect `MediaQuery.disableAnimations`
/// (reduced motion) – see [AppMotion.durationFor].
abstract final class AppMotion {
  static const Duration fast = Duration(milliseconds: 120);
  static const Duration normal = Duration(milliseconds: 220);
  static const Duration slow = Duration(milliseconds: 360);

  static const Curve standard = Curves.easeOutCubic;
  static const Curve emphasized = Curves.easeInOutCubicEmphasized;

  /// Returns [Duration.zero] when the user requested reduced motion.
  static Duration durationFor(Duration base, {required bool reducedMotion}) =>
      reducedMotion ? Duration.zero : base;
}
