import '../../../../core/date/local_date.dart';
import '../../../../core/result/result.dart';
import '../entities/rotation_pattern.dart';
import '../entities/shift_override.dart';
import '../entities/shift_setup.dart';
import '../entities/shift_type.dart';

abstract interface class ShiftRepository {
  Future<ShiftSetup> load();

  /// Emits the current setup immediately and again after every change to
  /// shift types, rotations or overrides.
  Stream<ShiftSetup> watch();

  /// Inserts or updates the given shift types (matched by id).
  Future<Result<void>> saveShiftTypes(List<ShiftType> types);

  /// Stores a new rotation version. A version with the same `validFrom`
  /// replaces the existing one (editing twice on the same day); older
  /// versions are kept.
  ///
  /// With [replaceHistory] every existing version is removed first, so the
  /// new one also reinterprets the past (used to correct a wrong setup).
  Future<Result<void>> addRotationVersion(
    RotationPattern pattern, {
    bool replaceHistory = false,
  });

  Future<Result<void>> setOverride(ShiftOverride override);

  Future<Result<void>> removeOverride(LocalDate date);
}
