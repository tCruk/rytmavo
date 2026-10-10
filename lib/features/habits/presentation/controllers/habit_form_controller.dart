import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/providers.dart';
import '../../../../core/date/local_time.dart';
import '../../../../core/result/failure.dart';
import '../../../../core/result/result.dart';
import '../../../shifts/presentation/controllers/shift_providers.dart';
import '../../domain/entities/habit.dart';
import '../../domain/entities/habit_plan.dart';
import '../../domain/entities/habit_rule.dart';
import '../widgets/habit_visuals.dart';
import 'habit_providers.dart';

/// Editable draft of a habit and its current rule.
final class HabitDraft {
  const HabitDraft({
    required this.existing,
    required this.name,
    required this.description,
    required this.iconKey,
    required this.colorValue,
    required this.targetShiftTypeIds,
    required this.weekdays,
    required this.reminders,
    this.saving = false,
    this.nameError = false,
  });

  final Habit? existing;
  final String name;
  final String description;
  final String iconKey;
  final int colorValue;

  /// Empty = due every day.
  final Set<String> targetShiftTypeIds;

  /// `null` = any weekday.
  final Set<int>? weekdays;

  /// Reminder time per shift type id, or [HabitRule.anyShiftReminderKey].
  final Map<String, LocalTime> reminders;
  final bool saving;
  final bool nameError;

  bool get isEdit => existing != null;

  bool get everyShift => targetShiftTypeIds.isEmpty;

  HabitDraft copyWith({
    String? name,
    String? description,
    String? iconKey,
    int? colorValue,
    Set<String>? targetShiftTypeIds,
    Set<int>? weekdays,
    bool clearWeekdays = false,
    Map<String, LocalTime>? reminders,
    bool? saving,
    bool? nameError,
  }) {
    return HabitDraft(
      existing: existing,
      name: name ?? this.name,
      description: description ?? this.description,
      iconKey: iconKey ?? this.iconKey,
      colorValue: colorValue ?? this.colorValue,
      targetShiftTypeIds: targetShiftTypeIds ?? this.targetShiftTypeIds,
      weekdays: clearWeekdays ? null : weekdays ?? this.weekdays,
      reminders: reminders ?? this.reminders,
      saving: saving ?? this.saving,
      nameError: nameError ?? this.nameError,
    );
  }
}

/// One controller per edited habit (`null` id = new habit).
final habitFormControllerProvider = NotifierProvider.autoDispose
    .family<HabitFormController, HabitDraft, String?>(HabitFormController.new);

class HabitFormController extends Notifier<HabitDraft> {
  HabitFormController(this.habitId);

  final String? habitId;

  @override
  HabitDraft build() {
    final plan = ref.read(habitPlanProvider).value ?? HabitPlan.empty;
    final habit = habitId == null ? null : plan.habitById(habitId!);
    final rule = habit == null ? null : plan.currentRule(habit.id);
    return HabitDraft(
      existing: habit,
      name: habit?.name ?? '',
      description: habit?.description ?? '',
      iconKey: habit?.iconKey ?? HabitIcons.defaultKey,
      colorValue: habit?.colorValue ?? HabitColors.defaultValue,
      targetShiftTypeIds: rule?.targetShiftTypeIds ?? const {},
      weekdays: rule?.weekdays,
      reminders: rule?.reminders ?? const {},
    );
  }

  /// Sets or clears (`null`) the reminder for [key] (shift id or wildcard).
  void setReminder(String key, LocalTime? time) {
    final next = {...state.reminders};
    if (time == null) {
      next.remove(key);
    } else {
      next[key] = time;
    }
    state = state.copyWith(reminders: next);
  }

  void setName(String value) =>
      state = state.copyWith(name: value, nameError: false);

  void setDescription(String value) =>
      state = state.copyWith(description: value);

  void setIcon(String key) => state = state.copyWith(iconKey: key);

  void setColor(int value) => state = state.copyWith(colorValue: value);

  void setEveryShift() => state = state.copyWith(targetShiftTypeIds: {});

  void toggleShift(String shiftTypeId) {
    final next = {...state.targetShiftTypeIds};
    if (!next.remove(shiftTypeId)) next.add(shiftTypeId);
    state = state.copyWith(targetShiftTypeIds: next);
  }

  void setAnyWeekday() => state = state.copyWith(clearWeekdays: true);

  void toggleWeekday(int weekday) {
    final next = {...?state.weekdays};
    if (!next.remove(weekday)) next.add(weekday);
    state = state.copyWith(
      weekdays: next,
      clearWeekdays: next.isEmpty || next.length == 7,
    );
  }

  /// Validates and persists. A changed rule becomes a new version valid
  /// from today; an unchanged rule is left alone.
  /// Drops reminder entries that no longer match the due rule, so a habit
  /// switched from "every day" to specific shifts keeps only those.
  Map<String, LocalTime>? _effectiveReminders() {
    final kept = <String, LocalTime>{
      for (final e in state.reminders.entries)
        if (state.everyShift
            ? e.key == HabitRule.anyShiftReminderKey
            : state.targetShiftTypeIds.contains(e.key))
          e.key: e.value,
    };
    return kept.isEmpty ? null : kept;
  }

  Future<Result<void>> save() async {
    final name = state.name.trim();
    if (name.isEmpty) {
      state = state.copyWith(nameError: true);
      return const Result.failure(
        ValidationFailure('name is empty', field: 'name'),
      );
    }
    state = state.copyWith(saving: true);
    final today = ref.read(todayProvider);
    final stamp = ref.read(clockProvider).now().microsecondsSinceEpoch;
    final plan = ref.read(habitPlanProvider).value ?? HabitPlan.empty;
    final description = state.description.trim();

    final habit = state.existing == null
        ? Habit(
            id: 'habit-$stamp',
            name: name,
            description: description.isEmpty ? null : description,
            iconKey: state.iconKey,
            colorValue: state.colorValue,
            createdOn: today,
            sortOrder: plan.habits.length,
          )
        : state.existing!.copyWith(
            name: name,
            description: description.isEmpty ? null : description,
            clearDescription: description.isEmpty,
            iconKey: state.iconKey,
            colorValue: state.colorValue,
          );

    final current = plan.currentRule(habit.id);
    final draftRule = HabitRule(
      id: 'rule-$stamp',
      habitId: habit.id,
      validFrom: current == null ? habit.createdOn : today,
      targetShiftTypeIds: state.targetShiftTypeIds,
      weekdays: state.weekdays,
      reminders: _effectiveReminders(),
    );
    final rule = current != null && current.sameTermsAs(draftRule)
        ? current
        : draftRule;

    final result = await ref
        .read(habitRepositoryProvider)
        .saveHabit(habit, rule);
    if (ref.mounted) state = state.copyWith(saving: false);
    return result;
  }
}
