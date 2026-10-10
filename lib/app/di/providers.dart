import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
import '../../core/date/clock.dart';
import '../../features/habits/data/repositories/drift_habit_repository.dart';
import '../../features/habits/domain/repositories/habit_repository.dart';
import '../../features/settings/data/repositories/drift_settings_repository.dart';
import '../../features/settings/domain/repositories/settings_repository.dart';
import '../../features/shifts/data/repositories/drift_shift_repository.dart';
import '../../features/shifts/domain/repositories/shift_repository.dart';

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

final shiftRepositoryProvider = Provider<ShiftRepository>(
  (ref) => DriftShiftRepository(
    ref.watch(appDatabaseProvider),
    ref.watch(clockProvider),
  ),
);

final habitRepositoryProvider = Provider<HabitRepository>(
  (ref) => DriftHabitRepository(ref.watch(appDatabaseProvider)),
);
