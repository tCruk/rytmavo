import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In de, this message translates to:
  /// **'Rytmavo'**
  String get appTitle;

  /// No description provided for @navToday.
  ///
  /// In de, this message translates to:
  /// **'Heute'**
  String get navToday;

  /// No description provided for @navCalendar.
  ///
  /// In de, this message translates to:
  /// **'Kalender'**
  String get navCalendar;

  /// No description provided for @navHabits.
  ///
  /// In de, this message translates to:
  /// **'Gewohnheiten'**
  String get navHabits;

  /// No description provided for @navStats.
  ///
  /// In de, this message translates to:
  /// **'Auswertung'**
  String get navStats;

  /// No description provided for @settingsTitle.
  ///
  /// In de, this message translates to:
  /// **'Einstellungen'**
  String get settingsTitle;

  /// No description provided for @settingsOpen.
  ///
  /// In de, this message translates to:
  /// **'Einstellungen öffnen'**
  String get settingsOpen;

  /// No description provided for @commonOk.
  ///
  /// In de, this message translates to:
  /// **'OK'**
  String get commonOk;

  /// No description provided for @commonCancel.
  ///
  /// In de, this message translates to:
  /// **'Abbrechen'**
  String get commonCancel;

  /// No description provided for @commonSave.
  ///
  /// In de, this message translates to:
  /// **'Speichern'**
  String get commonSave;

  /// No description provided for @commonDelete.
  ///
  /// In de, this message translates to:
  /// **'Löschen'**
  String get commonDelete;

  /// No description provided for @commonUndo.
  ///
  /// In de, this message translates to:
  /// **'Rückgängig'**
  String get commonUndo;

  /// No description provided for @commonRetry.
  ///
  /// In de, this message translates to:
  /// **'Erneut versuchen'**
  String get commonRetry;

  /// No description provided for @commonClose.
  ///
  /// In de, this message translates to:
  /// **'Schließen'**
  String get commonClose;

  /// No description provided for @commonBack.
  ///
  /// In de, this message translates to:
  /// **'Zurück'**
  String get commonBack;

  /// No description provided for @commonNext.
  ///
  /// In de, this message translates to:
  /// **'Weiter'**
  String get commonNext;

  /// No description provided for @commonDone.
  ///
  /// In de, this message translates to:
  /// **'Fertig'**
  String get commonDone;

  /// No description provided for @commonEdit.
  ///
  /// In de, this message translates to:
  /// **'Bearbeiten'**
  String get commonEdit;

  /// No description provided for @commonAdd.
  ///
  /// In de, this message translates to:
  /// **'Hinzufügen'**
  String get commonAdd;

  /// No description provided for @commonLoading.
  ///
  /// In de, this message translates to:
  /// **'Wird geladen …'**
  String get commonLoading;

  /// No description provided for @errorGenericTitle.
  ///
  /// In de, this message translates to:
  /// **'Etwas ist schiefgelaufen'**
  String get errorGenericTitle;

  /// No description provided for @errorGenericBody.
  ///
  /// In de, this message translates to:
  /// **'Die Daten konnten nicht geladen werden. Bitte versuche es erneut.'**
  String get errorGenericBody;

  /// No description provided for @todayTitle.
  ///
  /// In de, this message translates to:
  /// **'Heute'**
  String get todayTitle;

  /// No description provided for @todayEmptyTitle.
  ///
  /// In de, this message translates to:
  /// **'Noch kein Schichtplan'**
  String get todayEmptyTitle;

  /// No description provided for @todayEmptyBody.
  ///
  /// In de, this message translates to:
  /// **'Richte dein Schichtsystem ein, damit Rytmavo deine Schichten und Gewohnheiten anzeigen kann.'**
  String get todayEmptyBody;

  /// No description provided for @todaySetupAction.
  ///
  /// In de, this message translates to:
  /// **'Schichtsystem einrichten'**
  String get todaySetupAction;

  /// No description provided for @calendarTitle.
  ///
  /// In de, this message translates to:
  /// **'Kalender'**
  String get calendarTitle;

  /// No description provided for @calendarJumpToToday.
  ///
  /// In de, this message translates to:
  /// **'Zu heute springen'**
  String get calendarJumpToToday;

  /// No description provided for @habitsTitle.
  ///
  /// In de, this message translates to:
  /// **'Gewohnheiten'**
  String get habitsTitle;

  /// No description provided for @habitsEmptyTitle.
  ///
  /// In de, this message translates to:
  /// **'Noch keine Gewohnheiten'**
  String get habitsEmptyTitle;

  /// No description provided for @habitsEmptyBody.
  ///
  /// In de, this message translates to:
  /// **'Lege Gewohnheiten an, die zu deinen Schichten passen – zum Beispiel „Nach der Nachtschicht 20 Minuten spazieren“.'**
  String get habitsEmptyBody;

  /// No description provided for @habitsAddAction.
  ///
  /// In de, this message translates to:
  /// **'Gewohnheit anlegen'**
  String get habitsAddAction;

  /// No description provided for @statsTitle.
  ///
  /// In de, this message translates to:
  /// **'Auswertung'**
  String get statsTitle;

  /// No description provided for @statsEmptyTitle.
  ///
  /// In de, this message translates to:
  /// **'Noch keine Auswertung'**
  String get statsEmptyTitle;

  /// No description provided for @statsEmptyBody.
  ///
  /// In de, this message translates to:
  /// **'Sobald du Gewohnheiten abhakst, siehst du hier deine Erfolgsquote über geplante Tage.'**
  String get statsEmptyBody;

  /// No description provided for @shiftEarly.
  ///
  /// In de, this message translates to:
  /// **'Früh'**
  String get shiftEarly;

  /// No description provided for @shiftLate.
  ///
  /// In de, this message translates to:
  /// **'Spät'**
  String get shiftLate;

  /// No description provided for @shiftNight.
  ///
  /// In de, this message translates to:
  /// **'Nacht'**
  String get shiftNight;

  /// No description provided for @shiftOff.
  ///
  /// In de, this message translates to:
  /// **'Frei'**
  String get shiftOff;

  /// No description provided for @shiftEarlyShort.
  ///
  /// In de, this message translates to:
  /// **'F'**
  String get shiftEarlyShort;

  /// No description provided for @shiftLateShort.
  ///
  /// In de, this message translates to:
  /// **'S'**
  String get shiftLateShort;

  /// No description provided for @shiftNightShort.
  ///
  /// In de, this message translates to:
  /// **'N'**
  String get shiftNightShort;

  /// No description provided for @shiftOffShort.
  ///
  /// In de, this message translates to:
  /// **'–'**
  String get shiftOffShort;

  /// No description provided for @settingsSectionAppearance.
  ///
  /// In de, this message translates to:
  /// **'Darstellung'**
  String get settingsSectionAppearance;

  /// No description provided for @settingsLanguage.
  ///
  /// In de, this message translates to:
  /// **'Sprache'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageSystem.
  ///
  /// In de, this message translates to:
  /// **'Systemsprache'**
  String get settingsLanguageSystem;

  /// No description provided for @settingsLanguageGerman.
  ///
  /// In de, this message translates to:
  /// **'Deutsch'**
  String get settingsLanguageGerman;

  /// No description provided for @settingsLanguageEnglish.
  ///
  /// In de, this message translates to:
  /// **'Englisch'**
  String get settingsLanguageEnglish;

  /// No description provided for @settingsTheme.
  ///
  /// In de, this message translates to:
  /// **'Erscheinungsbild'**
  String get settingsTheme;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In de, this message translates to:
  /// **'System'**
  String get settingsThemeSystem;

  /// No description provided for @settingsThemeLight.
  ///
  /// In de, this message translates to:
  /// **'Hell'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In de, this message translates to:
  /// **'Dunkel'**
  String get settingsThemeDark;

  /// No description provided for @settingsSectionReminders.
  ///
  /// In de, this message translates to:
  /// **'Erinnerungen'**
  String get settingsSectionReminders;

  /// No description provided for @settingsRemindersStatus.
  ///
  /// In de, this message translates to:
  /// **'Status der Erinnerungen'**
  String get settingsRemindersStatus;

  /// No description provided for @settingsRemindersOff.
  ///
  /// In de, this message translates to:
  /// **'Aus – Erinnerungen sind nicht aktiviert.'**
  String get settingsRemindersOff;

  /// No description provided for @settingsSectionData.
  ///
  /// In de, this message translates to:
  /// **'Daten'**
  String get settingsSectionData;

  /// No description provided for @settingsExport.
  ///
  /// In de, this message translates to:
  /// **'Daten exportieren'**
  String get settingsExport;

  /// No description provided for @settingsImport.
  ///
  /// In de, this message translates to:
  /// **'Daten importieren'**
  String get settingsImport;

  /// No description provided for @settingsDeleteData.
  ///
  /// In de, this message translates to:
  /// **'Lokale Daten löschen'**
  String get settingsDeleteData;

  /// No description provided for @settingsSectionAbout.
  ///
  /// In de, this message translates to:
  /// **'Über die App'**
  String get settingsSectionAbout;

  /// No description provided for @settingsPrivacy.
  ///
  /// In de, this message translates to:
  /// **'Datenschutz'**
  String get settingsPrivacy;

  /// No description provided for @settingsImprint.
  ///
  /// In de, this message translates to:
  /// **'Impressum'**
  String get settingsImprint;

  /// No description provided for @settingsSupport.
  ///
  /// In de, this message translates to:
  /// **'Support'**
  String get settingsSupport;

  /// No description provided for @settingsVersion.
  ///
  /// In de, this message translates to:
  /// **'Version'**
  String get settingsVersion;

  /// No description provided for @settingsComingSoon.
  ///
  /// In de, this message translates to:
  /// **'In einer späteren Phase verfügbar.'**
  String get settingsComingSoon;

  /// No description provided for @a11yShiftBadge.
  ///
  /// In de, this message translates to:
  /// **'Schicht: {shiftName}'**
  String a11yShiftBadge(String shiftName);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
