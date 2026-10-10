/// A time of day without date or time zone, minute precision.
final class LocalTime implements Comparable<LocalTime> {
  const LocalTime(this.hour, this.minute)
    : assert(hour >= 0 && hour < 24, 'hour out of range'),
      assert(minute >= 0 && minute < 60, 'minute out of range');

  /// Builds a time from minutes since midnight (0 … 1439).
  factory LocalTime.fromMinutes(int minutesSinceMidnight) {
    final m = minutesSinceMidnight % (24 * 60);
    return LocalTime(m ~/ 60, m % 60);
  }

  /// Parses `HH:mm`.
  factory LocalTime.parse(String text) {
    final match = RegExp(r'^(\d{1,2}):(\d{2})$').firstMatch(text);
    if (match == null) throw FormatException('Invalid time', text);
    final hour = int.parse(match.group(1)!);
    final minute = int.parse(match.group(2)!);
    if (hour > 23 || minute > 59) throw FormatException('Invalid time', text);
    return LocalTime(hour, minute);
  }

  final int hour;
  final int minute;

  int get minutesSinceMidnight => hour * 60 + minute;

  /// `HH:mm`
  String toIsoString() =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

  @override
  int compareTo(LocalTime other) =>
      minutesSinceMidnight.compareTo(other.minutesSinceMidnight);

  @override
  bool operator ==(Object other) =>
      other is LocalTime && other.hour == hour && other.minute == minute;

  @override
  int get hashCode => Object.hash(hour, minute);

  @override
  String toString() => toIsoString();
}
