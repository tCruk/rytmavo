import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/l10n/generated/app_localizations.dart';
import '../../../../core/ui/components/components.dart';
import '../../../../core/ui/tokens/tokens.dart';
import '../../domain/entities/app_settings.dart';
import '../controllers/settings_controller.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settings =
        ref.watch(settingsControllerProvider).value ?? AppSettings.defaults;
    final controller = ref.read(settingsControllerProvider.notifier);

    return RyPage(
      title: l10n.settingsTitle,
      leading: BackButton(onPressed: () => Navigator.of(context).maybePop()),
      slivers: [
        RySliverPadding(
          sliver: SliverList.list(
            children: [
              RySectionHeader(l10n.settingsSectionAppearance),
              RyCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _ChoiceTile<AppLanguage>(
                      title: l10n.settingsLanguage,
                      value: settings.language,
                      options: {
                        AppLanguage.system: l10n.settingsLanguageSystem,
                        AppLanguage.de: l10n.settingsLanguageGerman,
                        AppLanguage.en: l10n.settingsLanguageEnglish,
                      },
                      onChanged: controller.setLanguage,
                    ),
                    const Divider(
                      indent: AppSpacing.lg,
                      endIndent: AppSpacing.lg,
                    ),
                    _ChoiceTile<AppThemeMode>(
                      title: l10n.settingsTheme,
                      value: settings.themeMode,
                      options: {
                        AppThemeMode.system: l10n.settingsThemeSystem,
                        AppThemeMode.light: l10n.settingsThemeLight,
                        AppThemeMode.dark: l10n.settingsThemeDark,
                      },
                      onChanged: controller.setThemeMode,
                    ),
                  ],
                ),
              ),
              RySectionHeader(l10n.settingsSectionReminders),
              RyCard(
                padding: EdgeInsets.zero,
                child: ListTile(
                  leading: const Icon(Icons.notifications_outlined),
                  title: Text(l10n.settingsRemindersStatus),
                  subtitle: Text(l10n.settingsRemindersOff),
                ),
              ),
              RySectionHeader(l10n.settingsSectionData),
              RyCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _PendingTile(
                      icon: Icons.upload_outlined,
                      title: l10n.settingsExport,
                    ),
                    _PendingTile(
                      icon: Icons.download_outlined,
                      title: l10n.settingsImport,
                    ),
                    _PendingTile(
                      icon: Icons.delete_outline,
                      title: l10n.settingsDeleteData,
                    ),
                  ],
                ),
              ),
              RySectionHeader(l10n.settingsSectionAbout),
              RyCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _PendingTile(
                      icon: Icons.privacy_tip_outlined,
                      title: l10n.settingsPrivacy,
                    ),
                    _PendingTile(
                      icon: Icons.article_outlined,
                      title: l10n.settingsImprint,
                    ),
                    _PendingTile(
                      icon: Icons.support_outlined,
                      title: l10n.settingsSupport,
                    ),
                    _PendingTile(
                      icon: Icons.info_outline,
                      title: l10n.settingsVersion,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Row that opens a bottom sheet with radio options.
class _ChoiceTile<T> extends StatelessWidget {
  const _ChoiceTile({
    required this.title,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String title;
  final T value;
  final Map<T, String> options;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(options[value] ?? ''),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _pick(context),
    );
  }

  Future<void> _pick(BuildContext context) async {
    final picked = await showModalBottomSheet<T>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.page,
                AppSpacing.sm,
                AppSpacing.page,
                AppSpacing.sm,
              ),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
            RadioGroup<T>(
              groupValue: value,
              onChanged: (v) => Navigator.of(context).pop(v),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final entry in options.entries)
                    RadioListTile<T>(
                      value: entry.key,
                      title: Text(entry.value),
                    ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
    );
    if (picked != null && picked != value) onChanged(picked);
  }
}

class _PendingTile extends StatelessWidget {
  const _PendingTile({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ListTile(
      enabled: false,
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(l10n.settingsComingSoon),
    );
  }
}
