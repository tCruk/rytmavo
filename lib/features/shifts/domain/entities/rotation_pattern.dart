import '../../../../core/date/local_date.dart';

/// One version of the user's repeating shift rotation.
///
/// `slots[0]` applies on [anchorDate]; the sequence repeats every
/// `slots.length` days in both directions. The version is in effect from
/// [validFrom] (inclusive) until the next version's `validFrom`.
final class RotationPattern {
  RotationPattern({
    required this.id,
    required this.validFrom,
    required this.anchorDate,
    required List<String> slots,
  }) : assert(slots.isNotEmpty, 'a rotation needs at least one slot'),
       slots = List.unmodifiable(slots);

  final String id;
  final LocalDate validFrom;
  final LocalDate anchorDate;

  /// Shift type ids, one per day of the cycle.
  final List<String> slots;

  int get cycleLength => slots.length;

  /// Position of [date] within the cycle (0-based), also before the anchor.
  int positionOf(LocalDate date) =>
      floorMod(date.daysSince(anchorDate), cycleLength);

  /// Shift type id the rotation assigns to [date].
  String shiftIdOn(LocalDate date) => slots[positionOf(date)];

  @override
  bool operator ==(Object other) =>
      other is RotationPattern &&
      other.id == id &&
      other.validFrom == validFrom &&
      other.anchorDate == anchorDate &&
      _listEquals(other.slots, slots);

  @override
  int get hashCode =>
      Object.hash(id, validFrom, anchorDate, Object.hashAll(slots));

  @override
  String toString() =>
      'RotationPattern($id, from $validFrom, anchor $anchorDate, $slots)';
}

bool _listEquals(List<String> a, List<String> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
