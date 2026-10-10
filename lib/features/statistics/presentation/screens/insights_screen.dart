import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/l10n/generated/app_localizations.dart';
import '../../../../app/router/app_shell.dart';
import '../../../../core/ui/components/components.dart';
import '../../../../core/ui/tokens/tokens.dart';
import '../../../habits/domain/services/habit_statistics.dart';
import '../../../habits/presentation/controllers/habit_providers.dart';
import '../../../habits/presentation/widgets/habit_visuals.dart';
import '../../../shifts/domain/entities/shift_setup.dart';
import '../../../shifts/presentation/controllers/shift_providers.dart';

enum _Period {
  days7(7),
  days30(30),
  days90(90);

  const _Period(this.days);

  final int days;
}

/// Success rate per habit over planned (due) days. Days on which a habit
/// was not due never count against it.
class InsightsScreen extends ConsumerStatefulWidget {
  const InsightsScreen({super.key});

  @override
  ConsumerState<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends ConsumerState<InsightsScreen> {
  _Period _period = _Period.days30;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final plan = ref.watch(habitPlanProvider).value;
    final setup = ref.watch(shiftSetupProvider).value ?? ShiftSetup.empty;
    final today = ref.watch(todayProvider);

    final stats = plan == null
        ? null
        : HabitStatistics.forAll(
            plan: plan,
            setup: setup,
            from: today.addDays(-(_period.days - 1)),
            to: today,
            today: today,
          );
    final overall = stats == null ? null : HabitStatistics.overall(stats);
    final hasData = overall != null && overall.dueDays > 0;

    return RyPage(
      title: l10n.statsTitle,
      actions: const [SettingsAction()],
      slivers: [
        if (stats == null)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(child: CircularProgressIndicator()),
          )
        else if (plan!.habits.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: RyEmptyState(
              icon: Icons.insights_outlined,
              title: l10n.statsEmptyTitle,
              body: l10n.statsEmptyBody,
            ),
          )
        else
          RySliverPadding(
            sliver: SliverList.list(
              children: [
                const SizedBox(height: AppSpacing.sm),
                SegmentedButton<_Period>(
                  selected: {_period},
                  showSelectedIcon: false,
                  onSelectionChanged: (s) => setState(() => _period = s.first),
                  segments: [
                    ButtonSegment(
                      value: _Period.days7,
                      label: Text(l10n.statsPeriod7),
                    ),
                    ButtonSegment(
                      value: _Period.days30,
                      label: Text(l10n.statsPeriod30),
                    ),
                    ButtonSegment(
                      value: _Period.days90,
                      label: Text(l10n.statsPeriod90),
                    ),
                  ],
                ),
                RySectionHeader(l10n.statsOverall),
                RyCard(
                  child: Row(
                    children: [
                      _RateRing(rate: overall!.rate, size: 72),
                      const SizedBox(width: AppSpacing.lg),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.statsRate,
                              style: theme.textTheme.titleMedium,
                            ),
                            Text(
                              hasData
                                  ? l10n.statsCompleted(
                                      overall.completedDays,
                                      overall.dueDays,
                                    )
                                  : l10n.statsNotDue,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                RySectionHeader(l10n.habitsTitle),
                for (final s in stats)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: RyCard(
                      child: Row(
                        children: [
                          HabitAvatar(habit: s.habit),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  s.habit.name,
                                  style: theme.textTheme.titleMedium,
                                ),
                                const SizedBox(height: AppSpacing.xxs),
                                Text(
                                  s.dueDays == 0
                                      ? l10n.statsNotDue
                                      : '${l10n.statsCompleted(s.completedDays, s.dueDays)} · '
                                            '${l10n.statsStreak}: ${l10n.statsStreakDays(s.currentStreak)} · '
                                            '${l10n.statsBestStreak}: ${l10n.statsStreakDays(s.bestStreak)}',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          _RateRing(rate: s.rate, size: 48),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Circular progress with the percentage inside. `null` rate = not due.
class _RateRing extends StatelessWidget {
  const _RateRing({required this.rate, required this.size});

  final double? rate;
  final double size;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colors = AppColors.of(context);
    final percent = rate == null ? null : (rate! * 100).round();
    final color = switch (percent) {
      null => theme.colorScheme.outline,
      >= 80 => colors.success,
      >= 50 => colors.warning,
      _ => theme.colorScheme.error,
    };
    return Semantics(
      container: true,
      label: percent == null ? l10n.statsNotDue : l10n.statsPercent(percent),
      excludeSemantics: true,
      child: SizedBox.square(
        dimension: size,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CircularProgressIndicator(
              value: rate ?? 0,
              strokeWidth: size / 10,
              color: color,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
            ),
            Center(
              child: Text(
                percent == null ? '–' : l10n.statsPercent(percent),
                style:
                    (size > 60
                            ? theme.textTheme.titleMedium
                            : theme.textTheme.labelSmall)
                        ?.copyWith(fontWeight: FontWeight.w700),
                textScaler: TextScaler.noScaling,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
