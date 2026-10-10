import '../../../../core/date/local_date.dart';
import '../../../../core/date/local_time.dart';
import '../../../shifts/domain/entities/shift_type.dart';

/// One day as the watch shows it. Names are already localized on the phone,
/// so the watch needs no knowledge of shift kinds or app language.
final class WatchDay {
  const WatchDay({
    required this.date,
    this.kind,
    this.name = '',
    this.abbreviation = '',
    this.colorValue,
    this.start,
    this.end,
    this.isOverride = false,
  });

  final LocalDate date;

  /// `null` when no rotation covers the day.
  final ShiftKind? kind;
  final String name;
  final String abbreviation;
  final int? colorValue;
  final LocalTime? start;
  final LocalTime? end;
  final bool isOverride;

  bool get hasShift => kind != null;

  Map<String, Object?> toJson() => {
    'date': date.toIsoString(),
    'kind': kind?.name ?? 'none',
    if (hasShift) ...{
      'name': name,
      'abbr': abbreviation,
      'color': colorValue,
      'start': start?.toIsoString(),
      'end': end?.toIsoString(),
      'override': isOverride,
    },
  };

  @override
  bool operator ==(Object other) =>
      other is WatchDay &&
      other.date == date &&
      other.kind == kind &&
      other.name == name &&
      other.abbreviation == abbreviation &&
      other.colorValue == colorValue &&
      other.start == start &&
      other.end == end &&
      other.isOverride == isOverride;

  @override
  int get hashCode => Object.hash(
    date,
    kind,
    name,
    abbreviation,
    colorValue,
    start,
    end,
    isOverride,
  );
}

/// What the phone hands to a paired watch: a dated list of upcoming days.
///
/// The watch picks "today" from [days] by its own clock, so the display and
/// complications stay correct for the whole window even when the phone app
/// is not opened.
final class WatchSnapshot {
  WatchSnapshot({required List<WatchDay> days})
    : days = List.unmodifiable(days);

  /// Bumped when the JSON shape changes incompatibly.
  static const int formatVersion = 1;

  final List<WatchDay> days;

  Map<String, Object?> toJson() => {
    'v': formatVersion,
    'days': [for (final d in days) d.toJson()],
  };
}
