import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/date/local_date.dart';
import '../../../../core/date/local_time.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/habit.dart';
import '../../domain/entities/habit_completion.dart';
import '../../domain/entities/habit_plan.dart';
import '../../domain/entities/habit_rule.dart';
import '../../domain/repositories/habit_repository.dart';

final class DriftHabitRepository implements HabitRepository {
  DriftHabitRepository(this._db);

  final AppDatabase _db;

  @override
  Future<HabitPlan> load() async {
    final habits = await _db.select(_db.habits).get();
    final rules = await _db.select(_db.habitRules).get();
    final completions = await _db.select(_db.habitCompletions).get();
    return HabitPlan(
      habits: habits.map(_habitFromRow).nonNulls.toList(),
      rules: rules.map(_ruleFromRow).nonNulls.toList(),
      completions: completions.map(_completionFromRow).nonNulls.toList(),
    );
  }

  @override
  Stream<HabitPlan> watch() => _db
      .customSelect(
        'SELECT 1',
        readsFrom: {_db.habits, _db.habitRules, _db.habitCompletions},
      )
      .watch()
      .asyncMap((_) => load());

  @override
  Future<Result<void>> saveHabit(Habit habit, HabitRule rule) =>
      guardStorage(context: 'saveHabit', () async {
        await _db.transaction(() async {
          await _db
              .into(_db.habits)
              .insert(
                HabitsCompanion.insert(
                  id: habit.id,
                  name: habit.name,
                  description: Value(habit.description),
                  iconKey: habit.iconKey,
                  color: habit.colorValue,
                  createdOn: habit.createdOn.toIsoString(),
                  archivedOn: Value(habit.archivedOn?.toIsoString()),
                  sortOrder: habit.sortOrder,
                ),
                onConflict: DoUpdate(
                  (_) => HabitsCompanion(
                    name: Value(habit.name),
                    description: Value(habit.description),
                    iconKey: Value(habit.iconKey),
                    color: Value(habit.colorValue),
                    archivedOn: Value(habit.archivedOn?.toIsoString()),
                    sortOrder: Value(habit.sortOrder),
                  ),
                ),
              );
          await (_db.delete(_db.habitRules)..where(
                (r) =>
                    r.habitId.equals(habit.id) &
                    r.validFrom.equals(rule.validFrom.toIsoString()),
              ))
              .go();
          await _db
              .into(_db.habitRules)
              .insert(
                HabitRulesCompanion.insert(
                  id: rule.id,
                  habitId: habit.id,
                  validFrom: rule.validFrom.toIsoString(),
                  targetShiftTypeIdsJson: jsonEncode(
                    rule.targetShiftTypeIds.toList()..sort(),
                  ),
                  weekdaysJson: Value(
                    rule.weekdays == null
                        ? null
                        : jsonEncode(rule.weekdays!.toList()..sort()),
                  ),
                  remindersJson: Value(
                    rule.reminders == null
                        ? null
                        : jsonEncode({
                            for (final e in rule.reminders!.entries)
                              e.key: e.value.toIsoString(),
                          }),
                  ),
                ),
              );
        });
      });

  @override
  Future<Result<void>> archiveHabit(String habitId, LocalDate from) =>
      guardStorage(context: 'archiveHabit', () async {
        await (_db.update(_db.habits)..where((h) => h.id.equals(habitId)))
            .write(HabitsCompanion(archivedOn: Value(from.toIsoString())));
      });

  @override
  Future<Result<void>> deleteHabit(String habitId) =>
      guardStorage(context: 'deleteHabit', () async {
        // Rules and completions cascade (foreign keys are enabled).
        await (_db.delete(_db.habits)..where((h) => h.id.equals(habitId))).go();
      });

  @override
  Future<Result<void>> setCompleted(
    String habitId,
    LocalDate date, {
    required bool completed,
    required DateTime now,
  }) => guardStorage(context: 'setCompleted', () async {
    if (completed) {
      await _db
          .into(_db.habitCompletions)
          .insert(
            HabitCompletionsCompanion.insert(
              habitId: habitId,
              date: date.toIsoString(),
              completedAt: now,
            ),
            mode: InsertMode.insertOrIgnore,
          );
    } else {
      await (_db.delete(_db.habitCompletions)..where(
            (c) =>
                c.habitId.equals(habitId) & c.date.equals(date.toIsoString()),
          ))
          .go();
    }
  });

  @override
  Future<Result<void>> reorder(List<String> habitIdsInOrder) =>
      guardStorage(context: 'reorder', () async {
        await _db.batch((batch) {
          for (var i = 0; i < habitIdsInOrder.length; i++) {
            batch.update(
              _db.habits,
              HabitsCompanion(sortOrder: Value(i)),
              where: (h) => h.id.equals(habitIdsInOrder[i]),
            );
          }
        });
      });

  static Habit? _habitFromRow(HabitRow row) {
    final created = LocalDate.tryParse(row.createdOn);
    if (created == null) return null;
    return Habit(
      id: row.id,
      name: row.name,
      description: row.description,
      iconKey: row.iconKey,
      colorValue: row.color,
      createdOn: created,
      archivedOn: row.archivedOn == null
          ? null
          : LocalDate.tryParse(row.archivedOn!),
      sortOrder: row.sortOrder,
    );
  }

  static HabitRule? _ruleFromRow(HabitRuleRow row) {
    final validFrom = LocalDate.tryParse(row.validFrom);
    if (validFrom == null) return null;
    final targets = _decodeList(row.targetShiftTypeIdsJson);
    if (targets == null) return null;
    final weekdays = row.weekdaysJson == null
        ? null
        : _decodeList(row.weekdaysJson!)?.map(int.tryParse).nonNulls.toSet();
    Map<String, LocalTime>? reminders;
    if (row.remindersJson != null) {
      final decoded = _tryDecode(row.remindersJson!);
      if (decoded is Map<String, Object?>) {
        reminders = {};
        for (final e in decoded.entries) {
          final value = e.value;
          if (value is! String) continue;
          final time = LocalTime.tryParse(value);
          if (time != null) reminders[e.key] = time;
        }
      }
    }
    return HabitRule(
      id: row.id,
      habitId: row.habitId,
      validFrom: validFrom,
      targetShiftTypeIds: targets.toSet(),
      weekdays: weekdays,
      reminders: reminders,
    );
  }

  static HabitCompletion? _completionFromRow(HabitCompletionRow row) {
    final date = LocalDate.tryParse(row.date);
    if (date == null) return null;
    return HabitCompletion(
      habitId: row.habitId,
      date: date,
      completedAt: row.completedAt,
    );
  }

  static Object? _tryDecode(String json) {
    try {
      return jsonDecode(json);
    } on FormatException {
      return null;
    }
  }

  /// JSON array of scalars → list of strings, or `null` when malformed.
  static List<String>? _decodeList(String json) {
    final decoded = _tryDecode(json);
    if (decoded is! List) return null;
    return decoded.map((e) => e.toString()).toList();
  }
}
