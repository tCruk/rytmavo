import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/di/providers.dart';
import '../../../app/l10n/app_localizations_for.dart';
import '../../../app/l10n/generated/app_localizations.dart';
import '../../../core/date/local_date.dart';
import '../../../core/date/local_time.dart';
import '../../device_calendar/domain/services/shift_conflict_detector.dart';
import '../../device_calendar/presentation/calendar_conflict_providers.dart';
import '../../habits/presentation/controllers/habit_providers.dart';
import '../../settings/domain/entities/app_settings.dart';
import '../../settings/presentation/controllers/settings_controller.dart';
import '../../shifts/domain/entities/shift_setup.dart';
import '../../shifts/domain/entities/shift_type.dart';
import '../../shifts/presentation/controllers/shift_providers.dart';
import '../data/local_notification_gateway.dart';
import '../domain/entities/planned_reminder.dart';
import '../domain/gateways/notification_gateway.dart';
import '../domain/services/reminder_planner.dart';

final notificationGatewayProvider = Provider<NotificationGateway>(
  (ref) => LocalNotificationGateway(),
);

/// Keeps the OS's pending notifications in sync with the data. Re-plans
/// (debounced) whenever shifts, habits, completions or settings change,
/// and on demand via [sync] (app start, resume).
final reminderSchedulerProvider = Provider<ReminderScheduler>((ref) {
  final scheduler = ReminderScheduler(ref);
  ref.listen(shiftSetupProvider, (_, _) => scheduler.scheduleSync());
  ref.listen(habitPlanProvider, (_, _) => scheduler.scheduleSync());
  ref.listen(settingsControllerProvider, (_, _) => scheduler.scheduleSync());
  ref.onDispose(scheduler.dispose);
  return scheduler;
});

final class ReminderScheduler {
  ReminderScheduler(this._ref);

  final Ref _ref;
  Timer? _debounce;
  Future<void>? _running;
  bool _again = false;

  /// Coalesces bursts of changes into one sync.
  void scheduleSync() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), sync);
  }

  /// Plans the rolling window and hands it to the gateway. Concurrent calls
  /// are serialized; a call during a run triggers one more run afterwards.
  Future<void> sync() {
    if (_running != null) {
      _again = true;
      return _running!;
    }
    _running = _run().whenComplete(() {
      _running = null;
      if (_again) {
        _again = false;
        unawaited(sync());
      }
    });
    return _running!;
  }

  Future<void> _run() async {
    final gateway = _ref.read(notificationGatewayProvider);
    final settings = _ref.read(settingsControllerProvider).value;
    if (settings == null) return; // still loading; the listener re-syncs
    if (!settings.remindersEnabled) {
      await gateway.cancelAll();
      return;
    }
    final setup = _ref.read(shiftSetupProvider).value;
    final plan = _ref.read(habitPlanProvider).value;
    if (setup == null || plan == null) return; // still loading
    final now = _ref.read(clockProvider).now();
    final habitReminders = ReminderPlanner.plan(
      setup: setup,
      plan: plan,
      now: now,
    );
    final conflictWarnings =
        settings.calendarConflictsEnabled && settings.conflictRemindersEnabled
        ? await _conflictWarnings(setup, settings, now)
        : const <PlannedReminder>[];
    final reminders = ReminderPlanner.capped([
      ...habitReminders,
      ...conflictWarnings,
    ]);
    final l10n = appLocalizationsFor(settings.language);
    await gateway.replaceAll(reminders, (r) => _textFor(r, setup, l10n));
  }

  /// Reads the device calendar for the reminder window. A warning for day
  /// D fires on D-1, so the window starts tomorrow.
  Future<List<PlannedReminder>> _conflictWarnings(
    ShiftSetup setup,
    AppSettings settings,
    DateTime now,
  ) async {
    final calendar = _ref.read(deviceCalendarGatewayProvider);
    if (!await calendar.hasPermission()) return const [];
    final from = LocalDate.fromDateTime(now).addDays(1);
    const days = ReminderPlanner.windowDays;
    final range = ShiftConflictDetector.eventRange(from, days);
    final events = await calendar.events(
      from: range.start,
      to: range.end,
      calendarIds: settings.conflictCalendarIds.toSet(),
    );
    return ReminderPlanner.planConflicts(
      conflicts: ShiftConflictDetector.detect(
        setup: setup,
        events: events,
        from: from,
        days: days,
      ),
      now: now,
    );
  }

  static ReminderText _textFor(
    PlannedReminder r,
    ShiftSetup setup,
    AppLocalizations l10n,
  ) {
    if (r.isConflictWarning) {
      final first = r.conflicts.first;
      final shiftTime = l10n.shiftTimeRange(
        _hhmm(first.shiftStart),
        _hhmm(first.shiftEnd),
      );
      return (
        title: l10n.reminderConflictTitle(_shiftName(first.shift, l10n)),
        body: r.conflicts.length == 1
            ? l10n.reminderConflictBodyOne(
                first.event.title.trim().isEmpty
                    ? l10n.conflictUntitled
                    : first.event.title,
                l10n.shiftTimeRange(
                  _hhmm(first.event.start),
                  _hhmm(first.event.end),
                ),
                shiftTime,
              )
            : l10n.reminderConflictBodyMany(r.conflicts.length, shiftTime),
      );
    }
    final shift = r.shiftTypeId == null ? null : setup.typeById(r.shiftTypeId!);
    final shiftName = shift == null ? null : _shiftName(shift, l10n);
    return (
      title: r.habitName,
      body: shiftName == null
          ? l10n.reminderBodyPlain
          : l10n.reminderBodyWithShift(shiftName),
    );
  }

  /// Built-in shift names follow the app language, like the UI does.
  static String _shiftName(ShiftType shift, AppLocalizations l10n) {
    if (shift.name.isNotEmpty) return shift.name;
    return switch (shift.kind) {
      ShiftKind.early => l10n.shiftEarly,
      ShiftKind.late => l10n.shiftLate,
      ShiftKind.night => l10n.shiftNight,
      ShiftKind.off => l10n.shiftOff,
      ShiftKind.custom => shift.id,
    };
  }

  static String _hhmm(DateTime at) =>
      LocalTime(at.hour, at.minute).toIsoString();

  void dispose() {
    _debounce?.cancel();
  }
}
