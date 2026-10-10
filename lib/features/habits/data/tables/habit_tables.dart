import 'package:drift/drift.dart';

@DataClassName('HabitRow')
class Habits extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();

  /// Key into the app's icon catalogue (domain-level string, not IconData).
  TextColumn get iconKey => text()();
  IntColumn get color => integer()();

  /// ISO date of creation; the habit is never due before this day.
  TextColumn get createdOn => text()();

  /// ISO date from which the habit is archived (inclusive), or null.
  TextColumn get archivedOn => text().nullable()();
  IntColumn get sortOrder => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Versioned eligibility rules. The rule in effect for a date is the one
/// with the greatest `validFrom <= date`, so past statistics never change
/// when the user edits a habit today.
@DataClassName('HabitRuleRow')
class HabitRules extends Table {
  TextColumn get id => text()();
  TextColumn get habitId =>
      text().references(Habits, #id, onDelete: KeyAction.cascade)();
  TextColumn get validFrom => text()();

  /// JSON array of shift type ids; empty array = due on every shift.
  TextColumn get targetShiftTypeIdsJson => text()();

  /// JSON array of ISO weekdays (1 = Monday … 7 = Sunday) or null = any.
  TextColumn get weekdaysJson => text().nullable()();

  /// JSON object `{ "<shiftTypeId>": "HH:mm" }` or null = no reminders.
  TextColumn get remindersJson => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// At most one completion per habit and local calendar day (primary key).
@DataClassName('HabitCompletionRow')
class HabitCompletions extends Table {
  TextColumn get habitId =>
      text().references(Habits, #id, onDelete: KeyAction.cascade)();
  TextColumn get date => text()();
  DateTimeColumn get completedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {habitId, date};
}
