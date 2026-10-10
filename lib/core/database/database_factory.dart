import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'app_database.dart';

/// Opens the production database in the app's private documents directory.
AppDatabase openAppDatabase() => AppDatabase(
  driftDatabase(
    name: 'rytmavo',
    native: const DriftNativeOptions(shareAcrossIsolates: true),
  ),
);

/// In-memory database for tests and previews.
AppDatabase openInMemoryDatabase() =>
    AppDatabase(DatabaseConnection(NativeDatabase.memory()));
