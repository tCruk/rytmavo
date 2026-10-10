import 'package:drift/drift.dart';

/// Shift types (built-in early/late/night/off and user-defined).
///
/// Colour is stored as a 32-bit ARGB int so the domain stays Flutter-free.
/// Times are minutes since midnight; `null` means "no time shown".
@DataClassName('ShiftTypeRow')
class ShiftTypes extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get abbreviation => text()();

  /// `early | late | night | off | custom` – see `ShiftKind` in the domain.
  TextColumn get kind => text()();
  IntColumn get color => integer()();
  IntColumn get startMinutes => integer().nullable()();
  IntColumn get endMinutes => integer().nullable()();
  IntColumn get sortOrder => integer()();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Versioned rotation patterns. The pattern in effect for a date is the one
/// with the greatest `validFrom <= date`. Editing a rotation inserts a new
/// row instead of mutating history.
@DataClassName('RotationPatternRow')
class RotationPatterns extends Table {
  TextColumn get id => text()();

  /// ISO date `YYYY-MM-DD` from which this version applies (inclusive).
  TextColumn get validFrom => text()();

  /// ISO date at which `slots[0]` applies; positions repeat modulo length.
  TextColumn get anchorDate => text()();

  /// JSON array of shift type ids, e.g. `["early","early","late",...]`.
  TextColumn get slotsJson => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Manual per-day overrides. An override always wins over the rotation.
@DataClassName('ShiftOverrideRow')
class ShiftOverrides extends Table {
  /// ISO date, one override per day.
  TextColumn get date => text()();
  TextColumn get shiftTypeId =>
      text().references(ShiftTypes, #id, onDelete: KeyAction.restrict)();
  TextColumn get note => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {date};
}
