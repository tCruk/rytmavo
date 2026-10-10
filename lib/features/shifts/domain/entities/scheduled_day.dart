import '../../../../core/date/local_date.dart';
import 'shift_type.dart';

/// Where a day's shift comes from.
enum ShiftSource {
  /// The rotation in effect on that day.
  rotation,

  /// A manual override.
  override,

  /// No rotation covers the day (before the first version, or not set up).
  none,
}

/// The resolved shift for one calendar day.
final class ScheduledDay {
  const ScheduledDay({
    required this.date,
    required this.source,
    this.shift,
    this.rotationShift,
  });

  final LocalDate date;

  /// Effective shift, `null` when [source] is [ShiftSource.none].
  final ShiftType? shift;
  final ShiftSource source;

  /// What the rotation alone would assign; differs from [shift] when the
  /// day is overridden. Lets the UI show "Night instead of Early".
  final ShiftType? rotationShift;

  bool get isOverridden => source == ShiftSource.override;

  @override
  bool operator ==(Object other) =>
      other is ScheduledDay &&
      other.date == date &&
      other.shift == shift &&
      other.source == source &&
      other.rotationShift == rotationShift;

  @override
  int get hashCode => Object.hash(date, shift, source, rotationShift);

  @override
  String toString() => 'ScheduledDay($date, ${shift?.id}, ${source.name})';
}
