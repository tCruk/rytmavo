import 'dart:ui';

import '../../features/settings/domain/entities/app_settings.dart';
import 'generated/app_localizations.dart';

/// Localizations for code that runs outside the widget tree (notifications,
/// watch sync). Mirrors the app's locale resolution: German is the fallback.
AppLocalizations appLocalizationsFor(AppLanguage language) {
  final locale = switch (language) {
    AppLanguage.de => const Locale('de'),
    AppLanguage.en => const Locale('en'),
    AppLanguage.system => PlatformDispatcher.instance.locale,
  };
  final supported = AppLocalizations.supportedLocales.any(
    (l) => l.languageCode == locale.languageCode,
  );
  return lookupAppLocalizations(
    supported ? Locale(locale.languageCode) : const Locale('de'),
  );
}
