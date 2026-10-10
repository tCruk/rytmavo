import '../../../../core/date/local_date.dart';

/// A manual change for a single day (swap, extra shift, vacation …).
/// Always wins over the rotation.
final class ShiftOverride {
  const ShiftOverride({required this.date, required this.shiftTypeId});

  final LocalDate date;
  final String shiftTypeId;

  @override
  bool operator ==(Object other) =>
      other is ShiftOverride &&
      other.date == date &&
      other.shiftTypeId == shiftTypeId;

  @override
  int get hashCode => Object.hash(date, shiftTypeId);
}
