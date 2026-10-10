import '../../../../core/date/local_date.dart';

/// Kind of a school holiday period; names are localized in the UI.
enum SchoolHolidayKind {
  winter,
  midYear,
  carnival,
  spring,
  easter,
  whitsun,
  summer,
  autumn,
  christmas,

  /// A single free day or bridge day (e.g. the Friday after Ascension).
  dayOff,
}

/// School holidays of one state: `[start, end]`, both inclusive.
final class SchoolHolidayPeriod {
  const SchoolHolidayPeriod(this.start, this.end, this.kind);

  final LocalDate start;
  final LocalDate end;
  final SchoolHolidayKind kind;

  bool contains(LocalDate date) => !date.isBefore(start) && !date.isAfter(end);

  @override
  bool operator ==(Object other) =>
      other is SchoolHolidayPeriod &&
      other.start == start &&
      other.end == end &&
      other.kind == kind;

  @override
  int get hashCode => Object.hash(start, end, kind);

  @override
  String toString() => 'SchoolHolidayPeriod($start–$end, ${kind.name})';
}
