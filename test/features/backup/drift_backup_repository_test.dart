import 'package:flutter_test/flutter_test.dart';
import 'package:rytmavo/core/database/app_database.dart';
import 'package:rytmavo/core/database/database_factory.dart';
import 'package:rytmavo/core/date/clock.dart';
import 'package:rytmavo/core/date/local_date.dart';
import 'package:rytmavo/core/result/result.dart';
import 'package:rytmavo/features/backup/data/drift_backup_repository.dart';
import 'package:rytmavo/features/backup/domain/entities/backup_document.dart';
import 'package:rytmavo/features/habits/data/repositories/drift_habit_repository.dart';
import 'package:rytmavo/features/settings/data/repositories/drift_settings_repository.dart';
import 'package:rytmavo/features/settings/domain/entities/app_settings.dart';
import 'package:rytmavo/features/shifts/data/repositories/drift_shift_repository.dart';
import 'package:rytmavo/features/shifts/domain/entities/shift_override.dart';

import 'backup_codec_test.dart' show sampleDocument;

void main() {
  late AppDatabase db;
  late DriftShiftRepository shifts;
  late DriftHabitRepository habits;
  late DriftSettingsRepository settings;
  late DriftBackupRepository backup;

  setUp(() {
    db = openInMemoryDatabase();
    shifts = DriftShiftRepository(db, FixedClock(DateTime(2026, 10, 10, 9)));
    habits = DriftHabitRepository(db);
    settings = DriftSettingsRepository(db);
    backup = DriftBackupRepository(
      db,
      shifts: shifts,
      habits: habits,
      settings: settings,
    );
  });
  tearDown(() => db.close());

  Future<BackupDocument> exported() async {
    final result = await backup.exportDocument(
      now: DateTime.utc(2026, 10, 10),
      appVersion: 'test',
    );
    return (result as Success<BackupDocument>).value;
  }

  test('import then export yields the same data', () async {
    final doc = sampleDocument();
    expect((await backup.importDocument(doc)).isSuccess, isTrue);

    final back = await exported();
    expect(back.shiftTypes.length, doc.shiftTypes.length);
    expect(
      back.rotationPatterns.single.slots,
      doc.rotationPatterns.single.slots,
    );
    expect(back.shiftOverrides.single, doc.shiftOverrides.single);
    expect(back.habits.single.name, 'Wasser');
    expect(back.habitRules.single.reminders, doc.habitRules.single.reminders);
    expect(back.habitCompletions.single.date, const LocalDate(2026, 10, 2));
    expect(back.settings, doc.settings);

    // Feature repositories see the imported rows too.
    final setup = await shifts.load();
    expect(setup.hasRotation, isTrue);
    expect(setup.dayOn(const LocalDate(2026, 10, 3)).shift?.id, 'night');
  });

  test('import replaces existing data instead of merging', () async {
    await backup.importDocument(sampleDocument());
    await shifts.setOverride(
      const ShiftOverride(date: LocalDate(2026, 10, 4), shiftTypeId: 'off'),
    );
    expect((await shifts.load()).overrideCount, 2);

    await backup.importDocument(sampleDocument());
    expect((await shifts.load()).overrideCount, 1);
  });

  test('deleteAll empties every table and resets settings', () async {
    await backup.importDocument(sampleDocument());
    expect((await backup.deleteAll()).isSuccess, isTrue);

    final back = await exported();
    expect(back.isEmpty, isTrue);
    expect(back.shiftOverrides, isEmpty);
    expect(back.habitRules, isEmpty);
    expect(await settings.load(), AppSettings.defaults);
  });
}
