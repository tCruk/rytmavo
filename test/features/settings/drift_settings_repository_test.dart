import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rytmavo/core/database/app_database.dart';
import 'package:rytmavo/core/database/database_factory.dart';
import 'package:rytmavo/features/holidays/domain/entities/german_state.dart';
import 'package:rytmavo/features/settings/data/repositories/drift_settings_repository.dart';
import 'package:rytmavo/features/settings/domain/entities/app_settings.dart';

void main() {
  late AppDatabase db;
  late DriftSettingsRepository repo;

  setUp(() {
    db = openInMemoryDatabase();
    repo = DriftSettingsRepository(db);
  });

  tearDown(() => db.close());

  test('returns defaults on an empty database', () async {
    expect(await repo.load(), AppSettings.defaults);
  });

  test('round-trips every field', () async {
    const s = AppSettings(
      themeMode: AppThemeMode.dark,
      language: AppLanguage.en,
      onboardingCompleted: true,
      remindersEnabled: true,
      calendarConflictsEnabled: true,
      conflictCalendarIds: ['1', 'Kalender, mit Komma'],
      conflictRemindersEnabled: true,
      holidayState: GermanState.nw,
      showSchoolHolidays: true,
      holidaysAreDaysOff: true,
      holidaySetupDone: true,
    );
    await repo.save(s);
    expect(await repo.load(), s);
  });

  test('clearing the state stores "nationwide only"', () async {
    await repo.save(const AppSettings(holidayState: GermanState.by));
    await repo.save((await repo.load()).copyWith(clearHolidayState: true));
    expect((await repo.load()).holidayState, equals(null));
  });

  test('watch emits the current value and subsequent changes', () async {
    final events = <AppSettings>[];
    final sub = repo.watch().listen(events.add);
    await pumpEventQueue();
    await repo.save(const AppSettings(themeMode: AppThemeMode.light));
    await pumpEventQueue();
    await sub.cancel();
    expect(events.first, AppSettings.defaults);
    expect(events.last.themeMode, AppThemeMode.light);
  });

  test('unknown stored values fall back to defaults', () async {
    await db
        .into(db.settingsEntries)
        .insert(
          SettingsEntriesCompanion.insert(
            key: SettingsKeys.themeMode,
            value: 'neon',
          ),
          mode: InsertMode.insertOrReplace,
        );
    expect((await repo.load()).themeMode, AppThemeMode.system);
  });
}
