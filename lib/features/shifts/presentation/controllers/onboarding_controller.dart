import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/providers.dart';
import '../../../../core/date/local_time.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/rotation_pattern.dart';
import '../../domain/entities/rotation_preset.dart';
import '../../domain/entities/shift_setup.dart';
import '../../domain/entities/shift_type.dart';
import '../../domain/services/rotation_rules.dart';
import 'shift_providers.dart';

/// Steps of the setup flow, in order.
enum OnboardingStep { preset, rhythm, today, times }

/// Editable draft of the shift setup. Nothing is persisted until [save].
final class OnboardingDraft {
  const OnboardingDraft({
    required this.step,
    required this.preset,
    required this.slots,
    required this.todayPosition,
    required this.types,
    required this.isEdit,
    this.applyToPast = false,
    this.saving = false,
  });

  final OnboardingStep step;

  /// Selected template; `null` means "keep the current rhythm" (edit mode).
  final RotationPreset? preset;
  final List<String> slots;

  /// Cycle position (0-based) of today.
  final int todayPosition;

  /// Built-in shift types with the user's times, keyed by id.
  final Map<String, ShiftType> types;

  /// True when a rotation already exists and the user is changing it.
  final bool isEdit;

  /// Edit mode only: also reinterpret past days with the new rhythm.
  final bool applyToPast;
  final bool saving;

  bool get isFirstStep => step == OnboardingStep.values.first;

  bool get isLastStep => step == OnboardingStep.values.last;

  /// A preview setup built from the draft, for the rhythm and today steps.
  ShiftSetup previewSetup(RotationPattern pattern) => ShiftSetup(
    types: types.values.toList(),
    patterns: [pattern],
    overrides: const [],
  );

  OnboardingDraft copyWith({
    OnboardingStep? step,
    RotationPreset? preset,
    bool clearPreset = false,
    List<String>? slots,
    int? todayPosition,
    Map<String, ShiftType>? types,
    bool? applyToPast,
    bool? saving,
  }) {
    return OnboardingDraft(
      step: step ?? this.step,
      preset: clearPreset ? null : preset ?? this.preset,
      slots: slots ?? this.slots,
      todayPosition: todayPosition ?? this.todayPosition,
      types: types ?? this.types,
      isEdit: isEdit,
      applyToPast: applyToPast ?? this.applyToPast,
      saving: saving ?? this.saving,
    );
  }
}

final onboardingControllerProvider =
    NotifierProvider.autoDispose<OnboardingController, OnboardingDraft>(
      OnboardingController.new,
    );

class OnboardingController extends Notifier<OnboardingDraft> {
  /// Order in which tapping a day cycles through the built-in shifts.
  static const List<String> cycleOrder = ['early', 'late', 'night', 'off'];

  @override
  OnboardingDraft build() {
    final setup = ref.read(shiftSetupProvider).value ?? ShiftSetup.empty;
    final today = ref.read(todayProvider);
    final types = {
      for (final t in ShiftType.defaults) t.id: setup.typeById(t.id) ?? t,
    };
    final current = setup.currentPattern;
    if (current == null) {
      return OnboardingDraft(
        step: OnboardingStep.preset,
        preset: RotationPreset.weekly3,
        slots: RotationPreset.weekly3.slots,
        todayPosition: 0,
        types: types,
        isEdit: false,
      );
    }
    return OnboardingDraft(
      step: OnboardingStep.preset,
      preset: null,
      slots: current.slots,
      todayPosition: current.positionOf(today),
      types: types,
      isEdit: true,
    );
  }

  void selectPreset(RotationPreset preset) {
    state = state.copyWith(
      preset: preset,
      slots: preset.slots,
      todayPosition: 0,
    );
  }

  /// Edit mode: go back to the stored rhythm.
  void selectCurrent() {
    final fresh = build();
    state = state.copyWith(
      clearPreset: true,
      slots: fresh.slots,
      todayPosition: fresh.todayPosition,
    );
  }

  /// Advances day [index] to the next shift in [cycleOrder].
  void cycleSlot(int index) {
    final slots = [...state.slots];
    final next = (cycleOrder.indexOf(slots[index]) + 1) % cycleOrder.length;
    slots[index] = cycleOrder[next];
    state = state.copyWith(slots: slots);
  }

  void addDay() {
    if (state.slots.length >= RotationRules.maxCycleLength) return;
    state = state.copyWith(slots: [...state.slots, 'off']);
  }

  void removeLastDay() {
    if (state.slots.length <= 1) return;
    final slots = state.slots.sublist(0, state.slots.length - 1);
    state = state.copyWith(
      slots: slots,
      todayPosition: state.todayPosition.clamp(0, slots.length - 1),
    );
  }

  void setTodayPosition(int position) {
    state = state.copyWith(
      todayPosition: position.clamp(0, state.slots.length - 1),
    );
  }

  void setTimes(String shiftTypeId, {LocalTime? start, LocalTime? end}) {
    final type = state.types[shiftTypeId];
    if (type == null) return;
    state = state.copyWith(
      types: {
        ...state.types,
        shiftTypeId: type.copyWith(start: start, end: end),
      },
    );
  }

  void setApplyToPast({required bool value}) {
    state = state.copyWith(applyToPast: value);
  }

  void next() {
    if (state.isLastStep) return;
    state = state.copyWith(step: OnboardingStep.values[state.step.index + 1]);
  }

  void back() {
    if (state.isFirstStep) return;
    state = state.copyWith(step: OnboardingStep.values[state.step.index - 1]);
  }

  /// The rotation version the draft would store.
  RotationPattern draftPattern() {
    final today = ref.read(todayProvider);
    final firstVersion = !state.isEdit || state.applyToPast;
    return RotationPattern(
      id: 'rotation-${ref.read(clockProvider).now().microsecondsSinceEpoch}',
      validFrom: firstVersion ? RotationRules.firstVersionValidFrom : today,
      anchorDate: RotationRules.anchorFor(
        today: today,
        todayPosition: state.todayPosition,
      ),
      slots: state.slots,
    );
  }

  /// Persists shift types and the rotation, then marks onboarding done.
  Future<Result<void>> save() async {
    final failure = RotationRules.validate(
      state.slots,
      state.types.keys.toSet(),
    );
    if (failure != null) return Result.failure(failure);

    state = state.copyWith(saving: true);
    final repo = ref.read(shiftRepositoryProvider);
    final pattern = draftPattern();
    final typesResult = await repo.saveShiftTypes(state.types.values.toList());
    final result = typesResult.isFailure
        ? typesResult
        : await repo.addRotationVersion(
            pattern,
            replaceHistory: state.isEdit && state.applyToPast,
          );
    if (result.isSuccess) {
      final settingsRepo = ref.read(settingsRepositoryProvider);
      final settings = await settingsRepo.load();
      await settingsRepo.save(settings.copyWith(onboardingCompleted: true));
    }
    if (ref.mounted) state = state.copyWith(saving: false);
    return result;
  }
}
