import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
import '../../core/date/clock.dart';
import '../../features/settings/data/repositories/drift_settings_repository.dart';
import '../../features/settings/domain/repositories/settings_repository.dart';

/// Composition root. Infrastructure providers are overridden in
/// `bootstrap()` (production) and in tests.

/// Must be overridden with an opened [AppDatabase].
final appDatabaseProvider = Provider<AppDatabase>(
  (ref) => throw UnimplementedError(
    'appDatabaseProvider must be overridden at the composition root',
  ),
);

final clockProvider = Provider<Clock>((ref) => const SystemClock());

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => DriftSettingsRepository(ref.watch(appDatabaseProvider)),
);
