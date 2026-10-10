import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/l10n/generated/app_localizations.dart';
import '../../../../core/ui/components/components.dart';
import '../../../../core/ui/tokens/tokens.dart';
import '../../../settings/domain/entities/app_settings.dart';
import '../../../settings/presentation/controllers/settings_controller.dart';
import '../../domain/entities/device_calendar_info.dart';
import '../calendar_conflict_providers.dart';

/// Settings for the device calendar check: on/off (asks for calendar
/// access when turned on), which calendars, and the evening reminder.
class CalendarConflictSettingsCard extends ConsumerStatefulWidget {
  const CalendarConflictSettingsCard({super.key});

  @override
  ConsumerState<CalendarConflictSettingsCard> createState() =>
      _CalendarConflictSettingsCardState();
}

class _CalendarConflictSettingsCardState
    extends ConsumerState<CalendarConflictSettingsCard> {
  bool _busy = false;

  Future<void> _toggle(bool enable) async {
    final controller = ref.read(settingsControllerProvider.notifier);
    if (!enable) {
      await controller.setCalendarConflictsEnabled(enabled: false);
      return;
    }
    setState(() => _busy = true);
    final granted = await ref
        .read(deviceCalendarGatewayProvider)
        .requestPermission();
    ref.invalidate(calendarPermissionProvider);
    if (!mounted) return;
    setState(() => _busy = false);
    if (granted) {
      await controller.setCalendarConflictsEnabled(enabled: true);
    } else {
      showRySnackBar(context, AppLocalizations.of(context).calendarSyncDenied);
    }
  }

  Future<void> _pickCalendars(List<String> selected) async {
    final picked = await showModalBottomSheet<List<String>>(
      context: context,
      useRootNavigator: true,
      showDragHandle: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.sheetTop),
      builder: (context) => _CalendarPicker(selected: selected),
    );
    if (picked == null) return;
    await ref
        .read(settingsControllerProvider.notifier)
        .setConflictCalendarIds(picked);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final settings =
        ref.watch(settingsControllerProvider).value ?? AppSettings.defaults;
    final controller = ref.read(settingsControllerProvider.notifier);
    final enabled = settings.calendarConflictsEnabled;
    // Access can be revoked in the system settings while the switch is on.
    final missingAccess =
        enabled && ref.watch(calendarPermissionProvider).value == false;
    final calendars = enabled ? ref.watch(deviceCalendarsProvider).value : null;

    final String calendarsSubtitle;
    if (settings.conflictCalendarIds.isEmpty || calendars == null) {
      calendarsSubtitle = l10n.calendarSyncAllCalendars;
    } else {
      final known = calendars.map((c) => c.id).toSet();
      calendarsSubtitle = l10n.calendarSyncSomeCalendars(
        settings.conflictCalendarIds.where(known.contains).length,
        calendars.length,
      );
    }

    return RyCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          SwitchListTile(
            secondary: const Icon(Icons.event_available_outlined),
            title: Text(l10n.calendarSyncToggle),
            subtitle: Text(
              missingAccess
                  ? l10n.calendarSyncDenied
                  : enabled
                  ? l10n.calendarSyncOn
                  : l10n.calendarSyncOff,
              style: missingAccess
                  ? theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.error,
                    )
                  : null,
            ),
            value: enabled,
            onChanged: _busy ? null : _toggle,
          ),
          if (missingAccess)
            ListTile(
              leading: const Icon(Icons.open_in_new),
              title: Text(l10n.calendarSyncOpenSettings),
              onTap: () =>
                  ref.read(deviceCalendarGatewayProvider).openSystemSettings(),
            ),
          if (enabled && !missingAccess) ...[
            ListTile(
              leading: const Icon(Icons.calendar_month_outlined),
              title: Text(l10n.calendarSyncCalendars),
              subtitle: Text(calendarsSubtitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _pickCalendars(settings.conflictCalendarIds),
            ),
            SwitchListTile(
              secondary: const Icon(Icons.notifications_active_outlined),
              title: Text(l10n.calendarSyncReminder),
              subtitle: Text(
                settings.remindersEnabled
                    ? l10n.calendarSyncReminderOn
                    : l10n.calendarSyncReminderNeedsReminders,
              ),
              value:
                  settings.remindersEnabled &&
                  settings.conflictRemindersEnabled,
              onChanged: settings.remindersEnabled
                  ? (v) => controller.setConflictRemindersEnabled(enabled: v)
                  : null,
            ),
          ],
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              0,
              AppSpacing.lg,
              AppSpacing.md,
            ),
            child: Text(
              l10n.calendarSyncHint,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Multi-select of device calendars. Returns the chosen ids, or an empty
/// list when all are chosen ("all calendars", also future ones).
class _CalendarPicker extends ConsumerStatefulWidget {
  const _CalendarPicker({required this.selected});

  final List<String> selected;

  @override
  ConsumerState<_CalendarPicker> createState() => _CalendarPickerState();
}

class _CalendarPickerState extends ConsumerState<_CalendarPicker> {
  Set<String>? _chosen;

  Set<String> _initial(List<DeviceCalendarInfo> calendars) {
    final known = calendars.map((c) => c.id).toSet();
    final picked = widget.selected.where(known.contains).toSet();
    return picked.isEmpty ? known : picked;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final calendarsAsync = ref.watch(deviceCalendarsProvider);
    final calendars = calendarsAsync.value;
    final chosen = calendars == null
        ? <String>{}
        : _chosen ??= _initial(calendars);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.page,
          0,
          AppSpacing.page,
          AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.calendarSyncPickTitle, style: theme.textTheme.titleLarge),
            const SizedBox(height: AppSpacing.sm),
            if (calendars == null)
              const Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (calendars.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                child: Text(l10n.calendarSyncNoCalendars),
              )
            else
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (final c in calendars)
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        value: chosen.contains(c.id),
                        secondary: Icon(
                          Icons.circle,
                          size: 16,
                          color: c.colorValue == null
                              ? theme.colorScheme.outline
                              : Color(c.colorValue!),
                        ),
                        title: Text(c.name),
                        subtitle: c.accountName == null
                            ? null
                            : Text(c.accountName!),
                        onChanged: (v) => setState(() {
                          v == true ? chosen.add(c.id) : chosen.remove(c.id);
                        }),
                      ),
                  ],
                ),
              ),
            const SizedBox(height: AppSpacing.md),
            RyButton(
              label: l10n.calendarSyncPickApply,
              expand: true,
              onPressed: calendars == null || chosen.isEmpty
                  ? null
                  : () => Navigator.of(context).pop(
                      chosen.length == calendars.length
                          ? const <String>[]
                          : (chosen.toList()..sort()),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
