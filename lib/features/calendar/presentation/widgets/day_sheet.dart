import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/providers.dart';
import '../../../../app/l10n/generated/app_localizations.dart';
import '../../../../core/date/local_date.dart';
import '../../../../core/ui/components/components.dart';
import '../../../../core/ui/tokens/tokens.dart';
import '../../../shifts/domain/entities/shift_override.dart';
import '../../../shifts/domain/entities/shift_setup.dart';
import '../../../shifts/presentation/widgets/shift_visuals.dart';

enum DaySheetOutcome { changed, restored, failed }

/// Bottom sheet for one day: shows the rhythm's shift and lets the user
/// pick another shift for that day or restore the rhythm.
Future<DaySheetOutcome?> showDaySheet(
  BuildContext context, {
  required ShiftSetup setup,
  required LocalDate date,
}) {
  return showModalBottomSheet<DaySheetOutcome>(
    context: context,
    // The calendar lives in a shell branch navigator; the sheet must cover
    // the bottom navigation bar and the shell's snackbars.
    useRootNavigator: true,
    showDragHandle: true,
    shape: const RoundedRectangleBorder(borderRadius: AppRadius.sheetTop),
    builder: (context) => _DaySheet(setup: setup, date: date),
  );
}

class _DaySheet extends ConsumerWidget {
  const _DaySheet({required this.setup, required this.date});

  final ShiftSetup setup;
  final LocalDate date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final day = setup.dayOn(date);
    final repo = ref.read(shiftRepositoryProvider);
    final navigator = Navigator.of(context);

    Future<void> choose(String shiftTypeId) async {
      if (shiftTypeId == day.shift?.id) {
        navigator.pop();
        return;
      }
      final result = day.rotationShift?.id == shiftTypeId
          ? await repo.removeOverride(date)
          : await repo.setOverride(
              ShiftOverride(date: date, shiftTypeId: shiftTypeId),
            );
      navigator.pop(
        result.isFailure
            ? DaySheetOutcome.failed
            : day.rotationShift?.id == shiftTypeId
            ? DaySheetOutcome.restored
            : DaySheetOutcome.changed,
      );
    }

    Future<void> restore() async {
      final result = await repo.removeOverride(date);
      navigator.pop(
        result.isFailure ? DaySheetOutcome.failed : DaySheetOutcome.restored,
      );
    }

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              MaterialLocalizations.of(context)
                  .formatFullDate(date.toLocalDateTime()),
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              l10n.daySheetRotation(
                day.rotationShift?.displayName(l10n) ?? l10n.todayNoEntry,
              ),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            RySectionHeader(l10n.daySheetChange),
            RadioGroup<String>(
              groupValue: day.shift?.id,
              onChanged: (id) {
                if (id != null) choose(id);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final type in setup.activeTypes)
                    RadioListTile<String>(
                      value: type.id,
                      contentPadding: EdgeInsets.zero,
                      secondary: ShiftBadge(shift: type),
                      title: Text(type.displayName(l10n)),
                      subtitle: type.timeRange(context) == null
                          ? null
                          : Text(type.timeRange(context)!),
                    ),
                ],
              ),
            ),
            if (day.isOverridden) ...[
              const SizedBox(height: AppSpacing.md),
              RyButton.secondary(
                label: l10n.daySheetReset,
                icon: Icons.restore,
                expand: true,
                onPressed: restore,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
