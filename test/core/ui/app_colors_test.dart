import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rytmavo/app/theme/app_theme.dart';
import 'package:rytmavo/core/ui/tokens/tokens.dart';

void main() {
  void expectPairs(AppColors c, String name) {
    final pairs = <String, (Color, Color)>{
      'shiftEarly': (c.shiftEarly, c.onShiftEarly),
      'shiftLate': (c.shiftLate, c.onShiftLate),
      'shiftNight': (c.shiftNight, c.onShiftNight),
      'shiftOff': (c.shiftOff, c.onShiftOff),
      'success': (c.success, c.onSuccess),
      'successContainer': (c.successContainer, c.onSuccessContainer),
      'warning': (c.warning, c.onWarning),
      'warningContainer': (c.warningContainer, c.onWarningContainer),
    };
    for (final entry in pairs.entries) {
      final ratio = contrastRatio(entry.value.$1, entry.value.$2);
      expect(
        ratio,
        greaterThanOrEqualTo(4.5),
        reason: '$name.${entry.key} contrast is $ratio',
      );
    }
  }

  test('semantic colour pairs reach WCAG AA (4.5:1) in both themes', () {
    expectPairs(AppColors.light, 'light');
    expectPairs(AppColors.dark, 'dark');
  });

  test('themes register AppColors and body text has AA contrast', () {
    for (final theme in [AppTheme.light(), AppTheme.dark()]) {
      expect(theme.extension<AppColors>(), isNotNull);
      final s = theme.colorScheme;
      expect(contrastRatio(s.surface, s.onSurface), greaterThanOrEqualTo(4.5));
      expect(contrastRatio(s.primary, s.onPrimary), greaterThanOrEqualTo(4.5));
      expect(
        contrastRatio(s.surface, s.onSurfaceVariant),
        greaterThanOrEqualTo(4.5),
      );
      final c = theme.extension<AppColors>()!;
      // Holiday day numbers are text, the school holiday band a graphic.
      expect(contrastRatio(s.surface, c.holiday), greaterThanOrEqualTo(4.5));
      expect(
        contrastRatio(s.surface, c.schoolHoliday),
        greaterThanOrEqualTo(3),
      );
    }
  });
}
