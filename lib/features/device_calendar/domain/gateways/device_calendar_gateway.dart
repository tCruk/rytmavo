import '../entities/calendar_event.dart';
import '../entities/device_calendar_info.dart';

/// Port to the device's calendars. Read-only by design: Rytmavo only looks
/// at events to warn about overlaps and never creates or changes any.
abstract interface class DeviceCalendarGateway {
  /// Whether read access is granted right now (never prompts).
  Future<bool> hasPermission();

  /// Asks the OS for calendar access (first time shows the system prompt).
  /// Returns whether access is granted afterwards.
  Future<bool> requestPermission();

  /// Opens the app's page in the system settings, for access denied earlier.
  Future<void> openSystemSettings();

  /// Calendars the user can pick. Empty without access.
  Future<List<DeviceCalendarInfo>> calendars();

  /// Event occurrences overlapping `[from, to)`. Empty [calendarIds] means
  /// all calendars. Empty without access.
  Future<List<CalendarEvent>> events({
    required DateTime from,
    required DateTime to,
    Set<String> calendarIds = const {},
  });
}

/// Gateway without calendars – for tests and unsupported platforms.
final class NoopDeviceCalendarGateway implements DeviceCalendarGateway {
  const NoopDeviceCalendarGateway();

  @override
  Future<bool> hasPermission() async => false;

  @override
  Future<bool> requestPermission() async => false;

  @override
  Future<void> openSystemSettings() async {}

  @override
  Future<List<DeviceCalendarInfo>> calendars() async => const [];

  @override
  Future<List<CalendarEvent>> events({
    required DateTime from,
    required DateTime to,
    Set<String> calendarIds = const {},
  }) async => const [];
}
