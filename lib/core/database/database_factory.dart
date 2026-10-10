import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'app_database.dart';

/// Opens the production database in the app's private documents directory.
///
/// Queries run on drift's background connection, but the connection (and
/// its stream-query store) belongs to the UI isolate: the app has no second
/// isolate that needs the database, and `shareAcrossIsolates` adds a
/// detached server isolate that survives hot restarts (see ADR-014).
AppDatabase openAppDatabase() => AppDatabase(driftDatabase(name: 'rytmavo'));

/// In-memory database for tests and previews.
AppDatabase openInMemoryDatabase() =>
    AppDatabase(DatabaseConnection(NativeDatabase.memory()));
