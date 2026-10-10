import 'package:flutter/material.dart';

import '../../../../app/l10n/generated/app_localizations.dart';
import '../../../../core/date/local_time.dart';
import '../../../../core/ui/tokens/tokens.dart';
import '../../domain/entities/shift_type.dart';

/// Presentation helpers that turn a [ShiftType] into text, colours and
/// icons. Built-in types follow the app language and theme; custom types
/// use what the user stored.
extension ShiftTypeVisuals on ShiftType {
  String displayName(AppLocalizations l10n) {
    if (name.isNotEmpty) return name;
    return switch (kind) {
      ShiftKind.early => l10n.shiftEarly,
      ShiftKind.late => l10n.shiftLate,
      ShiftKind.night => l10n.shiftNight,
      ShiftKind.off => l10n.shiftOff,
      ShiftKind.custom => id,
    };
  }

  String displayAbbreviation(AppLocalizations l10n) {
    if (abbreviation.isNotEmpty) return abbreviation;
    return switch (kind) {
      ShiftKind.early => l10n.shiftEarlyShort,
      ShiftKind.late => l10n.shiftLateShort,
      ShiftKind.night => l10n.shiftNightShort,
      ShiftKind.off => l10n.shiftOffShort,
      ShiftKind.custom => id.characters.first.toUpperCase(),
    };
  }

  /// Background and foreground colour pair with ≥ 4.5:1 contrast.
  (Color, Color) colors(AppColors c) => switch (kind) {
    ShiftKind.early => (c.shiftEarly, c.onShiftEarly),
    ShiftKind.late => (c.shiftLate, c.onShiftLate),
    ShiftKind.night => (c.shiftNight, c.onShiftNight),
    ShiftKind.off => (c.shiftOff, c.onShiftOff),
    ShiftKind.custom => _customColors(Color(colorValue)),
  };

  IconData get icon => switch (kind) {
    ShiftKind.early => Icons.wb_twilight,
    ShiftKind.late => Icons.wb_sunny_outlined,
    ShiftKind.night => Icons.nightlight_round,
    ShiftKind.off => Icons.weekend_outlined,
    ShiftKind.custom => Icons.work_outline,
  };

  /// `06:00–14:00`, or `null` when the type has no times.
  String? timeRange(BuildContext context) {
    if (!hasTimes) return null;
    return AppLocalizations.of(context).shiftTimeRange(
      formatLocalTime(context, start!),
      formatLocalTime(context, end!),
    );
  }
}

(Color, Color) _customColors(Color bg) {
  final white = contrastRatio(bg, const Color(0xFFFFFFFF));
  final black = contrastRatio(bg, const Color(0xFF000000));
  return (
    bg,
    white >= black ? const Color(0xFFFFFFFF) : const Color(0xFF000000),
  );
}

/// Formats a [LocalTime] honouring the device's 12/24-hour preference.
String formatLocalTime(BuildContext context, LocalTime time) =>
    MaterialLocalizations.of(context).formatTimeOfDay(
      TimeOfDay(hour: time.hour, minute: time.minute),
      alwaysUse24HourFormat: MediaQuery.alwaysUse24HourFormatOf(context),
    );

/// Coloured square with the shift's abbreviation. Meaning is never carried
/// by colour alone: the abbreviation is always visible and the semantics
/// label names the shift.
class ShiftBadge extends StatelessWidget {
  const ShiftBadge({required this.shift, super.key, this.size = 32});

  final ShiftType shift;
  final double size;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final (bg, fg) = shift.colors(AppColors.of(context));
    return Semantics(
      label: l10n.a11yShiftBadge(shift.displayName(l10n)),
      excludeSemantics: true,
      child: SizedBox.square(
        dimension: size,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(size * 0.3),
          ),
          child: Center(
            child: Text(
              shift.displayAbbreviation(l10n),
              maxLines: 1,
              textScaler: TextScaler.noScaling,
              style: TextStyle(
                color: fg,
                fontWeight: FontWeight.w700,
                fontSize: size * 0.42,
                height: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Neutral placeholder badge for days without a shift.
class EmptyShiftBadge extends StatelessWidget {
  const EmptyShiftBadge({super.key, this.size = 32});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.of(context).outlineSoft),
          borderRadius: BorderRadius.circular(size * 0.3),
        ),
      ),
    );
  }
}
