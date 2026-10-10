import 'package:flutter/material.dart';

import '../../../../app/l10n/generated/app_localizations.dart';
import '../../../../core/date/local_time.dart';
import '../../../../core/ui/tokens/tokens.dart';
import '../../../shifts/presentation/widgets/shift_visuals.dart';
import '../../domain/entities/calendar_event.dart';
import '../../domain/entities/shift_conflict.dart';

/// One device calendar appointment in the day sheet. With a [conflict] it
/// carries the warning icon and names the overlapping shift.
class CalendarEventTile extends StatelessWidget {
  const CalendarEventTile({required this.event, this.conflict, super.key});

  final CalendarEvent event;
  final ShiftConflict? conflict;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colors = AppColors.of(context);
    final time = event.isAllDay
        ? l10n.eventAllDay
        : l10n.shiftTimeRange(
            _time(context, event.start),
            _time(context, event.end),
          );
    final conflict = this.conflict;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        conflict == null ? Icons.event_outlined : Icons.event_busy_outlined,
        color: conflict == null
            ? theme.colorScheme.onSurfaceVariant
            : colors.warning,
      ),
      title: Text(
        event.title.trim().isEmpty ? l10n.conflictUntitled : event.title,
        style: theme.textTheme.titleSmall,
      ),
      subtitle: Text(
        conflict == null
            ? time
            : l10n.conflictDuringShift(time, conflict.shift.displayName(l10n)),
      ),
    );
  }

  static String _time(BuildContext context, DateTime at) =>
      formatLocalTime(context, LocalTime(at.hour, at.minute));
}
