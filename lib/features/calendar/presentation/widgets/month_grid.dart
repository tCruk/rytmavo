import 'package:flutter/material.dart';

import '../../../../app/l10n/generated/app_localizations.dart';
import '../../../../core/date/local_date.dart';
import '../../../../core/ui/tokens/tokens.dart';
import '../../../shifts/domain/entities/shift_setup.dart';
import '../../../shifts/domain/entities/shift_type.dart';
import '../../../shifts/presentation/widgets/shift_visuals.dart';

/// Seven-column month grid, weeks starting on Monday. Days outside the
/// month are left blank. Each cell is ≥ 48 dp and carries full semantics.
class MonthGrid extends StatelessWidget {
  const MonthGrid({
    required this.month,
    required this.today,
    required this.setup,
    required this.onDayTap,
    super.key,
  });

  /// Any date inside the month to show.
  final LocalDate month;
  final LocalDate today;
  final ShiftSetup setup;
  final ValueChanged<LocalDate> onDayTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final material = MaterialLocalizations.of(context);
    final first = month.firstDayOfMonth;
    final leadingBlanks = first.weekday - 1; // Monday = 0
    final cells = leadingBlanks + first.lengthOfMonth;
    final rows = (cells / 7).ceil();

    return Column(
      children: [
        Row(
          children: [
            for (var w = 1; w <= 7; w++)
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                    child: Text(
                      material.narrowWeekdays[w % 7],
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        for (var r = 0; r < rows; r++)
          Row(
            children: [
              for (var c = 0; c < 7; c++)
                Expanded(
                  child: switch (r * 7 + c - leadingBlanks) {
                    final i when i < 0 || i >= first.lengthOfMonth =>
                      const SizedBox(height: AppSpacing.touchTarget + 12),
                    final i => _DayCell(
                      date: first.addDays(i),
                      isToday: first.addDays(i) == today,
                      setup: setup,
                      onTap: onDayTap,
                    ),
                  },
                ),
            ],
          ),
      ],
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.date,
    required this.isToday,
    required this.setup,
    required this.onTap,
  });

  final LocalDate date;
  final bool isToday;
  final ShiftSetup setup;
  final ValueChanged<LocalDate> onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final day = setup.dayOn(date);
    final shiftName = day.shift?.displayName(l10n) ?? l10n.todayNoEntry;
    final dateText = MaterialLocalizations.of(context)
        .formatMediumDate(date.toLocalDateTime());

    return Semantics(
      button: true,
      selected: isToday,
      label: day.isOverridden
          ? '${l10n.calendarDayA11y(dateText, shiftName)}, ${l10n.calendarChanged}'
          : l10n.calendarDayA11y(dateText, shiftName),
      excludeSemantics: true,
      child: InkWell(
        onTap: () => onTap(date),
        borderRadius: AppRadius.smAll,
        child: SizedBox(
          height: AppSpacing.touchTarget + 12,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 22,
                height: 22,
                alignment: Alignment.center,
                decoration: isToday
                    ? BoxDecoration(
                        color: theme.colorScheme.primary,
                        shape: BoxShape.circle,
                      )
                    : null,
                child: Text(
                  '${date.day}',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: isToday ? theme.colorScheme.onPrimary : null,
                    fontWeight: isToday ? FontWeight.w700 : null,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  if (day.shift case final shift?)
                    ShiftBadge(shift: shift, size: 28)
                  else
                    const EmptyShiftBadge(size: 28),
                  if (day.isOverridden)
                    Positioned(
                      right: -3,
                      top: -3,
                      child: Icon(
                        Icons.circle,
                        size: 8,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Badge plus name, used in legends and pickers.
class LegendItem extends StatelessWidget {
  const LegendItem({required this.type, required this.label, super.key});

  final ShiftType type;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ShiftBadge(shift: type, size: 20),
        const SizedBox(width: AppSpacing.sm),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
