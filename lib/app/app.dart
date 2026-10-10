import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/device_calendar/presentation/calendar_conflict_providers.dart';
import '../features/reminders/presentation/reminder_scheduler.dart';
import '../features/settings/domain/entities/app_settings.dart';
import '../features/settings/presentation/controllers/settings_controller.dart';
import '../features/watch/presentation/watch_sync.dart';
import 'l10n/generated/app_localizations.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

class RytmavoApp extends ConsumerStatefulWidget {
  const RytmavoApp({super.key});

  @override
  ConsumerState<RytmavoApp> createState() => _RytmavoAppState();
}

class _RytmavoAppState extends ConsumerState<RytmavoApp> {
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    // Re-plan the rolling reminder window whenever the app comes back,
    // so the window never runs dry while the app sits in the background.
    // Device calendar events may have changed meanwhile, too.
    _lifecycle = AppLifecycleListener(
      onResume: () {
        refreshDeviceCalendar(ref);
        ref.read(reminderSchedulerProvider).scheduleSync();
        // The watch picks today itself; resume only refreshes the window.
        ref.read(watchSyncProvider).scheduleSync();
      },
    );
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Keeps the scheduler alive; it syncs on start and on every change.
    ref.watch(reminderSchedulerProvider).scheduleSync();
    ref.watch(watchSyncProvider).scheduleSync();
    final router = ref.watch(appRouterProvider);
    final settings =
        ref.watch(settingsControllerProvider).value ?? AppSettings.defaults;

    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: switch (settings.themeMode) {
        AppThemeMode.system => ThemeMode.system,
        AppThemeMode.light => ThemeMode.light,
        AppThemeMode.dark => ThemeMode.dark,
      },
      locale: switch (settings.language) {
        AppLanguage.system => null,
        AppLanguage.de => const Locale('de'),
        AppLanguage.en => const Locale('en'),
      },
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      // German is the fallback when the device locale is unsupported.
      localeResolutionCallback: (locale, supported) {
        if (locale == null) return const Locale('de');
        for (final s in supported) {
          if (s.languageCode == locale.languageCode) return s;
        }
        return const Locale('de');
      },
      routerConfig: router,
    );
  }
}
