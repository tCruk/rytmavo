import 'package:flutter/material.dart';

import '../../../../app/l10n/generated/app_localizations.dart';
import '../../../../core/date/local_time.dart';
import '../../../../core/ui/tokens/tokens.dart';
import '../../../shifts/presentation/widgets/shift_visuals.dart';
import '../../domain/entities/shift_conflict.dart';

/// One conflicting appointment: title, its time and the shift it overlaps.
class ShiftConflictTile extends StatelessWidget {
  const ShiftConflictTile({
    required this.conflict,
    this.showDate = false,
    super.key,
  });

  final ShiftConflict conflict;

  /// Prefix the subtitle with the shift's date (for multi-day lists).
  final bool showDate;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colors = AppColors.of(context);
    final event = conflict.event;
    final time = l10n.shiftTimeRange(
      _time(context, event.start),
      _time(context, event.end),
    );
    final details = l10n.conflictDuringShift(
      time,
      conflict.shift.displayName(l10n),
    );
    final subtitle = showDate
        ? '${MaterialLocalizations.of(context).formatMediumDate(conflict.date.toLocalDateTime())} · $details'
        : details;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(Icons.event_busy_outlined, color: colors.warning),
      title: Text(
        event.title.trim().isEmpty ? l10n.conflictUntitled : event.title,
        style: theme.textTheme.titleSmall,
      ),
      subtitle: Text(subtitle),
    );
  }

  static String _time(BuildContext context, DateTime at) =>
      formatLocalTime(context, LocalTime(at.hour, at.minute));
}
