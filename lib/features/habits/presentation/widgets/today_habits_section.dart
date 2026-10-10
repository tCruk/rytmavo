import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/l10n/generated/app_localizations.dart';
import '../../../../app/router/app_routes.dart';
import '../../../../core/ui/components/components.dart';
import '../../../../core/ui/tokens/tokens.dart';
import '../../domain/entities/habit_plan.dart';
import '../controllers/habit_providers.dart';
import 'habit_visuals.dart';

/// Checklist of today's due habits for the Today screen. Ticking a habit
/// persists immediately and offers undo in a snackbar.
class TodayHabitsSection extends ConsumerWidget {
  const TodayHabitsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final due = ref.watch(todayHabitsProvider);
    final hasAnyHabit =
        ref.watch(habitPlanProvider).value?.activeHabits.isNotEmpty ?? false;
    if (due == null) return const SizedBox.shrink();

    final doneCount = due.where((d) => d.isCompleted).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RySectionHeader(
          l10n.todayHabitsSection,
          trailing: due.isEmpty
              ? null
              : Text(
                  l10n.todayHabitsProgress(doneCount, due.length),
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
        ),
        if (due.isEmpty)
          RyCard(
            child: Row(
              children: [
                Icon(
                  hasAnyHabit
                      ? Icons.free_breakfast_outlined
                      : Icons.add_circle_outline,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    hasAnyHabit ? l10n.todayHabitsNone : l10n.habitsEmptyBody,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
                if (!hasAnyHabit)
                  RyButton.tertiary(
                    label: l10n.commonAdd,
                    onPressed: () => context.push(AppRoutes.habitNew),
                  ),
              ],
            ),
          )
        else
          RyCard(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
            child: Column(
              children: [for (final item in due) _HabitCheckTile(item: item)],
            ),
          ),
      ],
    );
  }
}

class _HabitCheckTile extends ConsumerWidget {
  const _HabitCheckTile({required this.item});

  final DueHabit item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final actions = ref.read(habitCompletionActionsProvider);

    Future<void> toggle() async {
      final completed = !item.isCompleted;
      final result = await actions.setCompletedToday(
        item.habit.id,
        completed: completed,
      );
      if (!context.mounted) return;
      if (result.isFailure) {
        showRySnackBar(context, l10n.onboardingSaveError);
        return;
      }
      showRySnackBar(
        context,
        completed
            ? l10n.todayHabitDone(item.habit.name)
            : l10n.todayHabitUndone(item.habit.name),
        actionLabel: l10n.commonUndo,
        onAction: () =>
            actions.setCompletedToday(item.habit.id, completed: !completed),
      );
    }

    return Semantics(
      container: true,
      button: true,
      label: l10n.a11yHabitToggle(
        item.habit.name,
        item.isCompleted ? l10n.a11yStateDone : l10n.a11yStateOpen,
      ),
      toggled: item.isCompleted,
      excludeSemantics: true,
      child: ListTile(
        leading: HabitAvatar(habit: item.habit, size: 36),
        title: Text(
          item.habit.name,
          style: item.isCompleted
              ? theme.textTheme.bodyLarge?.copyWith(
                  decoration: TextDecoration.lineThrough,
                  color: theme.colorScheme.onSurfaceVariant,
                )
              : theme.textTheme.bodyLarge,
        ),
        subtitle: item.habit.description == null
            ? null
            : Text(item.habit.description!),
        trailing: AnimatedSwitcher(
          duration: AppMotion.durationFor(
            AppMotion.fast,
            reducedMotion: MediaQuery.disableAnimationsOf(context),
          ),
          child: Icon(
            item.isCompleted ? Icons.check_circle : Icons.circle_outlined,
            key: ValueKey(item.isCompleted),
            color: item.isCompleted
                ? AppColors.of(context).success
                : theme.colorScheme.outline,
            size: 28,
          ),
        ),
        onTap: toggle,
      ),
    );
  }
}
