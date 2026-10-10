import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/providers.dart';
import '../../../../app/l10n/generated/app_localizations.dart';
import '../../../../app/router/app_routes.dart';
import '../../../../app/router/app_shell.dart';
import '../../../../core/ui/components/components.dart';
import '../../../../core/ui/tokens/tokens.dart';
import '../../../shifts/domain/entities/shift_setup.dart';
import '../../../shifts/presentation/controllers/shift_providers.dart';
import '../../../shifts/presentation/widgets/shift_visuals.dart';
import '../../domain/entities/habit.dart';
import '../../domain/entities/habit_plan.dart';
import '../controllers/habit_providers.dart';
import '../widgets/habit_visuals.dart';

class HabitsScreen extends ConsumerStatefulWidget {
  const HabitsScreen({super.key});

  @override
  ConsumerState<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends ConsumerState<HabitsScreen> {
  bool _showArchived = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final planAsync = ref.watch(habitPlanProvider);
    final setup = ref.watch(shiftSetupProvider).value ?? ShiftSetup.empty;

    return RyPage(
      title: l10n.habitsTitle,
      actions: [
        if (planAsync.value?.habits.any((h) => h.isArchived) ?? false)
          IconButton(
            tooltip: l10n.habitShowArchived,
            isSelected: _showArchived,
            icon: const Icon(Icons.inventory_2_outlined),
            selectedIcon: const Icon(Icons.inventory_2),
            onPressed: () => setState(() => _showArchived = !_showArchived),
          ),
        const SettingsAction(),
      ],
      floatingActionButton: planAsync.value?.activeHabits.isEmpty ?? true
          ? null
          : FloatingActionButton(
              tooltip: l10n.habitsAddAction,
              onPressed: () => context.push(AppRoutes.habitNew),
              child: const Icon(Icons.add),
            ),
      slivers: [
        switch (planAsync) {
          AsyncData(:final value) when value.activeHabits.isEmpty =>
            SliverFillRemaining(
              hasScrollBody: false,
              child: RyEmptyState(
                icon: Icons.check_circle_outline,
                title: l10n.habitsEmptyTitle,
                body: l10n.habitsEmptyBody,
                action: RyButton(
                  label: l10n.habitsAddAction,
                  icon: Icons.add,
                  onPressed: () => context.push(AppRoutes.habitNew),
                ),
              ),
            ),
          AsyncData(:final value) => RySliverPadding(
            sliver: SliverList.list(
              children: [
                const SizedBox(height: AppSpacing.sm),
                for (final habit in value.activeHabits)
                  _HabitTile(habit: habit, plan: value, setup: setup),
                if (_showArchived && value.habits.any((h) => h.isArchived)) ...[
                  RySectionHeader(l10n.habitShowArchived),
                  for (final habit in value.habits.where((h) => h.isArchived))
                    _HabitTile(
                      habit: habit,
                      plan: value,
                      setup: setup,
                      archived: true,
                    ),
                ],
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

class _HabitTile extends ConsumerWidget {
  const _HabitTile({
    required this.habit,
    required this.plan,
    required this.setup,
    this.archived = false,
  });

  final Habit habit;
  final HabitPlan plan;
  final ShiftSetup setup;
  final bool archived;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final rule = plan.currentRule(habit.id);
    final summary = rule == null || rule.appliesToEveryShift
        ? l10n.habitDueSummaryEveryDay
        : l10n.habitDueSummaryShifts(
            rule.targetShiftTypeIds
                .map((id) => setup.typeById(id)?.displayName(l10n) ?? id)
                .join(', '),
          );

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Opacity(
        opacity: archived ? 0.6 : 1,
        child: RyCard(
          padding: EdgeInsets.zero,
          onTap: archived
              ? null
              : () => context.push(AppRoutes.habitEditPath(habit.id)),
          child: ListTile(
            leading: HabitAvatar(habit: habit),
            title: Text(habit.name),
            subtitle: Text(
              habit.description == null
                  ? summary
                  : '${habit.description}\n$summary',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            isThreeLine: habit.description != null,
            trailing: PopupMenuButton<_HabitAction>(
              tooltip: l10n.commonEdit,
              onSelected: (action) => _onAction(context, ref, action),
              itemBuilder: (context) => [
                if (!archived)
                  PopupMenuItem(
                    value: _HabitAction.edit,
                    child: Text(l10n.commonEdit),
                  ),
                if (!archived)
                  PopupMenuItem(
                    value: _HabitAction.archive,
                    child: Text(l10n.habitArchive),
                  ),
                if (archived)
                  PopupMenuItem(
                    value: _HabitAction.restore,
                    child: Text(l10n.habitRestore),
                  ),
                PopupMenuItem(
                  value: _HabitAction.delete,
                  child: Text(l10n.habitDelete),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onAction(
    BuildContext context,
    WidgetRef ref,
    _HabitAction action,
  ) async {
    final l10n = AppLocalizations.of(context);
    final repo = ref.read(habitRepositoryProvider);
    switch (action) {
      case _HabitAction.edit:
        await context.push(AppRoutes.habitEditPath(habit.id));
      case _HabitAction.archive:
        final ok = await showRyConfirmDialog(
          context,
          title: l10n.habitArchive,
          message: l10n.habitArchiveBody,
          confirmLabel: l10n.habitArchive,
          cancelLabel: l10n.commonCancel,
        );
        if (!ok || !context.mounted) return;
        final result = await repo.archiveHabit(
          habit.id,
          ref.read(todayProvider),
        );
        if (context.mounted) {
          showRySnackBar(
            context,
            result.isSuccess ? l10n.habitArchived : l10n.onboardingSaveError,
          );
        }
      case _HabitAction.restore:
        final rule = plan.currentRule(habit.id);
        if (rule == null) return;
        await repo.saveHabit(habit.copyWith(clearArchived: true), rule);
      case _HabitAction.delete:
        final ok = await showRyConfirmDialog(
          context,
          title: l10n.habitDelete,
          message: l10n.habitDeleteBody,
          confirmLabel: l10n.commonDelete,
          cancelLabel: l10n.commonCancel,
          destructive: true,
        );
        if (!ok || !context.mounted) return;
        final result = await repo.deleteHabit(habit.id);
        if (context.mounted) {
          showRySnackBar(
            context,
            result.isSuccess ? l10n.habitDeleted : l10n.onboardingSaveError,
          );
        }
    }
  }
}

enum _HabitAction { edit, archive, restore, delete }
