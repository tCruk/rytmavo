import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/providers.dart';
import '../../../../core/date/local_date.dart';
import '../../../holidays/presentation/holiday_providers.dart';
import '../../domain/entities/shift_setup.dart';

/// Shift configuration as stored (types, rotation versions, overrides).
final storedShiftSetupProvider = StreamProvider<ShiftSetup>(
  (ref) => ref.watch(shiftRepositoryProvider).watch(),
);

/// The effective schedule everyone reads: the stored setup plus public
/// holidays turned into days off when the user chose so.
final shiftSetupProvider = Provider<AsyncValue<ShiftSetup>>((ref) {
  final calendar = ref.watch(holidayCalendarProvider);
  return ref
      .watch(storedShiftSetupProvider)
      .whenData(
        (setup) => setup.withDaysOff(
          calendar.holidaysAreDaysOff ? calendar.isDayOff : null,
        ),
      );
});

/// The current local date according to the injected clock.
final todayProvider = Provider<LocalDate>(
  (ref) => ref.watch(clockProvider).today(),
);
