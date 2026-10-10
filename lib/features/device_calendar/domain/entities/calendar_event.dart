/// One occurrence of an event read from a device calendar.
///
/// Read-only snapshot: Rytmavo never writes to the device calendar.
final class CalendarEvent {
  const CalendarEvent({
    required this.id,
    required this.calendarId,
    required this.title,
    required this.start,
    required this.end,
    this.isAllDay = false,
  });

  /// Unique per occurrence (recurring events yield one id per instance).
  final String id;
  final String calendarId;
  final String title;

  /// Local wall-clock instants. For all-day events only the date matters.
  final DateTime start;
  final DateTime end;
  final bool isAllDay;

  @override
  bool operator ==(Object other) =>
      other is CalendarEvent &&
      other.id == id &&
      other.calendarId == calendarId &&
      other.title == title &&
      other.start == start &&
      other.end == end &&
      other.isAllDay == isAllDay;

  @override
  int get hashCode => Object.hash(id, calendarId, title, start, end, isAllDay);

  @override
  String toString() => 'CalendarEvent($title, $start – $end)';
}
