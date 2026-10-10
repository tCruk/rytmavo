import 'package:drift/drift.dart';

import '../../features/habits/data/tables/habit_tables.dart';
import '../../features/settings/data/tables/settings_tables.dart';
import '../../features/shifts/data/tables/shift_tables.dart';

part 'app_database.g.dart';

/// Single local SQLite database. Tables are owned by the features' data
/// layers; this class only aggregates them and owns the migration history.
///
/// Schema history:
/// - v1 (0.1.0): shift_types, rotation_patterns, shift_overrides, habits,
///   habit_rules, habit_completions, settings_entries.
@DriftDatabase(
  tables: [
    ShiftTypes,
    RotationPatterns,
    ShiftOverrides,
    Habits,
    HabitRules,
    HabitCompletions,
    SettingsEntries,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  static const int currentSchemaVersion = 1;

  @override
  int get schemaVersion => currentSchemaVersion;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      // Add stepwise migrations here when the schema version grows.
      // Never drop user data in a migration.
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
