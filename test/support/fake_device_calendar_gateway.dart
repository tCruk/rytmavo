import 'package:rytmavo/features/device_calendar/domain/entities/calendar_event.dart';
import 'package:rytmavo/features/device_calendar/domain/entities/device_calendar_info.dart';
import 'package:rytmavo/features/device_calendar/domain/gateways/device_calendar_gateway.dart';

/// Scriptable device calendar for widget tests.
final class FakeDeviceCalendarGateway implements DeviceCalendarGateway {
  FakeDeviceCalendarGateway({
    this.granted = false,
    this.grantOnRequest = true,
    this.calendarList = const [],
    this.eventList = const [],
  });

  bool granted;
  bool grantOnRequest;
  List<DeviceCalendarInfo> calendarList;
  List<CalendarEvent> eventList;
  int requestCalls = 0;
  final List<Set<String>> queriedCalendarIds = [];

  @override
  Future<bool> hasPermission() async => granted;

  @override
  Future<bool> requestPermission() async {
    requestCalls++;
    if (grantOnRequest) granted = true;
    return granted;
  }

  @override
  Future<void> openSystemSettings() async {}

  @override
  Future<List<DeviceCalendarInfo>> calendars() async =>
      granted ? calendarList : const [];

  @override
  Future<List<CalendarEvent>> events({
    required DateTime from,
    required DateTime to,
    Set<String> calendarIds = const {},
  }) async {
    if (!granted) return const [];
    queriedCalendarIds.add(calendarIds);
    return [
      for (final e in eventList)
        if (e.start.isBefore(to) &&
            e.end.isAfter(from) &&
            (calendarIds.isEmpty || calendarIds.contains(e.calendarId)))
          e,
    ];
  }
}
