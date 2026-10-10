import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/result/result.dart';
import '../../habits/data/repositories/drift_habit_repository.dart';
import '../../settings/data/repositories/drift_settings_repository.dart';
import '../../shifts/data/repositories/drift_shift_repository.dart';
import '../domain/entities/backup_document.dart';
import '../domain/repositories/backup_repository.dart';

/// Builds the backup from the feature repositories' own loaders and writes
/// an import in one transaction, so a failed import leaves the old data
/// untouched.
final class DriftBackupRepository implements BackupRepository {
  DriftBackupRepository(
    this._db, {
    required this.shifts,
    required this.habits,
    required this.settings,
  });

  final AppDatabase _db;
  final DriftShiftRepository shifts;
  final DriftHabitRepository habits;
  final DriftSettingsRepository settings;

  @override
  Future<Result<BackupDocument>> exportDocument({
    required DateTime now,
    required String appVersion,
  }) => guardStorage(context: 'export', () async {
    final setup = await shifts.load();
    final plan = await habits.load();
    final overrides = await shifts.loadOverrides();
    final completions = await habits.loadCompletions();
    final appSettings = await settings.load();
    return BackupDocument(
      exportedAt: now,
      appVersion: appVersion,
      shiftTypes: setup.types,
      rotationPatterns: setup.patterns,
      shiftOverrides: overrides,
      habits: plan.habits,
      habitRules: [for (final h in plan.habits) ...plan.rulesOf(h.id)],
      habitCompletions: completions,
      settings: appSettings,
    );
  });

  @override
  Future<Result<void>> importDocument(BackupDocument doc) =>
      guardStorage(context: 'import', () async {
        await _db.transaction(() async {
          await _wipe();
          final now = DateTime.now();
          await _db.batch((b) {
            for (final t in doc.shiftTypes) {
              b.insert(
                _db.shiftTypes,
                ShiftTypesCompanion.insert(
                  id: t.id,
                  name: t.name,
                  abbreviation: t.abbreviation,
                  kind: t.kind.name,
                  color: t.colorValue,
                  startMinutes: Value(t.start?.minutesSinceMidnight),
                  endMinutes: Value(t.end?.minutesSinceMidnight),
                  sortOrder: t.sortOrder,
                  isArchived: Value(t.isArchived),
                  createdAt: now,
                ),
              );
            }
            for (final p in doc.rotationPatterns) {
              b.insert(
                _db.rotationPatterns,
                RotationPatternsCompanion.insert(
                  id: p.id,
                  validFrom: p.validFrom.toIsoString(),
                  anchorDate: p.anchorDate.toIsoString(),
                  slotsJson: jsonEncode(p.slots),
                  createdAt: now,
                ),
              );
            }
            for (final o in doc.shiftOverrides) {
              b.insert(
                _db.shiftOverrides,
                ShiftOverridesCompanion.insert(
                  date: o.date.toIsoString(),
                  shiftTypeId: o.shiftTypeId,
                  createdAt: now,
                ),
              );
            }
            for (final h in doc.habits) {
              b.insert(
                _db.habits,
                HabitsCompanion.insert(
                  id: h.id,
                  name: h.name,
                  description: Value(h.description),
                  iconKey: h.iconKey,
                  color: h.colorValue,
                  createdOn: h.createdOn.toIsoString(),
                  archivedOn: Value(h.archivedOn?.toIsoString()),
                  sortOrder: h.sortOrder,
                ),
              );
            }
            for (final r in doc.habitRules) {
              b.insert(
                _db.habitRules,
                HabitRulesCompanion.insert(
                  id: r.id,
                  habitId: r.habitId,
                  validFrom: r.validFrom.toIsoString(),
                  targetShiftTypeIdsJson: jsonEncode(
                    r.targetShiftTypeIds.toList()..sort(),
                  ),
                  weekdaysJson: Value(
                    r.weekdays == null
                        ? null
                        : jsonEncode(r.weekdays!.toList()..sort()),
                  ),
                  remindersJson: Value(
                    r.reminders == null
                        ? null
                        : jsonEncode({
                            for (final e in r.reminders!.entries)
                              e.key: e.value.toIsoString(),
                          }),
                  ),
                ),
              );
            }
            for (final c in doc.habitCompletions) {
              b.insert(
                _db.habitCompletions,
                HabitCompletionsCompanion.insert(
                  habitId: c.habitId,
                  date: c.date.toIsoString(),
                  completedAt: c.completedAt,
                ),
              );
            }
          });
          await settings.save(doc.settings);
        });
      });

  @override
  Future<Result<void>> deleteAll() =>
      guardStorage(context: 'deleteAll', () async {
        await _db.transaction(_wipe);
      });

  Future<void> _wipe() async {
    // Children first so foreign keys never complain.
    await _db.delete(_db.habitCompletions).go();
    await _db.delete(_db.habitRules).go();
    await _db.delete(_db.habits).go();
    await _db.delete(_db.shiftOverrides).go();
    await _db.delete(_db.rotationPatterns).go();
    await _db.delete(_db.shiftTypes).go();
    await _db.delete(_db.settingsEntries).go();
  }
}
