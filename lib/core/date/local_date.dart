/// A calendar date without time zone or time of day.
///
/// Rytmavo computes all shift and habit logic on local calendar dates.
/// Differences between dates are expressed in whole calendar days and are
/// calculated via UTC so that daylight-saving transitions never produce a
/// 23- or 25-hour "day".
final class LocalDate implements Comparable<LocalDate> {
  const LocalDate(this.year, this.month, this.day)
    : assert(month >= 1 && month <= 12, 'month out of range'),
      assert(day >= 1 && day <= 31, 'day out of range');

  /// Creates a [LocalDate] from the calendar fields of [dateTime],
  /// ignoring its time of day and time zone.
  factory LocalDate.fromDateTime(DateTime dateTime) =>
      LocalDate(dateTime.year, dateTime.month, dateTime.day);

  /// Parses an ISO-8601 calendar date (`YYYY-MM-DD`).
  ///
  /// Throws a [FormatException] for anything else, including dates that do
  /// not exist such as `2025-02-30`.
  factory LocalDate.parse(String text) {
    final match = _isoPattern.firstMatch(text);
    if (match == null) {
      throw FormatException('Invalid ISO date', text);
    }
    final year = int.parse(match.group(1)!);
    final month = int.parse(match.group(2)!);
    final day = int.parse(match.group(3)!);
    if (month < 1 || month > 12 || day < 1 || day > daysInMonth(year, month)) {
      throw FormatException('Date does not exist', text);
    }
    return LocalDate(year, month, day);
  }

  /// Returns `null` instead of throwing when [text] is not a valid date.
  static LocalDate? tryParse(String text) {
    try {
      return LocalDate.parse(text);
    } on FormatException {
      return null;
    }
  }

  static final RegExp _isoPattern = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$');

  final int year;
  final int month;
  final int day;

  /// ISO weekday: Monday = 1 … Sunday = 7.
  int get weekday => _asUtc.weekday;

  bool get isLeapYear => isLeap(year);

  LocalDate get firstDayOfMonth => LocalDate(year, month, 1);

  LocalDate get lastDayOfMonth =>
      LocalDate(year, month, daysInMonth(year, month));

  /// Number of days in the month of this date.
  int get lengthOfMonth => daysInMonth(year, month);

  /// Midnight of this date in UTC. Used purely for arithmetic.
  DateTime get _asUtc => DateTime.utc(year, month, day);

  /// Local midnight of this date in the device time zone.
  DateTime toLocalDateTime() => DateTime(year, month, day);

  LocalDate addDays(int days) {
    if (days == 0) return this;
    return LocalDate.fromDateTime(_asUtc.add(Duration(days: days)));
  }

  LocalDate addMonths(int months) {
    final totalMonths = year * 12 + (month - 1) + months;
    final newYear = totalMonths ~/ 12;
    final newMonth = totalMonths % 12 + 1;
    final newDay = day.clamp(1, daysInMonth(newYear, newMonth));
    return LocalDate(newYear, newMonth, newDay);
  }

  /// Whole calendar days from [other] to this date.
  ///
  /// Positive when this date is later than [other], negative when earlier.
  int daysSince(LocalDate other) => _asUtc.difference(other._asUtc).inDays;

  bool isBefore(LocalDate other) => compareTo(other) < 0;

  bool isAfter(LocalDate other) => compareTo(other) > 0;

  bool isSameMonth(LocalDate other) =>
      year == other.year && month == other.month;

  /// `YYYY-MM-DD`
  String toIsoString() =>
      '${year.toString().padLeft(4, '0')}-'
      '${month.toString().padLeft(2, '0')}-'
      '${day.toString().padLeft(2, '0')}';

  static bool isLeap(int year) =>
      (year % 4 == 0 && year % 100 != 0) || year % 400 == 0;

  static int daysInMonth(int year, int month) {
    const lengths = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    if (month == 2 && isLeap(year)) return 29;
    return lengths[month - 1];
  }

  @override
  int compareTo(LocalDate other) {
    if (year != other.year) return year.compareTo(other.year);
    if (month != other.month) return month.compareTo(other.month);
    return day.compareTo(other.day);
  }

  @override
  bool operator ==(Object other) =>
      other is LocalDate &&
      other.year == year &&
      other.month == month &&
      other.day == day;

  @override
  int get hashCode => Object.hash(year, month, day);

  @override
  String toString() => toIsoString();
}

/// Positive modulo: result is always in `0 ..< modulus`, also for negative
/// [value]. Dart's `%` already behaves this way for positive moduli, but the
/// intent is made explicit here because rotation lookups before the anchor
/// date depend on it.
int floorMod(int value, int modulus) {
  assert(modulus > 0, 'modulus must be positive');
  final r = value % modulus;
  return r < 0 ? r + modulus : r;
}
