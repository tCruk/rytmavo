import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/l10n/generated/app_localizations.dart';
import '../../../../app/router/app_routes.dart';
import '../../../../app/router/app_shell.dart';
import '../../../../core/ui/components/components.dart';
import '../../../../core/ui/tokens/tokens.dart';
import '../../../device_calendar/presentation/widgets/upcoming_conflicts_section.dart';
import '../../../habits/presentation/widgets/today_habits_section.dart';
import '../../domain/entities/scheduled_day.dart';
import '../../domain/entities/shift_setup.dart';
import '../controllers/shift_providers.dart';
import '../widgets/shift_visuals.dart';

/// Today's shift at a glance plus the coming week. Phase 3 adds the
/// habit checklist below.
class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final setupAsync = ref.watch(shiftSetupProvider);
    final today = ref.watch(todayProvider);

    final hasRotation = setupAsync.value?.hasRotation ?? false;

    return RyPage(
      title: l10n.todayTitle,
      actions: [
        if (hasRotation) const EditShiftsAction(),
        const SettingsAction(),
      ],
      slivers: [
        switch (setupAsync) {
          AsyncData(:final value) when !value.hasRotation =>
            SliverFillRemaining(
              hasScrollBody: false,
              child: RyEmptyState(
                icon: Icons.wb_twilight_outlined,
                title: l10n.todayEmptyTitle,
                body: l10n.todayEmptyBody,
                action: RyButton(
                  label: l10n.todaySetupAction,
                  icon: Icons.tune,
                  onPressed: () => context.push(AppRoutes.onboarding),
                ),
              ),
            ),
          AsyncData(:final value) => RySliverPadding(
            sliver: SliverList.list(
              children: [
                const SizedBox(height: AppSpacing.sm),
                _TodayCard(setup: value, day: value.dayOn(today)),
                UpcomingConflictsSection(from: today),
                const TodayHabitsSection(),
                RySectionHeader(l10n.todayNextDays),
                _UpcomingRow(days: value.daysFrom(today.addDays(1), 7)),
              ],
            ),
          ),
          AsyncError() => SliverFillRemaining(
            hasScrollBody: false,
            child: RyEmptyState(
              icon: Icons.error_outline,
              title: l10n.errorGenericTitle,
              body: l10n.errorGenericBody,
            ),
          ),
          _ => const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(child: CircularProgressIndicator()),
          ),
        },
      ],
    );
  }
}

class _TodayCard extends StatelessWidget {
  const _TodayCard({required this.setup, required this.day});

  final ShiftSetup setup;
  final ScheduledDay day;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final shift = day.shift;
    final dateText = MaterialLocalizations.of(context)
        .formatFullDate(day.date.toLocalDateTime());
    final next = setup.nextWorkDayAfter(day.date);

    return RyCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            dateText,
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              if (shift != null)
                ShiftBadge(shift: shift, size: 56)
              else
                const EmptyShiftBadge(size: 56),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shift?.displayName(l10n) ?? l10n.todayNoEntry,
                      style: theme.textTheme.headlineMedium,
                    ),
                    if (shift?.timeRange(context) case final range?)
                      Text(
                        shift!.crossesMidnight
                            ? '$range · ${l10n.shiftEndsNextDay}'
                            : range,
                        style: theme.textTheme.bodyLarge,
                      ),
                    if (shift != null && !shift.isWorkShift)
                      Text(
                        l10n.todayDayOffBody,
                        style: theme.textTheme.bodyLarge,
                      ),
                  ],
                ),
              ),
            ],
          ),
          if (day.isOverridden && day.rotationShift != null) ...[
            const SizedBox(height: AppSpacing.md),
            _Hint(
              icon: Icons.swap_horiz,
              text: l10n.todayOverriddenFrom(
                day.rotationShift!.displayName(l10n),
              ),
            ),
          ],
          if (shift != null && !shift.isWorkShift && next?.shift != null) ...[
            const SizedBox(height: AppSpacing.md),
            _Hint(
              icon: Icons.schedule,
              text: l10n.todayNextShift(
                next!.shift!.displayName(l10n),
                MaterialLocalizations.of(context)
                    .formatMediumDate(next.date.toLocalDateTime()),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Hint extends StatelessWidget {
  const _Hint({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 18, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}

/// Horizontal strip of the next days: weekday, badge, day number.
class _UpcomingRow extends StatelessWidget {
  const _UpcomingRow({required this.days});

  final List<ScheduledDay> days;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final material = MaterialLocalizations.of(context);
    return RyCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          for (final day in days)
            Expanded(
              child: Semantics(
                label: l10n.calendarDayA11y(
                  material.formatMediumDate(day.date.toLocalDateTime()),
                  day.shift?.displayName(l10n) ?? l10n.todayNoEntry,
                ),
                excludeSemantics: true,
                child: Column(
                  children: [
                    Text(
                      material.narrowWeekdays[day.date.weekday % 7],
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    if (day.shift case final shift?)
                      ShiftBadge(shift: shift, size: 34)
                    else
                      const EmptyShiftBadge(size: 34),
                    const SizedBox(height: AppSpacing.xs),
                    Text('${day.date.day}', style: theme.textTheme.labelMedium),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
