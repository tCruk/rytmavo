import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/l10n/generated/app_localizations.dart';
import '../../../../app/router/app_routes.dart';
import '../../../../core/result/failure.dart';
import '../../../../core/result/result.dart';
import '../../../../core/ui/components/components.dart';
import '../../../../core/ui/tokens/tokens.dart';
import '../../../backup/domain/entities/backup_document.dart';
import '../../../backup/presentation/backup_actions.dart';
import '../../../reminders/presentation/reminder_scheduler.dart';
import '../../../shifts/presentation/controllers/shift_providers.dart';
import '../../domain/entities/app_settings.dart';
import '../controllers/settings_controller.dart';
import 'info_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settings =
        ref.watch(settingsControllerProvider).value ?? AppSettings.defaults;
    final controller = ref.read(settingsControllerProvider.notifier);
    final hasRotation =
        ref.watch(shiftSetupProvider).value?.hasRotation ?? false;

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
              RySectionHeader(l10n.settingsSectionShifts),
              RyCard(
                padding: EdgeInsets.zero,
                child: ListTile(
                  leading: const Icon(Icons.tune),
                  title: Text(l10n.settingsEditShifts),
                  subtitle: hasRotation
                      ? null
                      : Text(l10n.settingsShiftsNotSet),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push(AppRoutes.onboarding),
                ),
              ),
              RySectionHeader(l10n.settingsSectionReminders),
              const _RemindersCard(),
              RySectionHeader(l10n.settingsSectionData),
              const _DataCard(),
              RySectionHeader(l10n.settingsSectionAbout),
              const _AboutCard(),
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

/// Global reminder switch. Turning it on asks the OS for permission; when
/// denied the switch stays off and explains where to enable it.
class _RemindersCard extends ConsumerStatefulWidget {
  const _RemindersCard();

  @override
  ConsumerState<_RemindersCard> createState() => _RemindersCardState();
}

class _RemindersCardState extends ConsumerState<_RemindersCard> {
  bool _denied = false;

  Future<void> _toggle(bool enable) async {
    final controller = ref.read(settingsControllerProvider.notifier);
    if (!enable) {
      setState(() => _denied = false);
      await controller.setRemindersEnabled(enabled: false);
      return;
    }
    final granted = await ref
        .read(notificationGatewayProvider)
        .requestPermission();
    if (!mounted) return;
    setState(() => _denied = !granted);
    if (granted) await controller.setRemindersEnabled(enabled: true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final enabled =
        (ref.watch(settingsControllerProvider).value ?? AppSettings.defaults)
            .remindersEnabled;
    return RyCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          SwitchListTile(
            secondary: const Icon(Icons.notifications_outlined),
            title: Text(l10n.settingsRemindersToggle),
            subtitle: Text(
              _denied
                  ? l10n.settingsRemindersDenied
                  : enabled
                  ? l10n.settingsRemindersOn
                  : l10n.settingsRemindersOff,
              style: _denied
                  ? theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.error,
                    )
                  : null,
            ),
            value: enabled,
            onChanged: _toggle,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              0,
              AppSpacing.lg,
              AppSpacing.md,
            ),
            child: Text(
              l10n.settingsRemindersHint,
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

/// Export, import and wipe. Import and delete confirm first; every outcome
/// ends in a snackbar so the user always learns what happened.
class _DataCard extends ConsumerStatefulWidget {
  const _DataCard();

  @override
  ConsumerState<_DataCard> createState() => _DataCardState();
}

class _DataCardState extends ConsumerState<_DataCard> {
  bool _busy = false;

  Future<void> _run(Future<void> Function() action) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await action();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _export() => _run(() async {
    final l10n = AppLocalizations.of(context);
    final result = await ref.read(backupActionsProvider).exportAndShare();
    if (!mounted) return;
    if (result is Error) showRySnackBar(context, l10n.backupExportFailed);
  });

  Future<void> _import() => _run(() async {
    final l10n = AppLocalizations.of(context);
    final actions = ref.read(backupActionsProvider);
    final picked = await actions.pickAndValidate();
    if (!mounted) return;
    final BackupDocument doc;
    switch (picked) {
      case Error(:final failure):
        showRySnackBar(
          context,
          failure is ValidationFailure
              ? l10n.backupImportInvalid
              : l10n.backupImportFailed,
        );
        return;
      case Success(value: null):
        return;
      case Success(:final value):
        doc = value!;
    }
    final confirmed = await showRyConfirmDialog(
      context,
      title: l10n.backupImportTitle,
      message: l10n.backupImportMessage(
        MaterialLocalizations.of(context)
            .formatShortDate(doc.exportedAt.toLocal()),
        doc.habits.length,
        doc.shiftTypes.length,
      ),
      confirmLabel: l10n.backupImportConfirm,
      cancelLabel: l10n.commonCancel,
      destructive: true,
    );
    if (!confirmed || !mounted) return;
    final result = await actions.import(doc);
    if (!mounted) return;
    showRySnackBar(
      context,
      result is Success ? l10n.backupImportDone : l10n.backupImportFailed,
    );
  });

  Future<void> _delete() => _run(() async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showRyConfirmDialog(
      context,
      title: l10n.backupDeleteTitle,
      message: l10n.backupDeleteMessage,
      confirmLabel: l10n.commonDelete,
      cancelLabel: l10n.commonCancel,
      destructive: true,
    );
    if (!confirmed || !mounted) return;
    final result = await ref.read(backupActionsProvider).deleteAll();
    if (!mounted) return;
    showRySnackBar(
      context,
      result is Success ? l10n.backupDeleteDone : l10n.backupDeleteFailed,
    );
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return RyCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          ListTile(
            enabled: !_busy,
            leading: const Icon(Icons.upload_outlined),
            title: Text(l10n.settingsExport),
            subtitle: Text(l10n.settingsExportSubtitle),
            onTap: _export,
          ),
          ListTile(
            enabled: !_busy,
            leading: const Icon(Icons.download_outlined),
            title: Text(l10n.settingsImport),
            subtitle: Text(l10n.settingsImportSubtitle),
            onTap: _import,
          ),
          ListTile(
            enabled: !_busy,
            leading: Icon(Icons.delete_outline, color: scheme.error),
            title: Text(
              l10n.settingsDeleteData,
              style: TextStyle(color: scheme.error),
            ),
            subtitle: Text(l10n.settingsDeleteDataSubtitle),
            onTap: _delete,
          ),
        ],
      ),
    );
  }
}

/// Legal pages and the version row.
class _AboutCard extends ConsumerWidget {
  const _AboutCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final version = ref.watch(appVersionProvider).value;
    void open(InfoKind kind) =>
        context.push(AppRoutes.settingsInfoPath(kind.segment));
    return RyCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: Text(l10n.settingsPrivacy),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => open(InfoKind.privacy),
          ),
          ListTile(
            leading: const Icon(Icons.article_outlined),
            title: Text(l10n.settingsImprint),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => open(InfoKind.imprint),
          ),
          ListTile(
            leading: const Icon(Icons.support_outlined),
            title: Text(l10n.settingsSupport),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => open(InfoKind.support),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l10n.settingsVersion),
            subtitle: Text(
              version == null || version.isEmpty
                  ? l10n.settingsVersionUnknown
                  : version,
            ),
          ),
        ],
      ),
    );
  }
}
