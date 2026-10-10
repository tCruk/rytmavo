import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/l10n/generated/app_localizations.dart';
import '../../../../core/date/local_date.dart';
import '../../../../core/ui/components/components.dart';
import '../../../../core/ui/tokens/tokens.dart';
import '../calendar_conflict_providers.dart';
import 'shift_conflict_tile.dart';

/// Appointments that overlap a shift in the coming days. Renders nothing
/// when there are none (or the calendar check is off).
class UpcomingConflictsSection extends ConsumerWidget {
  const UpcomingConflictsSection({
    required this.from,
    this.days = 8,
    super.key,
  });

  final LocalDate from;
  final int days;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final conflicts = ref.watch(
      shiftConflictsProvider((from: from, days: days)),
    );
    if (conflicts.isEmpty) return const SizedBox.shrink();
    final colors = AppColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        RySectionHeader(l10n.conflictsTitle),
        RyCard(
          color: colors.warningContainer,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.xs,
          ),
          child: Column(
            children: [
              for (final c in conflicts)
                ShiftConflictTile(conflict: c, showDate: c.date != from),
            ],
          ),
        ),
      ],
    );
  }
}
