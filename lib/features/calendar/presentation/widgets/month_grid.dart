import 'package:flutter/material.dart';

import '../../../../app/l10n/generated/app_localizations.dart';
import '../../../../core/date/local_date.dart';
import '../../../../core/ui/tokens/tokens.dart';
import '../../../shifts/domain/entities/shift_setup.dart';
import '../../../shifts/domain/entities/shift_type.dart';
import '../../../shifts/presentation/widgets/shift_visuals.dart';

/// Seven-column month grid, weeks starting on Monday, always six rows so
/// paging between months never jumps. Days of the neighbouring months fill
/// the first and last row in a muted style, as on the system calendar.
/// Each cell is ≥ 48 dp and carries full semantics.
class MonthGrid extends StatelessWidget {
  const MonthGrid({
    required this.month,
    required this.today,
    required this.setup,
    required this.onDayTap,
    this.conflictDates = const {},
    super.key,
  });

  /// Any date inside the month to show.
  final LocalDate month;
  final LocalDate today;
  final ShiftSetup setup;
  final ValueChanged<LocalDate> onDayTap;

  static const int _rows = 6;
  static const double _cellHeight = AppSpacing.touchTarget + 12;

  /// Total height of the grid (weekday header plus six rows), so a pager
  /// can size itself without laying the grid out first.
  static double heightFor(BuildContext context) {
    final header = Theme.of(context).textTheme.labelMedium?.fontSize ?? 12;
    final scale = MediaQuery.textScalerOf(context).scale(header);
    return scale * 1.4 + AppSpacing.xs + _rows * _cellHeight;
  }

  /// Days whose shift overlaps a device calendar event.
  final Set<LocalDate> conflictDates;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final material = MaterialLocalizations.of(context);
    final first = month.firstDayOfMonth;
    final leadingBlanks = first.weekday - 1; // Monday = 0
    final gridStart = first.addDays(-leadingBlanks);

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
        for (var r = 0; r < _rows; r++)
          Row(
            children: [
              for (var c = 0; c < 7; c++)
                Expanded(
                  child: _DayCell(
                    date: gridStart.addDays(r * 7 + c),
                    isToday: gridStart.addDays(r * 7 + c) == today,
                    inMonth: gridStart.addDays(r * 7 + c).month == month.month,
                    hasConflict: conflictDates.contains(
                      gridStart.addDays(r * 7 + c),
                    ),
                    setup: setup,
                    onTap: onDayTap,
                  ),
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
    required this.inMonth,
    required this.hasConflict,
    required this.setup,
    required this.onTap,
  });

  final LocalDate date;
  final bool isToday;

  /// False for the muted days of the previous / next month.
  final bool inMonth;
  final bool hasConflict;
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

    final cell = Semantics(
      button: true,
      selected: isToday,
      label: [
        l10n.calendarDayA11y(dateText, shiftName),
        if (day.isOverridden) l10n.calendarChanged,
        if (hasConflict) l10n.conflictsTitle,
      ].join(', '),
      excludeSemantics: true,
      child: InkWell(
        onTap: () => onTap(date),
        borderRadius: AppRadius.smAll,
        child: SizedBox(
          height: MonthGrid._cellHeight,
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
                  if (hasConflict)
                    Positioned(
                      left: -5,
                      bottom: -5,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.event_busy,
                          size: 14,
                          color: AppColors.of(context).warning,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    return inMonth ? cell : Opacity(opacity: 0.38, child: cell);
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
