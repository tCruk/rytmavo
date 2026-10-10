import 'package:drift/drift.dart';

/// Simple key/value store for app settings. Keys are defined in
/// `SettingsKeys`; values are strings.
@DataClassName('SettingsEntryRow')
class SettingsEntries extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}
