import '../../../../core/date/local_date.dart';
import 'rotation_pattern.dart';
import 'scheduled_day.dart';
import 'shift_override.dart';
import 'shift_type.dart';

/// Everything needed to answer "which shift is on day X?" – a pure,
/// immutable snapshot of the user's shift configuration.
final class ShiftSetup {
  ShiftSetup({
    required List<ShiftType> types,
    required List<RotationPattern> patterns,
    required List<ShiftOverride> overrides,
  }) : types = List.unmodifiable(
         <ShiftType>[...types]
           ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder)),
       ),
       patterns = List.unmodifiable(
         <RotationPattern>[...patterns]
           ..sort((a, b) => a.validFrom.compareTo(b.validFrom)),
       ),
       _typesById = {for (final t in types) t.id: t},
       _overrides = {for (final o in overrides) o.date: o.shiftTypeId};

  static final ShiftSetup empty = ShiftSetup(
    types: const [],
    patterns: const [],
    overrides: const [],
  );

  /// All shift types, ordered by `sortOrder` (archived ones included so that
  /// history stays resolvable).
  final List<ShiftType> types;

  /// Rotation versions, oldest first.
  final List<RotationPattern> patterns;

  final Map<String, ShiftType> _typesById;
  final Map<LocalDate, String> _overrides;

  bool get hasRotation => patterns.isNotEmpty;

  /// Types the user can pick for new entries.
  List<ShiftType> get activeTypes =>
      types.where((t) => !t.isArchived).toList(growable: false);

  ShiftType? typeById(String id) => _typesById[id];

  /// Number of overridden days (for diagnostics and export).
  int get overrideCount => _overrides.length;

  /// The rotation version in effect on [date]: greatest `validFrom <= date`.
  RotationPattern? patternOn(LocalDate date) {
    RotationPattern? result;
    for (final p in patterns) {
      if (p.validFrom.isAfter(date)) break;
      result = p;
    }
    return result;
  }

  /// The most recent rotation version (what the user edits).
  RotationPattern? get currentPattern =>
      patterns.isEmpty ? null : patterns.last;

  /// Resolves the shift for [date]: override > rotation > none.
  ScheduledDay dayOn(LocalDate date) {
    final pattern = patternOn(date);
    final rotationShift = pattern == null
        ? null
        : _typesById[pattern.shiftIdOn(date)];
    final overrideId = _overrides[date];
    if (overrideId != null) {
      final overrideShift = _typesById[overrideId];
      if (overrideShift != null) {
        return ScheduledDay(
          date: date,
          shift: overrideShift,
          source: ShiftSource.override,
          rotationShift: rotationShift,
        );
      }
    }
    if (rotationShift != null) {
      return ScheduledDay(
        date: date,
        shift: rotationShift,
        source: ShiftSource.rotation,
        rotationShift: rotationShift,
      );
    }
    return ScheduledDay(date: date, source: ShiftSource.none);
  }

  /// [count] consecutive days starting at [from].
  List<ScheduledDay> daysFrom(LocalDate from, int count) => [
    for (var i = 0; i < count; i++) dayOn(from.addDays(i)),
  ];

  /// First day after [from] (exclusive) whose shift is a work shift, within
  /// [maxDays]. Used for "next shift" hints.
  ScheduledDay? nextWorkDayAfter(LocalDate from, {int maxDays = 60}) {
    for (var i = 1; i <= maxDays; i++) {
      final day = dayOn(from.addDays(i));
      if (day.shift?.isWorkShift ?? false) return day;
    }
    return null;
  }
}
