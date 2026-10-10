import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import '../domain/entities/planned_reminder.dart';
import '../domain/gateways/notification_gateway.dart';

/// `flutter_local_notifications` implementation.
///
/// Scheduling uses the absolute instant: the planner computes the local
/// [DateTime] with the device's own time-zone rules (DST included), and
/// that instant is handed over as a UTC [tz.TZDateTime]. No IANA zone
/// lookup is needed, so no extra plugin.
///
/// Android uses inexact alarms by design (no `SCHEDULE_EXACT_ALARM`
/// permission); a reminder may arrive a few minutes late in Doze.
final class LocalNotificationGateway implements NotificationGateway {
  LocalNotificationGateway([FlutterLocalNotificationsPlugin? plugin])
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;
  Future<bool>? _initialized;

  static const String _channelId = 'reminders';

  bool get _supported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  Future<bool> _ensureInitialized() {
    if (!_supported) return Future.value(false);
    return _initialized ??= _plugin
        .initialize(
          settings: const InitializationSettings(
            android: AndroidInitializationSettings('@mipmap/ic_launcher'),
            iOS: DarwinInitializationSettings(
              requestAlertPermission: false,
              requestBadgePermission: false,
              requestSoundPermission: false,
            ),
          ),
        )
        .then((ok) => ok ?? false)
        .catchError((Object e) {
          if (kDebugMode) debugPrint('notifications init failed: $e');
          return false;
        });
  }

  @override
  Future<bool> requestPermission() async {
    if (!await _ensureInitialized()) return false;
    try {
      switch (defaultTargetPlatform) {
        case TargetPlatform.android:
          final android = _plugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();
          return await android?.requestNotificationsPermission() ?? false;
        case TargetPlatform.iOS:
          final ios = _plugin
              .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin
              >();
          return await ios?.requestPermissions(alert: true, sound: true) ??
              false;
        default:
          return false;
      }
    } on Object catch (e) {
      if (kDebugMode) debugPrint('permission request failed: $e');
      return false;
    }
  }

  @override
  Future<bool> hasPermission() async {
    if (!await _ensureInitialized()) return false;
    try {
      switch (defaultTargetPlatform) {
        case TargetPlatform.android:
          final android = _plugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();
          return await android?.areNotificationsEnabled() ?? false;
        case TargetPlatform.iOS:
          final ios = _plugin
              .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin
              >();
          final options = await ios?.checkPermissions();
          return options?.isEnabled ?? false;
        default:
          return false;
      }
    } on Object {
      return false;
    }
  }

  @override
  Future<void> replaceAll(
    List<PlannedReminder> reminders,
    ReminderText Function(PlannedReminder reminder) textFor,
  ) async {
    if (!await _ensureInitialized()) return;
    await _plugin.cancelAllPendingNotifications();
    for (final r in reminders) {
      final text = textFor(r);
      try {
        await _plugin.zonedSchedule(
          id: r.id,
          title: text.title,
          body: text.body,
          scheduledDate: tz.TZDateTime.from(r.at, tz.UTC),
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          notificationDetails: const NotificationDetails(
            android: AndroidNotificationDetails(
              _channelId,
              'Reminders',
              channelDescription: 'Habit reminders',
              importance: Importance.high,
              priority: Priority.high,
              category: AndroidNotificationCategory.reminder,
            ),
            iOS: DarwinNotificationDetails(
              interruptionLevel: InterruptionLevel.timeSensitive,
            ),
          ),
          payload: r.habitId,
        );
      } on Object catch (e) {
        if (kDebugMode) debugPrint('schedule ${r.id} failed: $e');
      }
    }
  }

  @override
  Future<void> cancelAll() async {
    if (!await _ensureInitialized()) return;
    await _plugin.cancelAll();
  }
}
