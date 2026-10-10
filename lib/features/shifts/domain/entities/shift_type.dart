import '../../../../core/date/local_time.dart';

/// Built-in shift categories. `custom` is any user-defined type.
///
/// The kind decides the default colour token and icon; it never changes the
/// scheduling logic.
enum ShiftKind { early, late, night, off, custom }

/// A kind of shift the user works (or a day off).
///
/// Built-in types use their [kind]'s name as id (`early`, `late`, `night`,
/// `off`). An empty [name] or [abbreviation] means "use the localized
/// default", so built-in types follow the app language.
final class ShiftType {
  const ShiftType({
    required this.id,
    required this.kind,
    required this.colorValue,
    required this.sortOrder,
    this.name = '',
    this.abbreviation = '',
    this.start,
    this.end,
    this.isArchived = false,
  });

  final String id;
  final ShiftKind kind;
  final String name;
  final String abbreviation;

  /// 32-bit ARGB colour; only used for [ShiftKind.custom]. Built-in kinds use
  /// the theme's shift colours so light and dark mode stay legible.
  final int colorValue;
  final LocalTime? start;
  final LocalTime? end;
  final int sortOrder;
  final bool isArchived;

  bool get isWorkShift => kind != ShiftKind.off;

  bool get hasTimes => start != null && end != null;

  /// True when the shift ends on the next calendar day (e.g. 22:00–06:00).
  /// Such a shift belongs to the day on which it starts.
  bool get crossesMidnight =>
      hasTimes && end!.minutesSinceMidnight <= start!.minutesSinceMidnight;

  /// Length in minutes, or `null` without times.
  int? get durationMinutes {
    if (!hasTimes) return null;
    final diff = end!.minutesSinceMidnight - start!.minutesSinceMidnight;
    return diff <= 0 ? diff + 24 * 60 : diff;
  }

  ShiftType copyWith({
    String? name,
    String? abbreviation,
    int? colorValue,
    LocalTime? start,
    LocalTime? end,
    bool clearTimes = false,
    int? sortOrder,
    bool? isArchived,
  }) {
    return ShiftType(
      id: id,
      kind: kind,
      name: name ?? this.name,
      abbreviation: abbreviation ?? this.abbreviation,
      colorValue: colorValue ?? this.colorValue,
      start: clearTimes ? null : start ?? this.start,
      end: clearTimes ? null : end ?? this.end,
      sortOrder: sortOrder ?? this.sortOrder,
      isArchived: isArchived ?? this.isArchived,
    );
  }

  /// Default built-in types with typical German three-shift times.
  static const List<ShiftType> defaults = [
    ShiftType(
      id: 'early',
      kind: ShiftKind.early,
      colorValue: 0xFF9A5E0B,
      sortOrder: 0,
      start: LocalTime(6, 0),
      end: LocalTime(14, 0),
    ),
    ShiftType(
      id: 'late',
      kind: ShiftKind.late,
      colorValue: 0xFFB4473C,
      sortOrder: 1,
      start: LocalTime(14, 0),
      end: LocalTime(22, 0),
    ),
    ShiftType(
      id: 'night',
      kind: ShiftKind.night,
      colorValue: 0xFF3B4A8C,
      sortOrder: 2,
      start: LocalTime(22, 0),
      end: LocalTime(6, 0),
    ),
    ShiftType(
      id: 'off',
      kind: ShiftKind.off,
      colorValue: 0xFF3F7D5A,
      sortOrder: 3,
    ),
  ];

  @override
  bool operator ==(Object other) =>
      other is ShiftType &&
      other.id == id &&
      other.kind == kind &&
      other.name == name &&
      other.abbreviation == abbreviation &&
      other.colorValue == colorValue &&
      other.start == start &&
      other.end == end &&
      other.sortOrder == sortOrder &&
      other.isArchived == isArchived;

  @override
  int get hashCode => Object.hash(
    id,
    kind,
    name,
    abbreviation,
    colorValue,
    start,
    end,
    sortOrder,
    isArchived,
  );

  @override
  String toString() => 'ShiftType($id)';
}
