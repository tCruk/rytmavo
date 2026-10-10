import '../../../../core/date/local_date.dart';
import '../../../../core/result/result.dart';
import '../entities/habit.dart';
import '../entities/habit_plan.dart';
import '../entities/habit_rule.dart';

abstract interface class HabitRepository {
  Future<HabitPlan> load();

  /// Emits the current plan immediately and after every change.
  Stream<HabitPlan> watch();

  /// Inserts or updates [habit] and stores [rule] as a rule version. A rule
  /// with the same `validFrom` as an existing version replaces it.
  Future<Result<void>> saveHabit(Habit habit, HabitRule rule);

  /// Marks the habit archived from [from] on; it stays in statistics.
  Future<Result<void>> archiveHabit(String habitId, LocalDate from);

  /// Removes the habit with all rules and completions. Irreversible.
  Future<Result<void>> deleteHabit(String habitId);

  Future<Result<void>> setCompleted(
    String habitId,
    LocalDate date, {
    required bool completed,
    required DateTime now,
  });

  /// Persists the given order (index = sortOrder).
  Future<Result<void>> reorder(List<String> habitIdsInOrder);
}
