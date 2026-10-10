import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';

/// Keys of the `settings_entries` table. Renaming a key requires a
/// migration that copies the old value.
abstract final class SettingsKeys {
  static const String themeMode = 'theme_mode';
  static const String language = 'language';
  static const String onboardingCompleted = 'onboarding_completed';
  static const String remindersEnabled = 'reminders_enabled';
}

final class DriftSettingsRepository implements SettingsRepository {
  DriftSettingsRepository(this._db);

  final AppDatabase _db;

  @override
  Future<AppSettings> load() async {
    final rows = await _db.select(_db.settingsEntries).get();
    return _fromRows(rows);
  }

  @override
  Stream<AppSettings> watch() =>
      _db.select(_db.settingsEntries).watch().map(_fromRows);

  @override
  Future<void> save(AppSettings settings) async {
    final entries = <String, String>{
      SettingsKeys.themeMode: settings.themeMode.name,
      SettingsKeys.language: settings.language.name,
      SettingsKeys.onboardingCompleted: settings.onboardingCompleted.toString(),
      SettingsKeys.remindersEnabled: settings.remindersEnabled.toString(),
    };
    await _db.batch((batch) {
      for (final entry in entries.entries) {
        batch.insert(
          _db.settingsEntries,
          SettingsEntriesCompanion.insert(key: entry.key, value: entry.value),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  AppSettings _fromRows(List<SettingsEntryRow> rows) {
    final map = {for (final r in rows) r.key: r.value};
    return AppSettings(
      themeMode: _enumOr(
        AppThemeMode.values,
        map[SettingsKeys.themeMode],
        AppSettings.defaults.themeMode,
      ),
      language: _enumOr(
        AppLanguage.values,
        map[SettingsKeys.language],
        AppSettings.defaults.language,
      ),
      onboardingCompleted: map[SettingsKeys.onboardingCompleted] == 'true',
      remindersEnabled: map[SettingsKeys.remindersEnabled] == 'true',
    );
  }

  /// Unknown stored values (e.g. from a newer app version) fall back to
  /// the default instead of crashing.
  static T _enumOr<T extends Enum>(List<T> values, String? name, T fallback) {
    for (final v in values) {
      if (v.name == name) return v;
    }
    return fallback;
  }
}
