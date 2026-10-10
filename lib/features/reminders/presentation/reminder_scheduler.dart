import 'dart:async';
import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/di/providers.dart';
import '../../../app/l10n/generated/app_localizations.dart';
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
    final reminders = ReminderPlanner.plan(
      setup: setup,
      plan: plan,
      now: _ref.read(clockProvider).now(),
    );
    final l10n = _localizations(settings.language);
    await gateway.replaceAll(reminders, (r) => _textFor(r, setup, l10n));
  }

  static ReminderText _textFor(
    PlannedReminder r,
    ShiftSetup setup,
    AppLocalizations l10n,
  ) {
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

  static AppLocalizations _localizations(AppLanguage language) {
    final locale = switch (language) {
      AppLanguage.de => const Locale('de'),
      AppLanguage.en => const Locale('en'),
      AppLanguage.system => PlatformDispatcher.instance.locale,
    };
    final supported = AppLocalizations.supportedLocales.any(
      (l) => l.languageCode == locale.languageCode,
    );
    return lookupAppLocalizations(
      supported ? Locale(locale.languageCode) : const Locale('de'),
    );
  }

  void dispose() {
    _debounce?.cancel();
  }
}
