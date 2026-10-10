import '../../../../core/date/local_date.dart';

/// Statutory public holidays in Germany (state level). Names are
/// localized in the presentation layer.
enum PublicHolidayKind {
  newYear,
  epiphany,
  womensDay,
  goodFriday,
  easterSunday,
  easterMonday,
  labourDay,
  liberationDay,
  ascension,
  whitSunday,
  whitMonday,
  corpusChristi,
  assumption,
  childrensDay,
  germanUnity,
  reformation,
  allSaints,
  repentance,
  christmas,
  boxingDay,
}

/// A statutory public holiday on [date].
final class PublicHoliday {
  const PublicHoliday({
    required this.date,
    required this.kind,
    required this.nationwide,
  });

  final LocalDate date;
  final PublicHolidayKind kind;

  /// True for the nine holidays that apply in every German state.
  final bool nationwide;

  @override
  bool operator ==(Object other) =>
      other is PublicHoliday &&
      other.date == date &&
      other.kind == kind &&
      other.nationwide == nationwide;

  @override
  int get hashCode => Object.hash(date, kind, nationwide);

  @override
  String toString() => 'PublicHoliday($date, ${kind.name})';
}
