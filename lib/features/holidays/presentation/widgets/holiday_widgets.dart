import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/l10n/generated/app_localizations.dart';
import '../../../../app/router/app_routes.dart';
import '../../../../core/ui/components/components.dart';
import '../../../../core/ui/tokens/tokens.dart';
import '../../../settings/domain/entities/app_settings.dart';
import '../../../settings/presentation/controllers/settings_controller.dart';
import '../holiday_labels.dart';

/// Calendar card that asks once which holidays to mark.
class HolidaySetupPrompt extends ConsumerWidget {
  const HolidaySetupPrompt({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsControllerProvider).value;
    // Hidden while loading, so it never flashes for users who answered.
    if (settings == null || settings.holidaySetupDone) {
      return const SizedBox.shrink();
    }
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: RyCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.celebration_outlined,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    l10n.holidaysPromptTitle,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(l10n.holidaysPromptBody, style: theme.textTheme.bodyMedium),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                RyButton(
                  label: l10n.holidaysPromptAction,
                  icon: Icons.place_outlined,
                  onPressed: () => context.push(AppRoutes.settingsHolidays),
                ),
                RyButton.tertiary(
                  label: l10n.holidaysPromptDismiss,
                  onPressed: () => ref
                      .read(settingsControllerProvider.notifier)
                      .dismissHolidaySetup(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Settings row that opens the holiday questions.
class HolidaySettingsTile extends ConsumerWidget {
  const HolidaySettingsTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settings =
        ref.watch(settingsControllerProvider).value ?? AppSettings.defaults;
    final summary = [
      settings.holidayState?.displayName(l10n) ?? l10n.holidaysNationwideOnly,
      if (settings.showSchoolHolidays) l10n.calendarSchoolHoliday,
      if (settings.holidaysAreDaysOff) l10n.holidaysDaysOffToggle,
    ].join(' · ');
    return RyCard(
      padding: EdgeInsets.zero,
      child: ListTile(
        leading: const Icon(Icons.celebration_outlined),
        title: Text(l10n.holidaysTitle),
        subtitle: Text(summary),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.push(AppRoutes.settingsHolidays),
      ),
    );
  }
}

/// Legend sample for public holidays: a ringed day number.
class HolidayLegendItem extends StatelessWidget {
  const HolidayLegendItem({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colors = AppColors.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 20,
          height: 20,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: colors.holiday, width: 1.5),
          ),
          child: Text(
            '1',
            style: theme.textTheme.labelSmall?.copyWith(
              color: colors.holiday,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(l10n.calendarHoliday, style: theme.textTheme.bodySmall),
      ],
    );
  }
}

/// Legend sample for school holidays: the band below the days.
class SchoolHolidayLegendItem extends StatelessWidget {
  const SchoolHolidayLegendItem({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 20,
          height: 3,
          child: ColoredBox(color: AppColors.of(context).schoolHoliday),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(l10n.calendarSchoolHoliday, style: theme.textTheme.bodySmall),
      ],
    );
  }
}

/// Icon-and-text line used on the day sheet and the today card.
class HolidayInfoLine extends StatelessWidget {
  const HolidayInfoLine({required this.icon, required this.text, super.key});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xs),
      child: Row(
        children: [
          Icon(icon, size: 18, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: Text(text, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
