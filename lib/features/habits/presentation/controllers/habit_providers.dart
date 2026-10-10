import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/providers.dart';
import '../../../../core/result/result.dart';
import '../../../shifts/domain/entities/shift_setup.dart';
import '../../../shifts/presentation/controllers/shift_providers.dart';
import '../../domain/entities/habit_plan.dart';

/// Live habits, rule versions and completions.
final habitPlanProvider = StreamProvider<HabitPlan>(
  (ref) => ref.watch(habitRepositoryProvider).watch(),
);

/// Habits due today with their completion state; `null` while loading.
final todayHabitsProvider = Provider<List<DueHabit>?>((ref) {
  final plan = ref.watch(habitPlanProvider).value;
  final setup = ref.watch(shiftSetupProvider).value ?? ShiftSetup.empty;
  if (plan == null) return null;
  return plan.dueOnDate(ref.watch(todayProvider), setup);
});

/// Toggles a completion for today. Returns the repository result so the
/// UI can offer undo or show an error.
final habitCompletionActionsProvider = Provider<HabitCompletionActions>(
  HabitCompletionActions.new,
);

final class HabitCompletionActions {
  HabitCompletionActions(this._ref);

  final Ref _ref;

  Future<Result<void>> setCompletedToday(
    String habitId, {
    required bool completed,
  }) {
    final clock = _ref.read(clockProvider);
    return _ref
        .read(habitRepositoryProvider)
        .setCompleted(
          habitId,
          clock.today(),
          completed: completed,
          now: clock.now(),
        );
  }
}
