import 'package:flutter_test/flutter_test.dart';
import 'package:rytmavo/core/database/app_database.dart';
import 'package:rytmavo/core/database/database_factory.dart';
import 'package:rytmavo/core/date/clock.dart';
import 'package:rytmavo/core/date/local_date.dart';
import 'package:rytmavo/core/date/local_time.dart';
import 'package:rytmavo/features/shifts/data/repositories/drift_shift_repository.dart';
import 'package:rytmavo/features/shifts/domain/entities/rotation_pattern.dart';
import 'package:rytmavo/features/shifts/domain/entities/shift_override.dart';
import 'package:rytmavo/features/shifts/domain/entities/shift_type.dart';

void main() {
  late AppDatabase db;
  late DriftShiftRepository repo;

  setUp(() {
    db = openInMemoryDatabase();
    repo = DriftShiftRepository(db, FixedClock(DateTime(2026, 10, 10, 9)));
  });
  tearDown(() => db.close());

  const day = LocalDate(2026, 10, 10);

  RotationPattern pattern(String id, LocalDate from, List<String> slots) =>
      RotationPattern(id: id, validFrom: from, anchorDate: from, slots: slots);

  test('empty database yields an empty setup', () async {
    final s = await repo.load();
    expect(s.types, isEmpty);
    expect(s.hasRotation, isFalse);
  });

  test('shift types round-trip and upsert by id', () async {
    expect((await repo.saveShiftTypes(ShiftType.defaults)).isSuccess, isTrue);
    var s = await repo.load();
    expect(s.types, ShiftType.defaults);

    final early = ShiftType.defaults.first.copyWith(
      start: const LocalTime(5, 30),
      end: const LocalTime(13, 30),
      name: 'Frühdienst',
    );
    await repo.saveShiftTypes([early]);
    s = await repo.load();
    expect(s.types.length, 4);
    expect(s.typeById('early'), early);
  });

  test('rotation versions: same validFrom replaces, others are kept', () async {
    await repo.saveShiftTypes(ShiftType.defaults);
    await repo.addRotationVersion(pattern('a', day, ['early', 'off']));
    await repo.addRotationVersion(pattern('b', day, ['late', 'off']));
    await repo.addRotationVersion(
      pattern('c', day.addDays(30), ['night', 'off']),
    );
    final s = await repo.load();
    expect(s.patterns.map((p) => p.id), ['b', 'c']);
    expect(s.dayOn(day).shift?.id, 'late');
    expect(s.dayOn(day.addDays(30)).shift?.id, 'night');
  });

  test('replaceHistory removes every earlier version', () async {
    await repo.saveShiftTypes(ShiftType.defaults);
    await repo.addRotationVersion(pattern('a', day, ['early']));
    await repo.addRotationVersion(pattern('b', day.addDays(5), ['late']));
    await repo.addRotationVersion(
      pattern('c', day.addDays(-100), ['night']),
      replaceHistory: true,
    );
    final s = await repo.load();
    expect(s.patterns.map((p) => p.id), ['c']);
    expect(s.dayOn(day.addDays(10)).shift?.id, 'night');
  });

  test('overrides can be set, replaced and removed', () async {
    await repo.saveShiftTypes(ShiftType.defaults);
    await repo.addRotationVersion(pattern('a', day, ['early']));
    await repo.setOverride(
      const ShiftOverride(date: day, shiftTypeId: 'night'),
    );
    await repo.setOverride(const ShiftOverride(date: day, shiftTypeId: 'off'));
    var s = await repo.load();
    expect(s.overrideCount, 1);
    expect(s.dayOn(day).shift?.id, 'off');

    await repo.removeOverride(day);
    s = await repo.load();
    expect(s.dayOn(day).shift?.id, 'early');
  });

  test('override with an unknown shift type fails without throwing', () async {
    final result = await repo.setOverride(
      const ShiftOverride(date: day, shiftTypeId: 'missing'),
    );
    expect(result.isFailure, isTrue);
  });

  test('corrupt rotation rows are skipped', () async {
    await repo.saveShiftTypes(ShiftType.defaults);
    await db
        .into(db.rotationPatterns)
        .insert(
          RotationPatternsCompanion.insert(
            id: 'bad',
            validFrom: '2026-13-01',
            anchorDate: '2026-01-01',
            slotsJson: '["early"]',
            createdAt: DateTime(2026),
          ),
        );
    await db
        .into(db.rotationPatterns)
        .insert(
          RotationPatternsCompanion.insert(
            id: 'bad2',
            validFrom: '2026-01-01',
            anchorDate: '2026-01-01',
            slotsJson: 'not json',
            createdAt: DateTime(2026),
          ),
        );
    final s = await repo.load();
    expect(s.patterns, isEmpty);
  });

  test('watch emits after every change', () async {
    final emissions = <int>[];
    final sub = repo.watch().listen((s) => emissions.add(s.types.length));
    await pumpEventQueue();
    await repo.saveShiftTypes(ShiftType.defaults);
    await pumpEventQueue();
    await sub.cancel();
    expect(emissions.first, 0);
    expect(emissions.last, 4);
  });
}
