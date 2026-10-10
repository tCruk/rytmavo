import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/providers.dart';
import '../../../../core/date/local_date.dart';
import '../../domain/entities/shift_setup.dart';

/// Live shift configuration (types, rotation versions, overrides).
final shiftSetupProvider = StreamProvider<ShiftSetup>(
  (ref) => ref.watch(shiftRepositoryProvider).watch(),
);

/// The current local date according to the injected clock.
final todayProvider = Provider<LocalDate>(
  (ref) => ref.watch(clockProvider).today(),
);
