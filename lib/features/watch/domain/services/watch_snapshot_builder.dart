import '../../../../core/date/local_date.dart';
import '../../../shifts/domain/entities/scheduled_day.dart';
import '../../../shifts/domain/entities/shift_setup.dart';
import '../../../shifts/domain/entities/shift_type.dart';
import '../entities/watch_snapshot.dart';

/// Builds the watch snapshot from the shift setup.
abstract final class WatchSnapshotBuilder {
  /// Two weeks keep the watch useful while the phone app stays closed.
  static const int windowDays = 14;

  /// Days from [today] (inclusive) for [windowDays]. [nameOf] and
  /// [abbreviationOf] resolve localized labels, keeping this layer free of
  /// Flutter and l10n.
  static WatchSnapshot build({
    required ShiftSetup setup,
    required LocalDate today,
    required String Function(ShiftType shift) nameOf,
    required String Function(ShiftType shift) abbreviationOf,
  }) {
    return WatchSnapshot(
      days: [
        for (final day in setup.daysFrom(today, windowDays))
          _toWatchDay(day, nameOf, abbreviationOf),
      ],
    );
  }

  static WatchDay _toWatchDay(
    ScheduledDay day,
    String Function(ShiftType shift) nameOf,
    String Function(ShiftType shift) abbreviationOf,
  ) {
    final shift = day.shift;
    if (shift == null) return WatchDay(date: day.date);
    return WatchDay(
      date: day.date,
      kind: shift.kind,
      name: nameOf(shift),
      abbreviation: abbreviationOf(shift),
      colorValue: shift.colorValue,
      start: shift.start,
      end: shift.end,
      isOverride: day.isOverridden,
    );
  }
}
