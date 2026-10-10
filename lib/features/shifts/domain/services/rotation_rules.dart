import '../../../../core/date/local_date.dart';
import '../../../../core/result/failure.dart';

/// Validation and defaults for rotation versions. Pure functions only.
abstract final class RotationRules {
  /// Longest supported cycle. Covers every real-world system we know of
  /// (the longest common ones are 6 weeks) with a wide margin.
  static const int maxCycleLength = 84;

  /// `validFrom` of the very first rotation. It reaches into the past so the
  /// calendar can show earlier months right after onboarding.
  static const LocalDate firstVersionValidFrom = LocalDate(2000, 1, 1);

  /// Returns a [ValidationFailure] when [slots] cannot form a rotation, or
  /// `null` when it is valid.
  static ValidationFailure? validate(
    List<String> slots,
    Set<String> knownShiftTypeIds,
  ) {
    if (slots.isEmpty) {
      return const ValidationFailure('rotation is empty', field: 'slots');
    }
    if (slots.length > maxCycleLength) {
      return const ValidationFailure('rotation too long', field: 'slots');
    }
    for (final id in slots) {
      if (!knownShiftTypeIds.contains(id)) {
        return ValidationFailure('unknown shift type $id', field: 'slots');
      }
    }
    return null;
  }

  /// Anchor date such that [today] falls on cycle position [todayPosition].
  static LocalDate anchorFor({
    required LocalDate today,
    required int todayPosition,
  }) => today.addDays(-todayPosition);
}
