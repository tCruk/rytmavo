import 'dart:async';

import 'package:rytmavo/core/date/local_date.dart';
import 'package:rytmavo/core/result/result.dart';
import 'package:rytmavo/features/habits/domain/entities/habit.dart';
import 'package:rytmavo/features/habits/domain/entities/habit_completion.dart';
import 'package:rytmavo/features/habits/domain/entities/habit_plan.dart';
import 'package:rytmavo/features/habits/domain/entities/habit_rule.dart';
import 'package:rytmavo/features/habits/domain/repositories/habit_repository.dart';

/// Habit repository without a database, for widget tests.
final class InMemoryHabitRepository implements HabitRepository {
  InMemoryHabitRepository({
    List<Habit> habits = const [],
    List<HabitRule> rules = const [],
  }) : _habits = {for (final h in habits) h.id: h},
       _rules = [...rules];

  final Map<String, Habit> _habits;
  final List<HabitRule> _rules;
  final Map<(String, LocalDate), HabitCompletion> _completions = {};
  final _controller = StreamController<HabitPlan>.broadcast();

  HabitPlan get current => HabitPlan(
    habits: _habits.values.toList(),
    rules: _rules,
    completions: _completions.values.toList(),
  );

  void _emit() => _controller.add(current);

  @override
  Future<HabitPlan> load() async => current;

  @override
  Stream<HabitPlan> watch() async* {
    yield current;
    yield* _controller.stream;
  }

  @override
  Future<Result<void>> saveHabit(Habit habit, HabitRule rule) async {
    _habits[habit.id] = habit;
    _rules.removeWhere(
      (r) => r.habitId == habit.id && r.validFrom == rule.validFrom,
    );
    _rules.add(rule);
    _emit();
    return const Result.success(null);
  }

  @override
  Future<Result<void>> archiveHabit(String habitId, LocalDate from) async {
    final h = _habits[habitId];
    if (h != null) _habits[habitId] = h.copyWith(archivedOn: from);
    _emit();
    return const Result.success(null);
  }

  @override
  Future<Result<void>> deleteHabit(String habitId) async {
    _habits.remove(habitId);
    _rules.removeWhere((r) => r.habitId == habitId);
    _completions.removeWhere((k, _) => k.$1 == habitId);
    _emit();
    return const Result.success(null);
  }

  @override
  Future<Result<void>> setCompleted(
    String habitId,
    LocalDate date, {
    required bool completed,
    required DateTime now,
  }) async {
    if (completed) {
      _completions[(habitId, date)] = HabitCompletion(
        habitId: habitId,
        date: date,
        completedAt: now,
      );
    } else {
      _completions.remove((habitId, date));
    }
    _emit();
    return const Result.success(null);
  }

  @override
  Future<Result<void>> reorder(List<String> habitIdsInOrder) async {
    for (var i = 0; i < habitIdsInOrder.length; i++) {
      final h = _habits[habitIdsInOrder[i]];
      if (h != null) _habits[h.id] = h.copyWith(sortOrder: i);
    }
    _emit();
    return const Result.success(null);
  }

  Future<void> dispose() => _controller.close();
}
