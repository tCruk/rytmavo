import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/l10n/generated/app_localizations.dart';
import '../../../../core/date/local_time.dart';
import '../../../../core/ui/components/components.dart';
import '../../../../core/ui/tokens/tokens.dart';
import '../../domain/entities/rotation_preset.dart';
import '../../domain/entities/shift_type.dart';
import '../controllers/onboarding_controller.dart';
import '../controllers/shift_providers.dart';
import '../widgets/shift_visuals.dart';

/// Four-step setup of the shift rotation. Also used to change an existing
/// rotation (edit mode), which creates a new rotation version.
class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final draft = ref.watch(onboardingControllerProvider);
    final controller = ref.read(onboardingControllerProvider.notifier);
    final theme = Theme.of(context);

    Future<void> finish() async {
      final result = await controller.save();
      if (!context.mounted) return;
      if (result.isSuccess) {
        context.pop();
      } else {
        showRySnackBar(context, l10n.onboardingSaveError);
      }
    }

    return PopScope(
      canPop: draft.isFirstStep,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) controller.back();
      },
      child: RyPage(
        title: draft.isEdit ? l10n.onboardingEditTitle : l10n.onboardingTitle,
        leading: draft.isFirstStep
            ? CloseButton(onPressed: () => context.pop())
            : BackButton(onPressed: controller.back),
        slivers: [
          RySliverPadding(
            sliver: SliverList.list(
              children: [
                const SizedBox(height: AppSpacing.sm),
                Text(
                  l10n.onboardingStepOf(
                    draft.step.index + 1,
                    OnboardingStep.values.length,
                  ),
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                LinearProgressIndicator(
                  value: (draft.step.index + 1) / OnboardingStep.values.length,
                  borderRadius: AppRadius.smAll,
                ),
                const SizedBox(height: AppSpacing.xl),
                AnimatedSwitcher(
                  duration: AppMotion.durationFor(
                    AppMotion.normal,
                    reducedMotion: MediaQuery.disableAnimationsOf(context),
                  ),
                  child: KeyedSubtree(
                    key: ValueKey(draft.step),
                    child: switch (draft.step) {
                      OnboardingStep.preset => const _PresetStep(),
                      OnboardingStep.rhythm => const _RhythmStep(),
                      OnboardingStep.today => const _TodayStep(),
                      OnboardingStep.times => const _TimesStep(),
                    },
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
                RyButton(
                  label: draft.isLastStep ? l10n.commonDone : l10n.commonNext,
                  icon: draft.isLastStep ? Icons.check : Icons.arrow_forward,
                  expand: true,
                  loading: draft.saving,
                  onPressed: draft.isLastStep ? finish : controller.next,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StepHeader extends StatelessWidget {
  const _StepHeader({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.textTheme.headlineSmall),
        const SizedBox(height: AppSpacing.sm),
        Text(
          body,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}

class _PresetStep extends ConsumerWidget {
  const _PresetStep();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final draft = ref.watch(onboardingControllerProvider);
    final controller = ref.read(onboardingControllerProvider.notifier);

    (String, String) label(RotationPreset p) => switch (p) {
      RotationPreset.weekly3 => (
        l10n.presetWeekly3Name,
        l10n.presetWeekly3Desc,
      ),
      RotationPreset.weekly2 => (
        l10n.presetWeekly2Name,
        l10n.presetWeekly2Desc,
      ),
      RotationPreset.conti4 => (l10n.presetConti4Name, l10n.presetConti4Desc),
      RotationPreset.conti5 => (l10n.presetConti5Name, l10n.presetConti5Desc),
      RotationPreset.custom => (l10n.presetCustomName, l10n.presetCustomDesc),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StepHeader(
          title: l10n.onboardingPresetTitle,
          body: l10n.onboardingPresetBody,
        ),
        if (draft.isEdit)
          _PresetCard(
            name: l10n.presetCurrentName,
            description: l10n.presetCurrentDesc,
            cycleLength: null,
            selected: draft.preset == null,
            onTap: controller.selectCurrent,
          ),
        for (final p in RotationPreset.values)
          _PresetCard(
            name: label(p).$1,
            description: label(p).$2,
            cycleLength: p.slots.length,
            selected: draft.preset == p,
            onTap: () => controller.selectPreset(p),
          ),
      ],
    );
  }
}

class _PresetCard extends StatelessWidget {
  const _PresetCard({
    required this.name,
    required this.description,
    required this.cycleLength,
    required this.selected,
    required this.onTap,
  });

  final String name;
  final String description;
  final int? cycleLength;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Semantics(
        selected: selected,
        child: RyCard(
          onTap: onTap,
          color: selected ? scheme.primaryContainer : null,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: theme.textTheme.titleMedium),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    if (cycleLength != null) ...[
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        l10n.cycleLength(cycleLength!),
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Icon(
                selected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: selected ? scheme.primary : scheme.outline,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RhythmStep extends ConsumerWidget {
  const _RhythmStep();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final draft = ref.watch(onboardingControllerProvider);
    final controller = ref.read(onboardingControllerProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StepHeader(
          title: l10n.onboardingRhythmTitle,
          body: l10n.onboardingRhythmBody,
        ),
        _SlotGrid(
          slots: draft.slots,
          types: draft.types,
          onTap: controller.cycleSlot,
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            Expanded(
              child: RyButton.secondary(
                label: l10n.onboardingAddDay,
                icon: Icons.add,
                onPressed: controller.addDay,
              ),
            ),
            ryButtonGap,
            Expanded(
              child: RyButton.secondary(
                label: l10n.onboardingRemoveDay,
                icon: Icons.remove,
                onPressed: draft.slots.length > 1
                    ? controller.removeLastDay
                    : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          l10n.cycleLength(draft.slots.length),
          style: Theme.of(context).textTheme.labelLarge,
        ),
      ],
    );
  }
}

/// Grid of the cycle's days. Each tile is at least 48 dp and announces
/// "Day n, shift name" to screen readers.
class _SlotGrid extends StatelessWidget {
  const _SlotGrid({
    required this.slots,
    required this.types,
    this.onTap,
    this.highlighted,
  });

  final List<String> slots;
  final Map<String, ShiftType> types;
  final ValueChanged<int>? onTap;
  final int? highlighted;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        for (var i = 0; i < slots.length; i++)
          Semantics(
            button: onTap != null,
            selected: highlighted == i,
            label:
                '${l10n.onboardingDayN(i + 1)}, '
                '${types[slots[i]]?.displayName(l10n) ?? slots[i]}',
            excludeSemantics: true,
            child: Material(
              color: highlighted == i
                  ? theme.colorScheme.primaryContainer
                  : Colors.transparent,
              borderRadius: AppRadius.smAll,
              child: InkWell(
                onTap: onTap == null ? null : () => onTap!(i),
                borderRadius: AppRadius.smAll,
                child: SizedBox(
                  width: AppSpacing.touchTarget + AppSpacing.xs,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.xs,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${i + 1}',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xxs),
                        if (types[slots[i]] case final type?)
                          ShiftBadge(shift: type, size: 36)
                        else
                          const EmptyShiftBadge(size: 36),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _TodayStep extends ConsumerWidget {
  const _TodayStep();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final draft = ref.watch(onboardingControllerProvider);
    final controller = ref.read(onboardingControllerProvider.notifier);
    final today = ref.watch(todayProvider);
    final preview = draft.previewSetup(controller.draftPattern());
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StepHeader(
          title: l10n.onboardingTodayTitle,
          body: l10n.onboardingTodayBody,
        ),
        _SlotGrid(
          slots: draft.slots,
          types: draft.types,
          highlighted: draft.todayPosition,
          onTap: controller.setTodayPosition,
        ),
        const SizedBox(height: AppSpacing.xl),
        RySectionHeader(l10n.onboardingPreview),
        RyCard(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Column(
            children: [
              for (final day in preview.daysFrom(today, 7))
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: day.shift == null
                      ? const EmptyShiftBadge()
                      : ShiftBadge(shift: day.shift!),
                  title: Text(
                    MaterialLocalizations.of(context)
                        .formatFullDate(day.date.toLocalDateTime()),
                    style: theme.textTheme.bodyMedium,
                  ),
                  subtitle: Text(
                    day.shift?.displayName(l10n) ?? l10n.todayNoEntry,
                  ),
                ),
            ],
          ),
        ),
        if (draft.isEdit) ...[
          const SizedBox(height: AppSpacing.lg),
          RyCard(
            padding: EdgeInsets.zero,
            child: SwitchListTile(
              value: !draft.applyToPast,
              onChanged: (keepPast) =>
                  controller.setApplyToPast(value: !keepPast),
              title: Text(l10n.onboardingEditHint),
            ),
          ),
        ],
      ],
    );
  }
}

class _TimesStep extends ConsumerWidget {
  const _TimesStep();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final draft = ref.watch(onboardingControllerProvider);
    final controller = ref.read(onboardingControllerProvider.notifier);
    final theme = Theme.of(context);

    Future<void> pick(ShiftType type, {required bool start}) async {
      final current = (start ? type.start : type.end) ?? const LocalTime(6, 0);
      final picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: current.hour, minute: current.minute),
        helpText: start ? l10n.shiftStart : l10n.shiftEnd,
      );
      if (picked == null) return;
      final time = LocalTime(picked.hour, picked.minute);
      controller.setTimes(
        type.id,
        start: start ? time : null,
        end: start ? null : time,
      );
    }

    final workTypes = draft.types.values.where((t) => t.isWorkShift).toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StepHeader(
          title: l10n.onboardingTimesTitle,
          body: l10n.onboardingTimesBody,
        ),
        for (final type in workTypes)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: RyCard(
              child: Row(
                children: [
                  ShiftBadge(shift: type, size: 40),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          type.displayName(l10n),
                          style: theme.textTheme.titleMedium,
                        ),
                        if (type.crossesMidnight)
                          Text(
                            l10n.shiftEndsNextDay,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                      ],
                    ),
                  ),
                  _TimeChip(
                    label: l10n.shiftStart,
                    time: type.start,
                    onTap: () => pick(type, start: true),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  _TimeChip(
                    label: l10n.shiftEnd,
                    time: type.end,
                    onTap: () => pick(type, start: false),
                  ),
                ],
              ),
            ),
          ),
        Text(
          l10n.onboardingNightHint,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _TimeChip extends StatelessWidget {
  const _TimeChip({
    required this.label,
    required this.time,
    required this.onTap,
  });

  final String label;
  final LocalTime? time;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final text = time == null ? '--:--' : formatLocalTime(context, time!);
    return Semantics(
      button: true,
      label: '$label $text',
      excludeSemantics: true,
      child: ActionChip(label: Text(text), onPressed: onTap),
    );
  }
}
