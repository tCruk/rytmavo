import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/l10n/generated/app_localizations.dart';
import '../../../../core/ui/components/components.dart';
import '../../../../core/ui/tokens/tokens.dart';
import '../../../settings/domain/entities/app_settings.dart';
import '../../../settings/presentation/controllers/settings_controller.dart';
import '../../data/school_holiday_data.dart';
import '../../domain/entities/german_state.dart';
import '../../domain/services/holiday_calendar.dart';
import '../holiday_labels.dart';

/// Asks which holidays to mark: the federal state (or nationwide only),
/// school holidays, and whether public holidays are days off.
class HolidaySettingsScreen extends ConsumerStatefulWidget {
  const HolidaySettingsScreen({super.key});

  @override
  ConsumerState<HolidaySettingsScreen> createState() =>
      _HolidaySettingsScreenState();
}

class _HolidaySettingsScreenState extends ConsumerState<HolidaySettingsScreen> {
  late GermanState? _state;
  late bool _school;
  late bool _daysOff;

  @override
  void initState() {
    super.initState();
    final s =
        ref.read(settingsControllerProvider).value ?? AppSettings.defaults;
    _state = s.holidayState;
    // First visit: suggest school holidays once a state is picked.
    _school = s.holidaySetupDone ? s.showSchoolHolidays : true;
    _daysOff = s.holidaysAreDaysOff;
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    final navigator = Navigator.of(context);
    await ref
        .read(settingsControllerProvider.notifier)
        .setHolidayPreferences(
          state: _state,
          showSchoolHolidays: _school,
          holidaysAreDaysOff: _daysOff,
        );
    if (!mounted) return;
    showRySnackBar(context, l10n.holidaysSaved);
    await navigator.maybePop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final dataEnd = _state == null
        ? null
        : HolidayCalendar(
            state: _state,
            showSchoolHolidays: true,
            schoolHolidays: schoolHolidayData,
          ).schoolDataEnd;
    final states = [...GermanState.values]
      ..sort((a, b) => a.displayName(l10n).compareTo(b.displayName(l10n)));
    final schoolSubtitle = _state == null
        ? l10n.holidaysSchoolNeedsState
        : [
            l10n.holidaysSchoolToggleBody,
            if (dataEnd != null)
              l10n.holidaysSchoolDataUntil(
                MaterialLocalizations.of(context)
                    .formatMediumDate(dataEnd.toLocalDateTime()),
              ),
          ].join(' ');

    return RyPage(
      title: l10n.holidaysTitle,
      leading: BackButton(onPressed: () => Navigator.of(context).maybePop()),
      slivers: [
        RySliverPadding(
          sliver: SliverList.list(
            children: [
              const SizedBox(height: AppSpacing.sm),
              Text(l10n.holidaysIntro, style: theme.textTheme.bodyMedium),
              RySectionHeader(l10n.holidaysStateLabel),
              RyCard(
                padding: EdgeInsets.zero,
                child: RadioGroup<GermanState?>(
                  groupValue: _state,
                  onChanged: (v) => setState(() => _state = v),
                  child: Column(
                    children: [
                      RadioListTile<GermanState?>(
                        value: null,
                        title: Text(l10n.holidaysNationwideOnly),
                      ),
                      for (final s in states)
                        RadioListTile<GermanState?>(
                          value: s,
                          title: Text(s.displayName(l10n)),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              RyCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    SwitchListTile(
                      title: Text(l10n.holidaysSchoolToggle),
                      subtitle: Text(schoolSubtitle),
                      value: _state != null && _school,
                      onChanged: _state == null
                          ? null
                          : (v) => setState(() => _school = v),
                    ),
                    const Divider(
                      indent: AppSpacing.lg,
                      endIndent: AppSpacing.lg,
                    ),
                    SwitchListTile(
                      title: Text(l10n.holidaysDaysOffToggle),
                      subtitle: Text(l10n.holidaysDaysOffBody),
                      value: _daysOff,
                      onChanged: (v) => setState(() => _daysOff = v),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              RyButton(
                label: l10n.holidaysSave,
                icon: Icons.check,
                expand: true,
                onPressed: _save,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                l10n.holidaysSource,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ],
    );
  }
}
