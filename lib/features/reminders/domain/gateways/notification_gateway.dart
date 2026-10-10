import '../entities/planned_reminder.dart';

/// Localized text for one reminder, produced by the presentation layer.
typedef ReminderText = ({String title, String body});

/// Port to the platform's local notifications. Implemented with
/// `flutter_local_notifications` in production and faked in tests.
abstract interface class NotificationGateway {
  /// Asks the OS for permission (first time shows the system prompt).
  /// Returns whether notifications are allowed afterwards.
  Future<bool> requestPermission();

  Future<bool> hasPermission();

  /// Replaces every pending notification with [reminders].
  Future<void> replaceAll(
    List<PlannedReminder> reminders,
    ReminderText Function(PlannedReminder reminder) textFor,
  );

  Future<void> cancelAll();
}

/// Gateway that does nothing – for tests and unsupported platforms.
final class NoopNotificationGateway implements NotificationGateway {
  const NoopNotificationGateway({this.permission = true});

  final bool permission;

  @override
  Future<bool> requestPermission() async => permission;

  @override
  Future<bool> hasPermission() async => permission;

  @override
  Future<void> replaceAll(
    List<PlannedReminder> reminders,
    ReminderText Function(PlannedReminder reminder) textFor,
  ) async {}

  @override
  Future<void> cancelAll() async {}
}
