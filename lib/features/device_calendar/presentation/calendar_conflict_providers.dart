import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/date/local_date.dart';
import '../../settings/domain/entities/app_settings.dart';
import '../../settings/presentation/controllers/settings_controller.dart';
import '../../shifts/presentation/controllers/shift_providers.dart';
import '../data/plugin_device_calendar_gateway.dart';
import '../domain/entities/calendar_event.dart';
import '../domain/entities/device_calendar_info.dart';
import '../domain/entities/shift_conflict.dart';
import '../domain/gateways/device_calendar_gateway.dart';
import '../domain/services/shift_conflict_detector.dart';

final deviceCalendarGatewayProvider = Provider<DeviceCalendarGateway>(
  (ref) => PluginDeviceCalendarGateway(),
);

/// A span of calendar days: `[from, from + days)`.
typedef DaySpan = ({LocalDate from, int days});

/// Which calendars to read. `null` while the feature is off.
@immutable
final class ConflictCalendarSelection {
  const ConflictCalendarSelection(this.calendarIds);

  /// Empty means all calendars.
  final Set<String> calendarIds;

  @override
  bool operator ==(Object other) =>
      other is ConflictCalendarSelection &&
      setEquals(other.calendarIds, calendarIds);

  @override
  int get hashCode => Object.hashAllUnordered(calendarIds);
}

/// Narrow view on the settings so unrelated changes (theme, language) do
/// not re-read the device calendar.
final conflictCalendarSelectionProvider = Provider<ConflictCalendarSelection?>((
  ref,
) {
  final settings =
      ref.watch(settingsControllerProvider).value ?? AppSettings.defaults;
  if (!settings.calendarConflictsEnabled) return null;
  return ConflictCalendarSelection(settings.conflictCalendarIds.toSet());
});

/// Whether calendar access is granted. Re-checked on app resume (the user
/// may have changed it in the system settings).
final calendarPermissionProvider = FutureProvider<bool>(
  (ref) => ref.watch(deviceCalendarGatewayProvider).hasPermission(),
);

/// Calendars the user can choose from.
final deviceCalendarsProvider =
    FutureProvider.autoDispose<List<DeviceCalendarInfo>>((ref) async {
      if (!await ref.watch(calendarPermissionProvider.future)) return const [];
      return ref.watch(deviceCalendarGatewayProvider).calendars();
    });

/// Device events that can overlap shifts in [DaySpan]. Empty while the
/// feature is off or access is missing. Invalidated on app resume, because
/// the calendar changes outside the app.
final calendarEventsProvider = FutureProvider.autoDispose
    .family<List<CalendarEvent>, DaySpan>((ref, span) async {
      final selection = ref.watch(conflictCalendarSelectionProvider);
      if (selection == null) return const [];
      if (!await ref.watch(calendarPermissionProvider.future)) return const [];
      final range = ShiftConflictDetector.eventRange(span.from, span.days);
      return ref
          .watch(deviceCalendarGatewayProvider)
          .events(
            from: range.start,
            to: range.end,
            calendarIds: selection.calendarIds,
          );
    });

/// Conflicts between device events and shifts in [DaySpan]; empty while
/// anything is still loading.
final shiftConflictsProvider = Provider.autoDispose
    .family<List<ShiftConflict>, DaySpan>((ref, span) {
      final setup = ref.watch(shiftSetupProvider).value;
      final events = ref.watch(calendarEventsProvider(span)).value;
      if (setup == null || events == null || events.isEmpty) return const [];
      return ShiftConflictDetector.detect(
        setup: setup,
        events: events,
        from: span.from,
        days: span.days,
      );
    });

/// Re-reads permission and events, e.g. after the app comes back.
void refreshDeviceCalendar(WidgetRef ref) {
  ref
    ..invalidate(calendarPermissionProvider)
    ..invalidate(calendarEventsProvider);
}
