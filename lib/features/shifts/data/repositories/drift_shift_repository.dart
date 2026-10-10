import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/date/clock.dart';
import '../../../../core/date/local_date.dart';
import '../../../../core/date/local_time.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/rotation_pattern.dart';
import '../../domain/entities/shift_override.dart';
import '../../domain/entities/shift_setup.dart';
import '../../domain/entities/shift_type.dart';
import '../../domain/repositories/shift_repository.dart';

final class DriftShiftRepository implements ShiftRepository {
  DriftShiftRepository(this._db, this._clock);

  final AppDatabase _db;
  final Clock _clock;

  @override
  Future<ShiftSetup> load() async {
    final types = await _db.select(_db.shiftTypes).get();
    final patterns = await _db.select(_db.rotationPatterns).get();
    final overrides = await _db.select(_db.shiftOverrides).get();
    return ShiftSetup(
      types: types.map(_typeFromRow).toList(),
      patterns: patterns.map(_patternFromRow).nonNulls.toList(),
      overrides: overrides.map(_overrideFromRow).nonNulls.toList(),
    );
  }

  /// Uses a drift query stream over all three tables (instead of
  /// `tableUpdates` in an `async*` generator, whose cancellation hangs) so
  /// listeners can unsubscribe immediately.
  @override
  Stream<ShiftSetup> watch() => _db
      .customSelect(
        'SELECT 1',
        readsFrom: {_db.shiftTypes, _db.rotationPatterns, _db.shiftOverrides},
      )
      .watch()
      .asyncMap((_) => load());

  @override
  Future<Result<void>> saveShiftTypes(List<ShiftType> types) =>
      guardStorage(context: 'saveShiftTypes', () async {
        final now = _clock.now();
        await _db.batch((batch) {
          for (final t in types) {
            batch.insert(
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
              onConflict: DoUpdate(
                (_) => ShiftTypesCompanion(
                  name: Value(t.name),
                  abbreviation: Value(t.abbreviation),
                  kind: Value(t.kind.name),
                  color: Value(t.colorValue),
                  startMinutes: Value(t.start?.minutesSinceMidnight),
                  endMinutes: Value(t.end?.minutesSinceMidnight),
                  sortOrder: Value(t.sortOrder),
                  isArchived: Value(t.isArchived),
                ),
              ),
            );
          }
        });
      });

  @override
  Future<Result<void>> addRotationVersion(
    RotationPattern pattern, {
    bool replaceHistory = false,
  }) => guardStorage(context: 'addRotationVersion', () async {
    await _db.transaction(() async {
      if (replaceHistory) {
        await _db.delete(_db.rotationPatterns).go();
      } else {
        await (_db.delete(_db.rotationPatterns)..where(
              (r) => r.validFrom.equals(pattern.validFrom.toIsoString()),
            ))
            .go();
      }
      await _db
          .into(_db.rotationPatterns)
          .insert(
            RotationPatternsCompanion.insert(
              id: pattern.id,
              validFrom: pattern.validFrom.toIsoString(),
              anchorDate: pattern.anchorDate.toIsoString(),
              slotsJson: jsonEncode(pattern.slots),
              createdAt: _clock.now(),
            ),
          );
    });
  });

  @override
  Future<Result<void>> setOverride(ShiftOverride override) =>
      guardStorage(context: 'setOverride', () async {
        await _db
            .into(_db.shiftOverrides)
            .insertOnConflictUpdate(
              ShiftOverridesCompanion.insert(
                date: override.date.toIsoString(),
                shiftTypeId: override.shiftTypeId,
                createdAt: _clock.now(),
              ),
            );
      });

  @override
  Future<Result<void>> removeOverride(LocalDate date) =>
      guardStorage(context: 'removeOverride', () async {
        await (_db.delete(
          _db.shiftOverrides,
        )..where((o) => o.date.equals(date.toIsoString()))).go();
      });

  static ShiftType _typeFromRow(ShiftTypeRow row) => ShiftType(
    id: row.id,
    kind: ShiftKind.values.firstWhere(
      (k) => k.name == row.kind,
      orElse: () => ShiftKind.custom,
    ),
    name: row.name,
    abbreviation: row.abbreviation,
    colorValue: row.color,
    start: row.startMinutes == null
        ? null
        : LocalTime.fromMinutes(row.startMinutes!),
    end: row.endMinutes == null ? null : LocalTime.fromMinutes(row.endMinutes!),
    sortOrder: row.sortOrder,
    isArchived: row.isArchived,
  );

  /// Rows that cannot be parsed (corrupt import, newer app version) are
  /// skipped instead of crashing the whole schedule.
  static RotationPattern? _patternFromRow(RotationPatternRow row) {
    final validFrom = LocalDate.tryParse(row.validFrom);
    final anchor = LocalDate.tryParse(row.anchorDate);
    if (validFrom == null || anchor == null) return null;
    final Object? decoded;
    try {
      decoded = jsonDecode(row.slotsJson);
    } on FormatException {
      return null;
    }
    if (decoded is! List || decoded.isEmpty) return null;
    final slots = decoded.whereType<String>().toList();
    if (slots.length != decoded.length) return null;
    return RotationPattern(
      id: row.id,
      validFrom: validFrom,
      anchorDate: anchor,
      slots: slots,
    );
  }

  static ShiftOverride? _overrideFromRow(ShiftOverrideRow row) {
    final date = LocalDate.tryParse(row.date);
    if (date == null) return null;
    return ShiftOverride(date: date, shiftTypeId: row.shiftTypeId);
  }
}
