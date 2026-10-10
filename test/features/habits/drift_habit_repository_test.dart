import 'package:flutter_test/flutter_test.dart';
import 'package:rytmavo/core/database/app_database.dart';
import 'package:rytmavo/core/database/database_factory.dart';
import 'package:rytmavo/core/date/local_date.dart';
import 'package:rytmavo/core/date/local_time.dart';
import 'package:rytmavo/features/habits/data/repositories/drift_habit_repository.dart';
import 'package:rytmavo/features/habits/domain/entities/habit.dart';
import 'package:rytmavo/features/habits/domain/entities/habit_rule.dart';

void main() {
  late AppDatabase db;
  late DriftHabitRepository repo;

  setUp(() {
    db = openInMemoryDatabase();
    repo = DriftHabitRepository(db);
  });
  tearDown(() => db.close());

  const day = LocalDate(2026, 10, 10);
  const habit = Habit(
    id: 'h1',
    name: 'Wasser trinken',
    description: '2 Liter',
    iconKey: 'water',
    colorValue: 0xFF123456,
    createdOn: day,
    sortOrder: 0,
  );
  final rule = HabitRule(
    id: 'r1',
    habitId: 'h1',
    validFrom: day,
    targetShiftTypeIds: const {'early', 'night'},
    weekdays: const {1, 2, 3},
    reminders: const {'early': LocalTime(7, 30)},
  );

  test('habit and rule round-trip', () async {
    expect((await repo.saveHabit(habit, rule)).isSuccess, isTrue);
    final plan = await repo.load();
    expect(plan.habits.single, habit);
    expect(plan.currentRule('h1'), rule);
    expect(plan.currentRule('h1')?.reminders?['early'], const LocalTime(7, 30));
  });

  test('saving again upserts the habit and versions the rule', () async {
    await repo.saveHabit(habit, rule);
    final renamed = habit.copyWith(name: 'Tee trinken');
    await repo.saveHabit(
      renamed,
      rule.copyWith(id: 'r1b', targetShiftTypeIds: {'late'}),
    );
    await repo.saveHabit(
      renamed,
      rule.copyWith(
        id: 'r2',
        validFrom: day.addDays(3),
        targetShiftTypeIds: {},
        clearWeekdays: true,
      ),
    );
    final plan = await repo.load();
    expect(plan.habits.single.name, 'Tee trinken');
    expect(plan.rulesOf('h1').map((r) => r.id), ['r1b', 'r2']);
    expect(plan.ruleOn('h1', day)?.targetShiftTypeIds, {'late'});
    expect(plan.ruleOn('h1', day.addDays(3))?.appliesToEveryShift, isTrue);
  });

  test('completions toggle idempotently', () async {
    await repo.saveHabit(habit, rule);
    final now = DateTime(2026, 10, 10, 8);
    await repo.setCompleted('h1', day, completed: true, now: now);
    await repo.setCompleted('h1', day, completed: true, now: now);
    var plan = await repo.load();
    expect(plan.isCompleted('h1', day), isTrue);
    expect(plan.isCompleted('h1', day.addDays(1)), isFalse);

    await repo.setCompleted('h1', day, completed: false, now: now);
    plan = await repo.load();
    expect(plan.isCompleted('h1', day), isFalse);
  });

  test('archive keeps data, delete cascades', () async {
    await repo.saveHabit(habit, rule);
    await repo.setCompleted('h1', day, completed: true, now: DateTime(2026));
    await repo.archiveHabit('h1', day.addDays(1));
    var plan = await repo.load();
    expect(plan.habits.single.archivedOn, day.addDays(1));
    expect(plan.isCompleted('h1', day), isTrue);

    await repo.deleteHabit('h1');
    plan = await repo.load();
    expect(plan.habits, isEmpty);
    expect(await db.select(db.habitRules).get(), isEmpty);
    expect(await db.select(db.habitCompletions).get(), isEmpty);
  });

  test('reorder writes sortOrder', () async {
    await repo.saveHabit(habit, rule);
    await repo.saveHabit(
      habit.copyWith(sortOrder: 1).copyWith(name: 'B'),
      rule,
    );
    const other = Habit(
      id: 'h2',
      name: 'Zwei',
      iconKey: 'x',
      colorValue: 0,
      createdOn: day,
      sortOrder: 1,
    );
    await repo.saveHabit(other, rule.copyWith(id: 'r-h2'));
    await repo.reorder(['h2', 'h1']);
    final plan = await repo.load();
    expect(plan.habits.map((h) => h.id), ['h2', 'h1']);
  });

  test('watch emits after changes', () async {
    final counts = <int>[];
    final sub = repo.watch().listen((p) => counts.add(p.habits.length));
    await pumpEventQueue();
    await repo.saveHabit(habit, rule);
    await pumpEventQueue();
    await sub.cancel();
    expect(counts.first, 0);
    expect(counts.last, 1);
  });
}
