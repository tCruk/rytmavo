import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/database/app_database.dart';
import '../core/database/database_factory.dart';
import 'app.dart';
import 'di/providers.dart';

/// Composition root: opens infrastructure and starts the app.
///
/// No crash-reporting SDK is used by design; errors are logged to the
/// console in debug builds only.
Future<void> bootstrap({AppDatabase? database}) async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    if (kDebugMode) debugPrint(details.exceptionAsString());
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    if (kDebugMode) debugPrint('Uncaught error: $error\n$stack');
    return true;
  };

  final db = database ?? openAppDatabase();

  runApp(
    ProviderScope(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
      child: const RytmavoApp(),
    ),
  );
}
