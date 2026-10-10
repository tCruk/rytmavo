import 'package:device_calendar_plus/device_calendar_plus.dart';
import 'package:flutter/foundation.dart';

import '../domain/entities/calendar_event.dart';
import '../domain/entities/device_calendar_info.dart';
import '../domain/gateways/device_calendar_gateway.dart';

/// `device_calendar_plus` implementation. Only reading methods of the
/// plugin are used. Every platform error degrades to "no access" or "no
/// events" so the rest of the app keeps working.
final class PluginDeviceCalendarGateway implements DeviceCalendarGateway {
  PluginDeviceCalendarGateway([DeviceCalendar? plugin])
    : _plugin = plugin ?? DeviceCalendar.instance;

  final DeviceCalendar _plugin;

  bool get _supported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  @override
  Future<bool> hasPermission() async {
    if (!_supported) return false;
    try {
      return await _plugin.hasPermissions() == CalendarPermissionStatus.granted;
    } on Object catch (e) {
      if (kDebugMode) debugPrint('calendar permission check failed: $e');
      return false;
    }
  }

  @override
  Future<bool> requestPermission() async {
    if (!_supported) return false;
    try {
      return await _plugin.requestPermissions() ==
          CalendarPermissionStatus.granted;
    } on Object catch (e) {
      if (kDebugMode) debugPrint('calendar permission request failed: $e');
      return false;
    }
  }

  @override
  Future<void> openSystemSettings() async {
    if (!_supported) return;
    try {
      await _plugin.openAppSettings();
    } on Object catch (e) {
      if (kDebugMode) debugPrint('open settings failed: $e');
    }
  }

  @override
  Future<List<DeviceCalendarInfo>> calendars() async {
    if (!await hasPermission()) return const [];
    try {
      final calendars = await _plugin.listCalendars();
      return [
        for (final c in calendars)
          if (!c.hidden)
            DeviceCalendarInfo(
              id: c.id,
              name: c.name,
              accountName: c.accountName,
              colorValue: c.color?.toARGB32(),
            ),
      ];
    } on Object catch (e) {
      if (kDebugMode) debugPrint('list calendars failed: $e');
      return const [];
    }
  }

  @override
  Future<List<CalendarEvent>> events({
    required DateTime from,
    required DateTime to,
    Set<String> calendarIds = const {},
  }) async {
    if (!to.isAfter(from) || !await hasPermission()) return const [];
    try {
      final events = await _plugin.listEvents(
        from,
        to,
        calendarIds: calendarIds.isEmpty ? null : calendarIds.toList(),
      );
      return [
        for (final e in events)
          if (e.status != EventStatus.canceled)
            CalendarEvent(
              id: e.instanceId,
              calendarId: e.calendarId,
              title: e.title,
              start: e.startDate,
              end: e.endDate,
              isAllDay: e.isAllDay,
            ),
      ];
    } on Object catch (e) {
      if (kDebugMode) debugPrint('list events failed: $e');
      return const [];
    }
  }
}
