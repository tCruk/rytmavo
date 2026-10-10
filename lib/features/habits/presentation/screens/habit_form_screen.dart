import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/l10n/generated/app_localizations.dart';
import '../../../../core/date/local_time.dart';
import '../../../../core/ui/components/components.dart';
import '../../../../core/ui/tokens/tokens.dart';
import '../../../settings/domain/entities/app_settings.dart';
import '../../../settings/presentation/controllers/settings_controller.dart';
import '../../../shifts/domain/entities/shift_type.dart';
import '../../../shifts/presentation/controllers/shift_providers.dart';
import '../../../shifts/presentation/widgets/shift_visuals.dart';
import '../../domain/entities/habit_rule.dart';
import '../controllers/habit_form_controller.dart';
import '../widgets/habit_visuals.dart';

/// Create or edit a habit. [habitId] `null` creates a new one.
class HabitFormScreen extends ConsumerStatefulWidget {
  const HabitFormScreen({super.key, this.habitId});

  final String? habitId;

  @override
  ConsumerState<HabitFormScreen> createState() => _HabitFormScreenState();
}

class _HabitFormScreenState extends ConsumerState<HabitFormScreen> {
  late final TextEditingController _name;
  late final TextEditingController _description;

  @override
  void initState() {
    super.initState();
    final draft = ref.read(habitFormControllerProvider(widget.habitId));
    _name = TextEditingController(text: draft.name);
    _description = TextEditingController(text: draft.description);
  }

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final provider = habitFormControllerProvider(widget.habitId);
    final draft = ref.watch(provider);
    final controller = ref.read(provider.notifier);
    final shiftTypes =
        ref.watch(shiftSetupProvider).value?.activeTypes ?? ShiftType.defaults;
    final remindersEnabled =
        (ref.watch(settingsControllerProvider).value ?? AppSettings.defaults)
            .remindersEnabled;

    Future<void> pickReminder(String key) async {
      final current = draft.reminders[key] ?? const LocalTime(9, 0);
      final picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: current.hour, minute: current.minute),
        helpText: l10n.habitReminderAt,
      );
      if (picked == null) return;
      controller.setReminder(key, LocalTime(picked.hour, picked.minute));
    }

    final reminderKeys = draft.everyShift
        ? const [HabitRule.anyShiftReminderKey]
        : [
            for (final t in shiftTypes)
              if (draft.targetShiftTypeIds.contains(t.id)) t.id,
          ];

    Future<void> save() async {
      final result = await controller.save();
      if (!context.mounted) return;
      if (result.isSuccess) {
        showRySnackBar(context, l10n.habitSaved);
        context.pop();
      } else if (!ref.read(provider).nameError) {
        showRySnackBar(context, l10n.onboardingSaveError);
      }
    }

    return RyPage(
      title: draft.isEdit ? l10n.habitEditTitle : l10n.habitNewTitle,
      leading: CloseButton(onPressed: () => context.pop()),
      slivers: [
        RySliverPadding(
          sliver: SliverList.list(
            children: [
              const SizedBox(height: AppSpacing.sm),
              TextField(
                controller: _name,
                onChanged: controller.setName,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: l10n.habitName,
                  hintText: l10n.habitNameHint,
                  errorText: draft.nameError ? l10n.habitNameRequired : null,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              TextField(
                controller: _description,
                onChanged: controller.setDescription,
                textCapitalization: TextCapitalization.sentences,
                maxLines: 2,
                decoration: InputDecoration(labelText: l10n.habitDescription),
              ),
              RySectionHeader(l10n.habitIcon),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  for (final entry in HabitIcons.all.entries)
                    _PickTile(
                      selected: draft.iconKey == entry.key,
                      semanticLabel: entry.key,
                      onTap: () => controller.setIcon(entry.key),
                      child: Icon(entry.value),
                    ),
                ],
              ),
              RySectionHeader(l10n.habitColor),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  for (final value in HabitColors.all)
                    _PickTile(
                      selected: draft.colorValue == value,
                      semanticLabel: '#${value.toRadixString(16)}',
                      onTap: () => controller.setColor(value),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Color(value),
                          shape: BoxShape.circle,
                        ),
                        child: SizedBox.square(
                          dimension: 28,
                          child: draft.colorValue == value
                              ? Icon(
                                  Icons.check,
                                  size: 18,
                                  color: habitForeground(Color(value)),
                                )
                              : null,
                        ),
                      ),
                    ),
                ],
              ),
              RySectionHeader(l10n.habitDueOn),
              RyCard(
                padding: EdgeInsets.zero,
                child: RadioGroup<bool>(
                  groupValue: draft.everyShift,
                  onChanged: (every) {
                    if (every ?? true) {
                      controller.setEveryShift();
                    } else if (shiftTypes.isNotEmpty) {
                      controller.toggleShift(shiftTypes.first.id);
                    }
                  },
                  child: Column(
                    children: [
                      RadioListTile<bool>(
                        value: true,
                        title: Text(l10n.habitDueEveryDay),
                      ),
                      RadioListTile<bool>(
                        value: false,
                        title: Text(l10n.habitDueOnShifts),
                      ),
                      if (!draft.everyShift)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                            AppSpacing.lg,
                            0,
                            AppSpacing.lg,
                            AppSpacing.lg,
                          ),
                          child: Wrap(
                            spacing: AppSpacing.sm,
                            runSpacing: AppSpacing.sm,
                            children: [
                              for (final type in shiftTypes)
                                FilterChip(
                                  avatar: ShiftBadge(shift: type, size: 22),
                                  label: Text(type.displayName(l10n)),
                                  selected: draft.targetShiftTypeIds.contains(
                                    type.id,
                                  ),
                                  onSelected: (_) =>
                                      controller.toggleShift(type.id),
                                ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              RySectionHeader(l10n.habitWeekdays),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  FilterChip(
                    label: Text(l10n.habitWeekdaysAny),
                    selected: draft.weekdays == null,
                    onSelected: (_) => controller.setAnyWeekday(),
                  ),
                  for (var w = 1; w <= 7; w++)
                    FilterChip(
                      label: Text(
                        MaterialLocalizations.of(context).narrowWeekdays[w % 7],
                      ),
                      tooltip: _weekdayName(context, w),
                      selected: draft.weekdays?.contains(w) ?? false,
                      onSelected: (_) => controller.toggleWeekday(w),
                    ),
                ],
              ),
              RySectionHeader(l10n.habitReminder),
              RyCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    if (!draft.everyShift)
                      ListTile(
                        dense: true,
                        title: Text(l10n.habitReminderPerShift),
                      ),
                    for (final key in reminderKeys)
                      _ReminderRow(
                        label: key == HabitRule.anyShiftReminderKey
                            ? l10n.habitReminderAt
                            : shiftTypes
                                  .firstWhere((t) => t.id == key)
                                  .displayName(l10n),
                        time: draft.reminders[key],
                        onPick: () => pickReminder(key),
                        onClear: () => controller.setReminder(key, null),
                      ),
                    if (!remindersEnabled && draft.reminders.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.lg,
                          0,
                          AppSpacing.lg,
                          AppSpacing.md,
                        ),
                        child: Text(
                          l10n.habitReminderGlobalOff,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.error,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (draft.isEdit) ...[
                const SizedBox(height: AppSpacing.md),
                Text(
                  l10n.habitRuleHint,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.xxl),
              RyButton(
                label: l10n.commonSave,
                icon: Icons.check,
                expand: true,
                loading: draft.saving,
                onPressed: save,
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _weekdayName(BuildContext context, int isoWeekday) {
    // DateTime(2026, 3, 2) is a Monday.
    final date = DateTime(2026, 3, 2 + isoWeekday - 1);
    return MaterialLocalizations.of(context).formatFullDate(date);
  }
}

class _PickTile extends StatelessWidget {
  const _PickTile({
    required this.selected,
    required this.semanticLabel,
    required this.onTap,
    required this.child,
  });

  final bool selected;
  final String semanticLabel;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      selected: selected,
      label: semanticLabel,
      excludeSemantics: true,
      child: Material(
        color: selected ? scheme.primaryContainer : scheme.surfaceContainer,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.smAll,
          side: BorderSide(
            color: selected ? scheme.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.smAll,
          child: SizedBox.square(
            dimension: AppSpacing.touchTarget,
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}

/// One reminder time: tap to pick, trailing button to clear.
class _ReminderRow extends StatelessWidget {
  const _ReminderRow({
    required this.label,
    required this.time,
    required this.onPick,
    required this.onClear,
  });

  final String label;
  final LocalTime? time;
  final VoidCallback onPick;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ListTile(
      leading: const Icon(Icons.notifications_outlined),
      title: Text(label),
      subtitle: Text(
        time == null ? l10n.habitReminderOff : formatLocalTime(context, time!),
      ),
      trailing: time == null
          ? const Icon(Icons.chevron_right)
          : IconButton(
              tooltip: l10n.commonDelete,
              icon: const Icon(Icons.close),
              onPressed: onClear,
            ),
      onTap: onPick,
    );
  }
}
