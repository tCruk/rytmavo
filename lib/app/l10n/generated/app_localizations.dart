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

  /// No description provided for @shiftsEditAction.
  ///
  /// In de, this message translates to:
  /// **'Schichtmodell bearbeiten'**
  String get shiftsEditAction;

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

  /// No description provided for @settingsExportSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Alle Daten als unverschlüsselte JSON-Datei teilen oder sichern.'**
  String get settingsExportSubtitle;

  /// No description provided for @settingsImportSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Sicherung wiederherstellen. Ersetzt alle aktuellen Daten.'**
  String get settingsImportSubtitle;

  /// No description provided for @settingsDeleteDataSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Entfernt alle Schichten, Gewohnheiten und Einstellungen von diesem Gerät.'**
  String get settingsDeleteDataSubtitle;

  /// No description provided for @backupExportFailed.
  ///
  /// In de, this message translates to:
  /// **'Export fehlgeschlagen. Bitte versuche es erneut.'**
  String get backupExportFailed;

  /// No description provided for @backupImportTitle.
  ///
  /// In de, this message translates to:
  /// **'Sicherung importieren?'**
  String get backupImportTitle;

  /// No description provided for @backupImportMessage.
  ///
  /// In de, this message translates to:
  /// **'Die Sicherung vom {date} enthält {habits} Gewohnheiten und {shiftTypes} Schichtarten. Alle aktuellen Daten werden ersetzt.'**
  String backupImportMessage(String date, int habits, int shiftTypes);

  /// No description provided for @backupImportConfirm.
  ///
  /// In de, this message translates to:
  /// **'Importieren'**
  String get backupImportConfirm;

  /// No description provided for @backupImportDone.
  ///
  /// In de, this message translates to:
  /// **'Sicherung wiederhergestellt.'**
  String get backupImportDone;

  /// No description provided for @backupImportInvalid.
  ///
  /// In de, this message translates to:
  /// **'Die Datei ist keine gültige Rytmavo-Sicherung.'**
  String get backupImportInvalid;

  /// No description provided for @backupImportFailed.
  ///
  /// In de, this message translates to:
  /// **'Import fehlgeschlagen. Deine Daten wurden nicht verändert.'**
  String get backupImportFailed;

  /// No description provided for @backupDeleteTitle.
  ///
  /// In de, this message translates to:
  /// **'Alle lokalen Daten löschen?'**
  String get backupDeleteTitle;

  /// No description provided for @backupDeleteMessage.
  ///
  /// In de, this message translates to:
  /// **'Schichten, Gewohnheiten, Erledigungen und Einstellungen werden unwiderruflich gelöscht. Exportiere vorher eine Sicherung, wenn du die Daten behalten möchtest.'**
  String get backupDeleteMessage;

  /// No description provided for @backupDeleteDone.
  ///
  /// In de, this message translates to:
  /// **'Alle lokalen Daten wurden gelöscht.'**
  String get backupDeleteDone;

  /// No description provided for @backupDeleteFailed.
  ///
  /// In de, this message translates to:
  /// **'Löschen fehlgeschlagen.'**
  String get backupDeleteFailed;

  /// No description provided for @a11yShiftBadge.
  ///
  /// In de, this message translates to:
  /// **'Schicht: {shiftName}'**
  String a11yShiftBadge(String shiftName);

  /// No description provided for @onboardingTitle.
  ///
  /// In de, this message translates to:
  /// **'Schichtsystem einrichten'**
  String get onboardingTitle;

  /// No description provided for @onboardingEditTitle.
  ///
  /// In de, this message translates to:
  /// **'Schichtsystem ändern'**
  String get onboardingEditTitle;

  /// No description provided for @onboardingStepOf.
  ///
  /// In de, this message translates to:
  /// **'Schritt {current} von {total}'**
  String onboardingStepOf(int current, int total);

  /// No description provided for @onboardingPresetTitle.
  ///
  /// In de, this message translates to:
  /// **'Wie arbeitest du?'**
  String get onboardingPresetTitle;

  /// No description provided for @onboardingPresetBody.
  ///
  /// In de, this message translates to:
  /// **'Wähle eine Vorlage. Im nächsten Schritt kannst du jeden Tag einzeln anpassen.'**
  String get onboardingPresetBody;

  /// No description provided for @presetWeekly3Name.
  ///
  /// In de, this message translates to:
  /// **'3-Schicht, wöchentlich'**
  String get presetWeekly3Name;

  /// No description provided for @presetWeekly3Desc.
  ///
  /// In de, this message translates to:
  /// **'5 Früh · 2 frei · 5 Spät · 2 frei · 5 Nacht · 2 frei'**
  String get presetWeekly3Desc;

  /// No description provided for @presetWeekly2Name.
  ///
  /// In de, this message translates to:
  /// **'2-Schicht, wöchentlich'**
  String get presetWeekly2Name;

  /// No description provided for @presetWeekly2Desc.
  ///
  /// In de, this message translates to:
  /// **'5 Früh · 2 frei · 5 Spät · 2 frei'**
  String get presetWeekly2Desc;

  /// No description provided for @presetConti4Name.
  ///
  /// In de, this message translates to:
  /// **'Konti, 4 Gruppen'**
  String get presetConti4Name;

  /// No description provided for @presetConti4Desc.
  ///
  /// In de, this message translates to:
  /// **'2 Früh · 2 Spät · 2 Nacht · 2 frei'**
  String get presetConti4Desc;

  /// No description provided for @presetConti5Name.
  ///
  /// In de, this message translates to:
  /// **'Konti, 5 Gruppen'**
  String get presetConti5Name;

  /// No description provided for @presetConti5Desc.
  ///
  /// In de, this message translates to:
  /// **'2 Früh · 2 Spät · 2 Nacht · 4 frei'**
  String get presetConti5Desc;

  /// No description provided for @presetCustomName.
  ///
  /// In de, this message translates to:
  /// **'Eigener Rhythmus'**
  String get presetCustomName;

  /// No description provided for @presetCustomDesc.
  ///
  /// In de, this message translates to:
  /// **'Baue deinen Zyklus selbst, Tag für Tag.'**
  String get presetCustomDesc;

  /// No description provided for @presetCurrentName.
  ///
  /// In de, this message translates to:
  /// **'Aktueller Rhythmus'**
  String get presetCurrentName;

  /// No description provided for @presetCurrentDesc.
  ///
  /// In de, this message translates to:
  /// **'Deinen bestehenden Zyklus weiter anpassen.'**
  String get presetCurrentDesc;

  /// No description provided for @cycleLength.
  ///
  /// In de, this message translates to:
  /// **'{count, plural, =1{1 Tag} other{{count} Tage}}'**
  String cycleLength(int count);

  /// No description provided for @onboardingRhythmTitle.
  ///
  /// In de, this message translates to:
  /// **'Dein Rhythmus'**
  String get onboardingRhythmTitle;

  /// No description provided for @onboardingRhythmBody.
  ///
  /// In de, this message translates to:
  /// **'Tippe auf einen Tag, um die Schicht zu wechseln.'**
  String get onboardingRhythmBody;

  /// No description provided for @onboardingDayN.
  ///
  /// In de, this message translates to:
  /// **'Tag {number}'**
  String onboardingDayN(int number);

  /// No description provided for @onboardingAddDay.
  ///
  /// In de, this message translates to:
  /// **'Tag hinzufügen'**
  String get onboardingAddDay;

  /// No description provided for @onboardingRemoveDay.
  ///
  /// In de, this message translates to:
  /// **'Letzten Tag entfernen'**
  String get onboardingRemoveDay;

  /// No description provided for @onboardingTodayTitle.
  ///
  /// In de, this message translates to:
  /// **'Welcher Tag ist heute?'**
  String get onboardingTodayTitle;

  /// No description provided for @onboardingTodayBody.
  ///
  /// In de, this message translates to:
  /// **'Wähle, an welcher Stelle deines Zyklus du heute stehst. Daraus berechnet Rytmavo alle anderen Tage.'**
  String get onboardingTodayBody;

  /// No description provided for @onboardingPreview.
  ///
  /// In de, this message translates to:
  /// **'Vorschau'**
  String get onboardingPreview;

  /// No description provided for @onboardingTimesTitle.
  ///
  /// In de, this message translates to:
  /// **'Schichtzeiten'**
  String get onboardingTimesTitle;

  /// No description provided for @onboardingTimesBody.
  ///
  /// In de, this message translates to:
  /// **'Die Zeiten erscheinen in der Tagesansicht und im Kalender.'**
  String get onboardingTimesBody;

  /// No description provided for @onboardingNightHint.
  ///
  /// In de, this message translates to:
  /// **'Eine Nachtschicht zählt zu dem Tag, an dem sie beginnt.'**
  String get onboardingNightHint;

  /// No description provided for @onboardingEditHint.
  ///
  /// In de, this message translates to:
  /// **'Änderungen gelten ab heute. Vergangene Tage bleiben, wie sie waren.'**
  String get onboardingEditHint;

  /// No description provided for @onboardingSaveError.
  ///
  /// In de, this message translates to:
  /// **'Speichern fehlgeschlagen. Bitte versuche es erneut.'**
  String get onboardingSaveError;

  /// No description provided for @shiftStart.
  ///
  /// In de, this message translates to:
  /// **'Beginn'**
  String get shiftStart;

  /// No description provided for @shiftEnd.
  ///
  /// In de, this message translates to:
  /// **'Ende'**
  String get shiftEnd;

  /// No description provided for @shiftTimeRange.
  ///
  /// In de, this message translates to:
  /// **'{start}–{end}'**
  String shiftTimeRange(String start, String end);

  /// No description provided for @shiftEndsNextDay.
  ///
  /// In de, this message translates to:
  /// **'endet am Folgetag'**
  String get shiftEndsNextDay;

  /// No description provided for @todayNextDays.
  ///
  /// In de, this message translates to:
  /// **'Nächste Tage'**
  String get todayNextDays;

  /// No description provided for @todayOverriddenFrom.
  ///
  /// In de, this message translates to:
  /// **'Geändert · laut Rhythmus {shiftName}'**
  String todayOverriddenFrom(String shiftName);

  /// No description provided for @todayNoEntry.
  ///
  /// In de, this message translates to:
  /// **'Kein Eintrag'**
  String get todayNoEntry;

  /// No description provided for @todayDayOffBody.
  ///
  /// In de, this message translates to:
  /// **'Heute hast du frei.'**
  String get todayDayOffBody;

  /// No description provided for @todayNextShift.
  ///
  /// In de, this message translates to:
  /// **'Nächste Schicht: {shiftName}, {date}'**
  String todayNextShift(String shiftName, String date);

  /// No description provided for @calendarPrevMonth.
  ///
  /// In de, this message translates to:
  /// **'Vorheriger Monat'**
  String get calendarPrevMonth;

  /// No description provided for @calendarNextMonth.
  ///
  /// In de, this message translates to:
  /// **'Nächster Monat'**
  String get calendarNextMonth;

  /// No description provided for @calendarChanged.
  ///
  /// In de, this message translates to:
  /// **'geändert'**
  String get calendarChanged;

  /// No description provided for @calendarDayA11y.
  ///
  /// In de, this message translates to:
  /// **'{date}, {shiftName}'**
  String calendarDayA11y(String date, String shiftName);

  /// No description provided for @daySheetRotation.
  ///
  /// In de, this message translates to:
  /// **'Laut Rhythmus: {shiftName}'**
  String daySheetRotation(String shiftName);

  /// No description provided for @daySheetChange.
  ///
  /// In de, this message translates to:
  /// **'Schicht für diesen Tag'**
  String get daySheetChange;

  /// No description provided for @daySheetReset.
  ///
  /// In de, this message translates to:
  /// **'Rhythmus wiederherstellen'**
  String get daySheetReset;

  /// No description provided for @daySheetSaved.
  ///
  /// In de, this message translates to:
  /// **'Schicht für {date} geändert'**
  String daySheetSaved(String date);

  /// No description provided for @daySheetResetDone.
  ///
  /// In de, this message translates to:
  /// **'Rhythmus für {date} wiederhergestellt'**
  String daySheetResetDone(String date);

  /// No description provided for @settingsSectionShifts.
  ///
  /// In de, this message translates to:
  /// **'Schichtsystem'**
  String get settingsSectionShifts;

  /// No description provided for @settingsEditShifts.
  ///
  /// In de, this message translates to:
  /// **'Rhythmus und Zeiten ändern'**
  String get settingsEditShifts;

  /// No description provided for @settingsShiftsNotSet.
  ///
  /// In de, this message translates to:
  /// **'Noch nicht eingerichtet'**
  String get settingsShiftsNotSet;

  /// No description provided for @habitNewTitle.
  ///
  /// In de, this message translates to:
  /// **'Neue Gewohnheit'**
  String get habitNewTitle;

  /// No description provided for @habitEditTitle.
  ///
  /// In de, this message translates to:
  /// **'Gewohnheit bearbeiten'**
  String get habitEditTitle;

  /// No description provided for @habitName.
  ///
  /// In de, this message translates to:
  /// **'Name'**
  String get habitName;

  /// No description provided for @habitNameHint.
  ///
  /// In de, this message translates to:
  /// **'z. B. 20 Minuten spazieren'**
  String get habitNameHint;

  /// No description provided for @habitNameRequired.
  ///
  /// In de, this message translates to:
  /// **'Bitte gib einen Namen ein.'**
  String get habitNameRequired;

  /// No description provided for @habitDescription.
  ///
  /// In de, this message translates to:
  /// **'Notiz (optional)'**
  String get habitDescription;

  /// No description provided for @habitIcon.
  ///
  /// In de, this message translates to:
  /// **'Symbol'**
  String get habitIcon;

  /// No description provided for @habitColor.
  ///
  /// In de, this message translates to:
  /// **'Farbe'**
  String get habitColor;

  /// No description provided for @habitDueOn.
  ///
  /// In de, this message translates to:
  /// **'Fällig an'**
  String get habitDueOn;

  /// No description provided for @habitDueEveryDay.
  ///
  /// In de, this message translates to:
  /// **'Jeden Tag'**
  String get habitDueEveryDay;

  /// No description provided for @habitDueOnShifts.
  ///
  /// In de, this message translates to:
  /// **'Nur an bestimmten Schichten'**
  String get habitDueOnShifts;

  /// No description provided for @habitWeekdays.
  ///
  /// In de, this message translates to:
  /// **'Nur an Wochentagen (optional)'**
  String get habitWeekdays;

  /// No description provided for @habitWeekdaysAny.
  ///
  /// In de, this message translates to:
  /// **'Alle Wochentage'**
  String get habitWeekdaysAny;

  /// No description provided for @habitRuleHint.
  ///
  /// In de, this message translates to:
  /// **'Änderungen an der Fälligkeit gelten ab heute. Vergangene Tage werden nicht neu bewertet.'**
  String get habitRuleHint;

  /// No description provided for @habitArchive.
  ///
  /// In de, this message translates to:
  /// **'Archivieren'**
  String get habitArchive;

  /// No description provided for @habitArchiveBody.
  ///
  /// In de, this message translates to:
  /// **'Die Gewohnheit verschwindet aus der Liste. Ihre Historie bleibt in der Auswertung erhalten.'**
  String get habitArchiveBody;

  /// No description provided for @habitArchived.
  ///
  /// In de, this message translates to:
  /// **'Gewohnheit archiviert'**
  String get habitArchived;

  /// No description provided for @habitDelete.
  ///
  /// In de, this message translates to:
  /// **'Endgültig löschen'**
  String get habitDelete;

  /// No description provided for @habitDeleteBody.
  ///
  /// In de, this message translates to:
  /// **'Alle Erledigungen dieser Gewohnheit werden gelöscht. Das lässt sich nicht rückgängig machen.'**
  String get habitDeleteBody;

  /// No description provided for @habitDeleted.
  ///
  /// In de, this message translates to:
  /// **'Gewohnheit gelöscht'**
  String get habitDeleted;

  /// No description provided for @habitSaved.
  ///
  /// In de, this message translates to:
  /// **'Gewohnheit gespeichert'**
  String get habitSaved;

  /// No description provided for @habitShowArchived.
  ///
  /// In de, this message translates to:
  /// **'Archivierte anzeigen'**
  String get habitShowArchived;

  /// No description provided for @habitRestore.
  ///
  /// In de, this message translates to:
  /// **'Wiederherstellen'**
  String get habitRestore;

  /// No description provided for @habitDueSummaryEveryDay.
  ///
  /// In de, this message translates to:
  /// **'Jeden Tag'**
  String get habitDueSummaryEveryDay;

  /// No description provided for @habitDueSummaryShifts.
  ///
  /// In de, this message translates to:
  /// **'An: {shifts}'**
  String habitDueSummaryShifts(String shifts);

  /// No description provided for @habitReorder.
  ///
  /// In de, this message translates to:
  /// **'Reihenfolge ändern'**
  String get habitReorder;

  /// No description provided for @todayHabitsSection.
  ///
  /// In de, this message translates to:
  /// **'Gewohnheiten heute'**
  String get todayHabitsSection;

  /// No description provided for @todayHabitsNone.
  ///
  /// In de, this message translates to:
  /// **'Heute ist keine Gewohnheit fällig.'**
  String get todayHabitsNone;

  /// No description provided for @todayHabitsProgress.
  ///
  /// In de, this message translates to:
  /// **'{done} von {total} erledigt'**
  String todayHabitsProgress(int done, int total);

  /// No description provided for @todayHabitDone.
  ///
  /// In de, this message translates to:
  /// **'{name} erledigt'**
  String todayHabitDone(String name);

  /// No description provided for @todayHabitUndone.
  ///
  /// In de, this message translates to:
  /// **'{name} wieder offen'**
  String todayHabitUndone(String name);

  /// No description provided for @a11yHabitToggle.
  ///
  /// In de, this message translates to:
  /// **'{name}, {state}'**
  String a11yHabitToggle(String name, String state);

  /// No description provided for @a11yStateDone.
  ///
  /// In de, this message translates to:
  /// **'erledigt'**
  String get a11yStateDone;

  /// No description provided for @a11yStateOpen.
  ///
  /// In de, this message translates to:
  /// **'offen'**
  String get a11yStateOpen;

  /// No description provided for @statsPeriod7.
  ///
  /// In de, this message translates to:
  /// **'7 Tage'**
  String get statsPeriod7;

  /// No description provided for @statsPeriod30.
  ///
  /// In de, this message translates to:
  /// **'30 Tage'**
  String get statsPeriod30;

  /// No description provided for @statsPeriod90.
  ///
  /// In de, this message translates to:
  /// **'90 Tage'**
  String get statsPeriod90;

  /// No description provided for @statsOverall.
  ///
  /// In de, this message translates to:
  /// **'Gesamt'**
  String get statsOverall;

  /// No description provided for @statsRate.
  ///
  /// In de, this message translates to:
  /// **'Erfolgsquote'**
  String get statsRate;

  /// No description provided for @statsDueDays.
  ///
  /// In de, this message translates to:
  /// **'{count, plural, =1{1 fälliger Tag} other{{count} fällige Tage}}'**
  String statsDueDays(int count);

  /// No description provided for @statsCompleted.
  ///
  /// In de, this message translates to:
  /// **'{done} von {total}'**
  String statsCompleted(int done, int total);

  /// No description provided for @statsNotDue.
  ///
  /// In de, this message translates to:
  /// **'In diesem Zeitraum nicht fällig'**
  String get statsNotDue;

  /// No description provided for @statsStreak.
  ///
  /// In de, this message translates to:
  /// **'Aktuelle Serie'**
  String get statsStreak;

  /// No description provided for @statsBestStreak.
  ///
  /// In de, this message translates to:
  /// **'Beste Serie'**
  String get statsBestStreak;

  /// No description provided for @statsStreakDays.
  ///
  /// In de, this message translates to:
  /// **'{count, plural, =1{1 Tag} other{{count} Tage}}'**
  String statsStreakDays(int count);

  /// No description provided for @statsByShift.
  ///
  /// In de, this message translates to:
  /// **'Nach Schicht'**
  String get statsByShift;

  /// No description provided for @statsPercent.
  ///
  /// In de, this message translates to:
  /// **'{value} %'**
  String statsPercent(int value);

  /// No description provided for @reminderBodyPlain.
  ///
  /// In de, this message translates to:
  /// **'Heute fällig.'**
  String get reminderBodyPlain;

  /// No description provided for @reminderBodyWithShift.
  ///
  /// In de, this message translates to:
  /// **'Heute fällig ({shiftName}).'**
  String reminderBodyWithShift(String shiftName);

  /// No description provided for @settingsRemindersToggle.
  ///
  /// In de, this message translates to:
  /// **'Erinnerungen'**
  String get settingsRemindersToggle;

  /// No description provided for @settingsRemindersOn.
  ///
  /// In de, this message translates to:
  /// **'An – du wirst an fällige Gewohnheiten erinnert.'**
  String get settingsRemindersOn;

  /// No description provided for @settingsRemindersDenied.
  ///
  /// In de, this message translates to:
  /// **'Berechtigung verweigert. Aktiviere Mitteilungen für Rytmavo in den Systemeinstellungen.'**
  String get settingsRemindersDenied;

  /// No description provided for @settingsRemindersHint.
  ///
  /// In de, this message translates to:
  /// **'Erinnerungen werden pro Gewohnheit eingestellt. Android stellt sie nicht sekundengenau zu, um Akku zu sparen.'**
  String get settingsRemindersHint;

  /// No description provided for @habitReminder.
  ///
  /// In de, this message translates to:
  /// **'Erinnerung'**
  String get habitReminder;

  /// No description provided for @habitReminderOff.
  ///
  /// In de, this message translates to:
  /// **'Keine Erinnerung'**
  String get habitReminderOff;

  /// No description provided for @habitReminderAt.
  ///
  /// In de, this message translates to:
  /// **'Erinnern um'**
  String get habitReminderAt;

  /// No description provided for @habitReminderPerShift.
  ///
  /// In de, this message translates to:
  /// **'Zeit je Schicht'**
  String get habitReminderPerShift;

  /// No description provided for @habitReminderGlobalOff.
  ///
  /// In de, this message translates to:
  /// **'Erinnerungen sind in den Einstellungen ausgeschaltet.'**
  String get habitReminderGlobalOff;

  /// No description provided for @settingsVersionUnknown.
  ///
  /// In de, this message translates to:
  /// **'Unbekannt'**
  String get settingsVersionUnknown;

  /// No description provided for @infoPrivacyTitle.
  ///
  /// In de, this message translates to:
  /// **'Datenschutz'**
  String get infoPrivacyTitle;

  /// No description provided for @infoPrivacyBody.
  ///
  /// In de, this message translates to:
  /// **'Stand: Oktober 2026\n\n# 1. Verantwortlicher\n\nVerantwortlicher im Sinne der Datenschutz-Grundverordnung (DSGVO) ist:\n\nTim Kremers\nResinovo\nIn Venrath 17B\n41812 Erkelenz\nDeutschland\n\nTelefon: +49 176 43594878\nE-Mail: kontakt@resinovo.de\n\n# 2. Datenschutzbeauftragter\n\nEin Datenschutzbeauftragter ist nicht bestellt, da die gesetzlichen Voraussetzungen hierfür nicht vorliegen.\n\n# 3. Das Wichtigste in Kürze\n\nRytmavo funktioniert vollständig offline. Es gibt kein Benutzerkonto, keine Werbung, kein Tracking und keine Server des Anbieters. Alle Daten bleiben auf deinem Gerät. Daten verlassen das Gerät nur, wenn du selbst eine Sicherung exportierst oder teilst.\n\n# 4. Lokale Datenverarbeitung auf dem Gerät\n\nDie App speichert folgende Daten ausschließlich lokal auf deinem Gerät im App-Speicher: Schichtarten mit Zeiten und Farben, Rotationsmuster und Ankerdatum, Tagesänderungen, Gewohnheiten mit Regeln und Erinnerungszeiten, Erledigungen je Tag sowie App-Einstellungen (Sprache, Design, Erinnerungsstatus). Diese Daten werden nicht an den Anbieter übertragen. Du kannst sie in der App einzeln löschen, unter Einstellungen → Daten vollständig löschen oder die App deinstallieren. Ob Gerätesicherungen (z. B. iCloud, Google-Backup) diese Daten enthalten, richtet sich nach deinem Gerät und den Regeln von Apple bzw. Google.\n\nRechtsgrundlage: Art. 6 Abs. 1 lit. b DSGVO (Bereitstellung der App-Funktionen).\n\n# 5. Erinnerungen (Mitteilungen)\n\nAuf Wunsch plant die App lokale Erinnerungen über das Benachrichtigungssystem deines Geräts. Dafür fragt sie einmalig nach der Berechtigung für Mitteilungen. Es werden keine Push-Dienste und keine Server genutzt; die Erinnerungen entstehen und bleiben auf dem Gerät. Du kannst sie jederzeit in den Einstellungen der App oder des Geräts abschalten.\n\n# 6. Gerätekalender (optional)\n\nNur wenn du unter Einstellungen → Gerätekalender „Kalendertermine anzeigen“ einschaltest, fragt die App nach Zugriff auf den Kalender deines Geräts. Sie liest dann Titel und Zeiten der Termine aus den von dir gewählten Kalendern, um sie in der Kalenderansicht anzuzeigen, Überschneidungen mit deinen Schichten zu markieren und dich auf Wunsch am Vorabend zu erinnern. Die Termine werden nur auf dem Gerät ausgewertet, nicht verändert, nicht in der App gespeichert und nicht übertragen. Den Zugriff kannst du jederzeit in der App ausschalten oder in den Systemeinstellungen widerrufen.\n\nRechtsgrundlage: Art. 6 Abs. 1 lit. a DSGVO (deine Einwilligung durch das Einschalten der Funktion und die Freigabe des Kalenderzugriffs).\n\n# 7. Sicherung, Import und Teilen\n\nEine Sicherung (JSON-Datei) entsteht nur auf deine Anweisung. Beim Teilen übergibt die App die Datei an das von dir gewählte Ziel (z. B. Dateien-App, E-Mail, Cloud-Speicher); ab dort gelten die Datenschutzbestimmungen des jeweiligen Anbieters. Beim Import liest die App nur die Datei, die du selbst auswählst. Der Anbieter erhält diese Dateien nicht. Die Datei ist unverschlüsselt.\n\n# 8. Kauf über die App Stores\n\nDer Kauf der App wird ausschließlich über den Apple App Store bzw. Google Play abgewickelt. Dabei verarbeiten Apple bzw. Google deine Daten als eigenständig Verantwortliche nach ihren Datenschutzbestimmungen. Der Anbieter erhält keine personenbezogenen Kaufdaten.\n\n# 9. Keine Verarbeitung auf Servern des Anbieters\n\nAlle Funktionen laufen auf dem Gerät. Sollten künftig serverbasierte Funktionen hinzukommen, wird diese Datenschutzerklärung vorher angepasst und in der App angezeigt.\n\n# 10. Empfänger und Drittlandübermittlung\n\nEine Übermittlung an Dritte erfolgt nicht, außer an die von dir beim Teilen gewählten Ziele sowie an Apple bzw. Google im Rahmen des Kaufs. Eine Übermittlung in Drittländer durch den Anbieter findet nicht statt.\n\n# 11. Speicherdauer\n\nLokale Daten bleiben gespeichert, bis du sie löschst oder die App deinstallierst. E-Mail-Anfragen an den Anbieter werden gelöscht, sobald das Anliegen erledigt ist und keine gesetzlichen Aufbewahrungspflichten bestehen.\n\n# 12. Keine automatisierte Entscheidungsfindung\n\nEine automatisierte Entscheidungsfindung oder ein Profiling findet nicht statt.\n\n# 13. Minderjährige\n\nDie App richtet sich an Berufstätige. Sie ist nicht für Kinder unter 13 Jahren bestimmt; wissentlich werden keine personenbezogenen Daten von Kindern erhoben.\n\n# 14. Deine Rechte\n\nDu hast das Recht auf Auskunft (Art. 15 DSGVO), Berichtigung (Art. 16), Löschung (Art. 17), Einschränkung der Verarbeitung (Art. 18) und Datenübertragbarkeit (Art. 20) sowie das Recht, erteilte Einwilligungen mit Wirkung für die Zukunft zu widerrufen. Soweit eine Verarbeitung auf berechtigten Interessen beruht, kannst du jederzeit Widerspruch einlegen (Art. 21 DSGVO). Eine E-Mail an kontakt@resinovo.de genügt. Da die App-Daten nur auf deinem Gerät liegen, kannst du Auskunft, Export und Löschung direkt in der App selbst vornehmen.\n\n# 15. Beschwerderecht\n\nDu hast das Recht, dich bei einer Datenschutz-Aufsichtsbehörde zu beschweren. Zuständig ist die Landesbeauftragte für Datenschutz und Informationsfreiheit Nordrhein-Westfalen, Kavalleriestraße 2–4, 40213 Düsseldorf.\n\n# 16. Änderungen dieser Datenschutzerklärung\n\nDiese Erklärung wird angepasst, wenn sich die Rechtslage, die Technik oder der Funktionsumfang der App ändert. Die jeweils aktuelle Fassung findest du in der App unter Einstellungen → Datenschutz.'**
  String get infoPrivacyBody;

  /// No description provided for @infoImprintTitle.
  ///
  /// In de, this message translates to:
  /// **'Impressum'**
  String get infoImprintTitle;

  /// No description provided for @infoImprintBody.
  ///
  /// In de, this message translates to:
  /// **'Angaben gemäß § 5 DDG\n\nTim Kremers\nResinovo\nIn Venrath 17B\n41812 Erkelenz\nDeutschland\n\n# Kontakt\n\nTelefon: +49 176 43594878\nE-Mail: kontakt@resinovo.de\nWebsite: resinovo.de\n\n# Rechtsform\n\nEinzelunternehmen\n\n# Umsatzsteuer-ID\n\nUmsatzsteuer-Identifikationsnummer gemäß § 27a UStG: DE462344595\n\n# Verantwortlich für den Inhalt\n\nTim Kremers (Anschrift wie oben), auch im Sinne von § 18 Abs. 2 MStV.\n\n# Verbraucherstreitbeilegung\n\nWir sind nicht verpflichtet und nicht bereit, an Streitbeilegungsverfahren vor einer Verbraucherschlichtungsstelle teilzunehmen. Die Plattform der Europäischen Kommission zur Online-Streitbeilegung wurde zum 20. Juli 2025 eingestellt.\n\n# Barrierefreiheit\n\nResinovo ist ein Kleinstunternehmen im Sinne des Barrierefreiheitsstärkungsgesetzes und daher nach § 3 Abs. 3 BFSG von dessen Anforderungen ausgenommen. Wir bemühen uns dennoch um eine barrierearme App (Systemschriftgrößen, helles und dunkles Design, Screenreader-Beschriftungen). Hinweise auf Barrieren nehmen wir gern unter kontakt@resinovo.de entgegen.\n\n# Haftung für Inhalte\n\nAls Diensteanbieter sind wir für eigene Inhalte in dieser App nach den allgemeinen Gesetzen verantwortlich. Die Inhalte wurden mit Sorgfalt erstellt; Schichtpläne und Auswertungen sind Hilfsmittel zur Planung und ersetzen nicht die Angaben des Arbeitgebers.\n\n# Urheberrecht\n\nDie vom Anbieter erstellten Inhalte und Werke in dieser App unterliegen dem deutschen Urheberrecht. Vervielfältigung, Bearbeitung, Verbreitung und jede Art der Verwertung außerhalb der Grenzen des Urheberrechts bedürfen der schriftlichen Zustimmung. Marken- und Produktnamen Dritter werden nur zur Beschreibung verwendet und sind Eigentum der jeweiligen Inhaber.\n\n„Rytmavo“ ist ein vorläufiger Arbeitsname.'**
  String get infoImprintBody;

  /// No description provided for @infoSupportTitle.
  ///
  /// In de, this message translates to:
  /// **'Support'**
  String get infoSupportTitle;

  /// No description provided for @infoSupportBody.
  ///
  /// In de, this message translates to:
  /// **'Bei Fragen oder Problemen erreichst du uns unter:\n\nE-Mail: kontakt@resinovo.de\nWebsite: resinovo.de\n\n# Hilfreich bei einer Anfrage\n\nApp-Version: {version}\n\nBeschreibe, was du getan hast und was stattdessen passiert ist. Bitte sende keine Sicherungsdatei mit, wenn du die Daten darin nicht teilen möchtest.\n\n# Daten sichern\n\nEine Sicherung erstellst du jederzeit unter Einstellungen → Daten → Daten exportieren.'**
  String infoSupportBody(String version);

  /// No description provided for @settingsSectionCalendar.
  ///
  /// In de, this message translates to:
  /// **'Gerätekalender'**
  String get settingsSectionCalendar;

  /// No description provided for @calendarSyncToggle.
  ///
  /// In de, this message translates to:
  /// **'Kalendertermine anzeigen'**
  String get calendarSyncToggle;

  /// No description provided for @calendarSyncOn.
  ///
  /// In de, this message translates to:
  /// **'An – Termine erscheinen im Kalender, Überschneidungen mit Schichten werden markiert.'**
  String get calendarSyncOn;

  /// No description provided for @calendarSyncOff.
  ///
  /// In de, this message translates to:
  /// **'Aus – Rytmavo liest keine Termine.'**
  String get calendarSyncOff;

  /// No description provided for @calendarSyncDenied.
  ///
  /// In de, this message translates to:
  /// **'Kein Zugriff auf den Kalender. Erlaube ihn für Rytmavo in den Systemeinstellungen.'**
  String get calendarSyncDenied;

  /// No description provided for @calendarSyncOpenSettings.
  ///
  /// In de, this message translates to:
  /// **'Systemeinstellungen öffnen'**
  String get calendarSyncOpenSettings;

  /// No description provided for @calendarSyncCalendars.
  ///
  /// In de, this message translates to:
  /// **'Kalender'**
  String get calendarSyncCalendars;

  /// No description provided for @calendarSyncAllCalendars.
  ///
  /// In de, this message translates to:
  /// **'Alle Kalender'**
  String get calendarSyncAllCalendars;

  /// No description provided for @calendarSyncSomeCalendars.
  ///
  /// In de, this message translates to:
  /// **'{count} von {total} Kalendern'**
  String calendarSyncSomeCalendars(int count, int total);

  /// No description provided for @calendarSyncPickTitle.
  ///
  /// In de, this message translates to:
  /// **'Kalender auswählen'**
  String get calendarSyncPickTitle;

  /// No description provided for @calendarSyncPickApply.
  ///
  /// In de, this message translates to:
  /// **'Übernehmen'**
  String get calendarSyncPickApply;

  /// No description provided for @calendarSyncNoCalendars.
  ///
  /// In de, this message translates to:
  /// **'Keine Kalender auf diesem Gerät gefunden.'**
  String get calendarSyncNoCalendars;

  /// No description provided for @calendarSyncReminder.
  ///
  /// In de, this message translates to:
  /// **'Am Vorabend erinnern'**
  String get calendarSyncReminder;

  /// No description provided for @calendarSyncReminderOn.
  ///
  /// In de, this message translates to:
  /// **'Mitteilung um 18:00 Uhr am Tag vor der Schicht.'**
  String get calendarSyncReminderOn;

  /// No description provided for @calendarSyncReminderNeedsReminders.
  ///
  /// In de, this message translates to:
  /// **'Schalte dafür zuerst die Erinnerungen ein.'**
  String get calendarSyncReminderNeedsReminders;

  /// No description provided for @calendarSyncHint.
  ///
  /// In de, this message translates to:
  /// **'Rytmavo liest Termine nur auf diesem Gerät, ändert nichts daran und speichert sie nicht. Ganztägige Termine werden angezeigt, zählen aber nicht als Konflikt.'**
  String get calendarSyncHint;

  /// No description provided for @conflictsTitle.
  ///
  /// In de, this message translates to:
  /// **'Terminkonflikte'**
  String get conflictsTitle;

  /// No description provided for @conflictDuringShift.
  ///
  /// In de, this message translates to:
  /// **'{time} · während {shiftName}'**
  String conflictDuringShift(String time, String shiftName);

  /// No description provided for @conflictUntitled.
  ///
  /// In de, this message translates to:
  /// **'Termin ohne Titel'**
  String get conflictUntitled;

  /// No description provided for @reminderConflictTitle.
  ///
  /// In de, this message translates to:
  /// **'Morgen: Termin während {shiftName}'**
  String reminderConflictTitle(String shiftName);

  /// No description provided for @reminderConflictBodyOne.
  ///
  /// In de, this message translates to:
  /// **'„{title}“ ({time}) überschneidet sich mit deiner Schicht ({shiftTime}).'**
  String reminderConflictBodyOne(String title, String time, String shiftTime);

  /// No description provided for @reminderConflictBodyMany.
  ///
  /// In de, this message translates to:
  /// **'{count} Termine überschneiden sich mit deiner Schicht ({shiftTime}).'**
  String reminderConflictBodyMany(int count, String shiftTime);

  /// No description provided for @calendarHasEvents.
  ///
  /// In de, this message translates to:
  /// **'Termine'**
  String get calendarHasEvents;

  /// No description provided for @daySheetEvents.
  ///
  /// In de, this message translates to:
  /// **'Termine'**
  String get daySheetEvents;

  /// No description provided for @eventAllDay.
  ///
  /// In de, this message translates to:
  /// **'Ganztägig'**
  String get eventAllDay;

  /// No description provided for @holidayNewYear.
  ///
  /// In de, this message translates to:
  /// **'Neujahr'**
  String get holidayNewYear;

  /// No description provided for @holidayEpiphany.
  ///
  /// In de, this message translates to:
  /// **'Heilige Drei Könige'**
  String get holidayEpiphany;

  /// No description provided for @holidayWomensDay.
  ///
  /// In de, this message translates to:
  /// **'Internationaler Frauentag'**
  String get holidayWomensDay;

  /// No description provided for @holidayGoodFriday.
  ///
  /// In de, this message translates to:
  /// **'Karfreitag'**
  String get holidayGoodFriday;

  /// No description provided for @holidayEasterSunday.
  ///
  /// In de, this message translates to:
  /// **'Ostersonntag'**
  String get holidayEasterSunday;

  /// No description provided for @holidayEasterMonday.
  ///
  /// In de, this message translates to:
  /// **'Ostermontag'**
  String get holidayEasterMonday;

  /// No description provided for @holidayLabourDay.
  ///
  /// In de, this message translates to:
  /// **'Tag der Arbeit'**
  String get holidayLabourDay;

  /// No description provided for @holidayLiberationDay.
  ///
  /// In de, this message translates to:
  /// **'Tag der Befreiung'**
  String get holidayLiberationDay;

  /// No description provided for @holidayAscension.
  ///
  /// In de, this message translates to:
  /// **'Christi Himmelfahrt'**
  String get holidayAscension;

  /// No description provided for @holidayWhitSunday.
  ///
  /// In de, this message translates to:
  /// **'Pfingstsonntag'**
  String get holidayWhitSunday;

  /// No description provided for @holidayWhitMonday.
  ///
  /// In de, this message translates to:
  /// **'Pfingstmontag'**
  String get holidayWhitMonday;

  /// No description provided for @holidayCorpusChristi.
  ///
  /// In de, this message translates to:
  /// **'Fronleichnam'**
  String get holidayCorpusChristi;

  /// No description provided for @holidayAssumption.
  ///
  /// In de, this message translates to:
  /// **'Mariä Himmelfahrt'**
  String get holidayAssumption;

  /// No description provided for @holidayChildrensDay.
  ///
  /// In de, this message translates to:
  /// **'Weltkindertag'**
  String get holidayChildrensDay;

  /// No description provided for @holidayGermanUnity.
  ///
  /// In de, this message translates to:
  /// **'Tag der Deutschen Einheit'**
  String get holidayGermanUnity;

  /// No description provided for @holidayReformation.
  ///
  /// In de, this message translates to:
  /// **'Reformationstag'**
  String get holidayReformation;

  /// No description provided for @holidayAllSaints.
  ///
  /// In de, this message translates to:
  /// **'Allerheiligen'**
  String get holidayAllSaints;

  /// No description provided for @holidayRepentance.
  ///
  /// In de, this message translates to:
  /// **'Buß- und Bettag'**
  String get holidayRepentance;

  /// No description provided for @holidayChristmas.
  ///
  /// In de, this message translates to:
  /// **'1. Weihnachtstag'**
  String get holidayChristmas;

  /// No description provided for @holidayBoxingDay.
  ///
  /// In de, this message translates to:
  /// **'2. Weihnachtstag'**
  String get holidayBoxingDay;

  /// No description provided for @schoolHolidayWinter.
  ///
  /// In de, this message translates to:
  /// **'Winterferien'**
  String get schoolHolidayWinter;

  /// No description provided for @schoolHolidayMidYear.
  ///
  /// In de, this message translates to:
  /// **'Halbjahresferien'**
  String get schoolHolidayMidYear;

  /// No description provided for @schoolHolidayCarnival.
  ///
  /// In de, this message translates to:
  /// **'Fastnachtsferien'**
  String get schoolHolidayCarnival;

  /// No description provided for @schoolHolidaySpring.
  ///
  /// In de, this message translates to:
  /// **'Frühjahrsferien'**
  String get schoolHolidaySpring;

  /// No description provided for @schoolHolidayEaster.
  ///
  /// In de, this message translates to:
  /// **'Osterferien'**
  String get schoolHolidayEaster;

  /// No description provided for @schoolHolidayWhitsun.
  ///
  /// In de, this message translates to:
  /// **'Pfingstferien'**
  String get schoolHolidayWhitsun;

  /// No description provided for @schoolHolidaySummer.
  ///
  /// In de, this message translates to:
  /// **'Sommerferien'**
  String get schoolHolidaySummer;

  /// No description provided for @schoolHolidayAutumn.
  ///
  /// In de, this message translates to:
  /// **'Herbstferien'**
  String get schoolHolidayAutumn;

  /// No description provided for @schoolHolidayChristmas.
  ///
  /// In de, this message translates to:
  /// **'Weihnachtsferien'**
  String get schoolHolidayChristmas;

  /// No description provided for @schoolHolidayDayOff.
  ///
  /// In de, this message translates to:
  /// **'Schulfreier Tag'**
  String get schoolHolidayDayOff;

  /// No description provided for @stateBw.
  ///
  /// In de, this message translates to:
  /// **'Baden-Württemberg'**
  String get stateBw;

  /// No description provided for @stateBy.
  ///
  /// In de, this message translates to:
  /// **'Bayern'**
  String get stateBy;

  /// No description provided for @stateBe.
  ///
  /// In de, this message translates to:
  /// **'Berlin'**
  String get stateBe;

  /// No description provided for @stateBb.
  ///
  /// In de, this message translates to:
  /// **'Brandenburg'**
  String get stateBb;

  /// No description provided for @stateHb.
  ///
  /// In de, this message translates to:
  /// **'Bremen'**
  String get stateHb;

  /// No description provided for @stateHh.
  ///
  /// In de, this message translates to:
  /// **'Hamburg'**
  String get stateHh;

  /// No description provided for @stateHe.
  ///
  /// In de, this message translates to:
  /// **'Hessen'**
  String get stateHe;

  /// No description provided for @stateMv.
  ///
  /// In de, this message translates to:
  /// **'Mecklenburg-Vorpommern'**
  String get stateMv;

  /// No description provided for @stateNi.
  ///
  /// In de, this message translates to:
  /// **'Niedersachsen'**
  String get stateNi;

  /// No description provided for @stateNw.
  ///
  /// In de, this message translates to:
  /// **'Nordrhein-Westfalen'**
  String get stateNw;

  /// No description provided for @stateRp.
  ///
  /// In de, this message translates to:
  /// **'Rheinland-Pfalz'**
  String get stateRp;

  /// No description provided for @stateSl.
  ///
  /// In de, this message translates to:
  /// **'Saarland'**
  String get stateSl;

  /// No description provided for @stateSn.
  ///
  /// In de, this message translates to:
  /// **'Sachsen'**
  String get stateSn;

  /// No description provided for @stateSt.
  ///
  /// In de, this message translates to:
  /// **'Sachsen-Anhalt'**
  String get stateSt;

  /// No description provided for @stateSh.
  ///
  /// In de, this message translates to:
  /// **'Schleswig-Holstein'**
  String get stateSh;

  /// No description provided for @stateTh.
  ///
  /// In de, this message translates to:
  /// **'Thüringen'**
  String get stateTh;

  /// No description provided for @holidaysTitle.
  ///
  /// In de, this message translates to:
  /// **'Feiertage & Ferien'**
  String get holidaysTitle;

  /// No description provided for @holidaysNationwideOnly.
  ///
  /// In de, this message translates to:
  /// **'Nur bundesweite Feiertage'**
  String get holidaysNationwideOnly;

  /// No description provided for @holidaysIntro.
  ///
  /// In de, this message translates to:
  /// **'Bundesweite Feiertage wie Neujahr, Ostern oder der 3. Oktober sind immer markiert. Mit deinem Bundesland kommen regionale Feiertage und auf Wunsch die Schulferien dazu.'**
  String get holidaysIntro;

  /// No description provided for @holidaysStateLabel.
  ///
  /// In de, this message translates to:
  /// **'Bundesland'**
  String get holidaysStateLabel;

  /// No description provided for @holidaysSchoolToggle.
  ///
  /// In de, this message translates to:
  /// **'Schulferien markieren'**
  String get holidaysSchoolToggle;

  /// No description provided for @holidaysSchoolToggleBody.
  ///
  /// In de, this message translates to:
  /// **'Ferien der allgemeinbildenden Schulen als farbiges Band unter den Tagen.'**
  String get holidaysSchoolToggleBody;

  /// No description provided for @holidaysSchoolNeedsState.
  ///
  /// In de, this message translates to:
  /// **'Dafür zuerst ein Bundesland wählen.'**
  String get holidaysSchoolNeedsState;

  /// No description provided for @holidaysDaysOffToggle.
  ///
  /// In de, this message translates to:
  /// **'An Feiertagen frei'**
  String get holidaysDaysOffToggle;

  /// No description provided for @holidaysDaysOffBody.
  ///
  /// In de, this message translates to:
  /// **'Gesetzliche Feiertage ersetzen Schichten aus deinem Rhythmus durch „Frei“. Musst du doch arbeiten, änderst du den Tag im Kalender.'**
  String get holidaysDaysOffBody;

  /// No description provided for @holidaysSave.
  ///
  /// In de, this message translates to:
  /// **'Speichern'**
  String get holidaysSave;

  /// No description provided for @holidaysSaved.
  ///
  /// In de, this message translates to:
  /// **'Feiertage & Ferien gespeichert'**
  String get holidaysSaved;

  /// No description provided for @holidaysSchoolDataUntil.
  ///
  /// In de, this message translates to:
  /// **'Schulferien bekannt bis {date}.'**
  String holidaysSchoolDataUntil(String date);

  /// No description provided for @holidaysSource.
  ///
  /// In de, this message translates to:
  /// **'Feiertage berechnet die App selbst. Schulferien stammen aus dem OpenHolidays-Projekt (openholidaysapi.org, Datenlizenz ODbL 1.0) und werden mit App-Updates ergänzt. Angaben ohne Gewähr. Feiertage einzelner Gemeinden (z. B. Mariä Himmelfahrt in Teilen Bayerns) sind nicht enthalten.'**
  String get holidaysSource;

  /// No description provided for @holidaysPromptTitle.
  ///
  /// In de, this message translates to:
  /// **'Feiertage und Ferien markieren?'**
  String get holidaysPromptTitle;

  /// No description provided for @holidaysPromptBody.
  ///
  /// In de, this message translates to:
  /// **'Wähle dein Bundesland, dann zeigt der Kalender auch regionale Feiertage und Schulferien.'**
  String get holidaysPromptBody;

  /// No description provided for @holidaysPromptAction.
  ///
  /// In de, this message translates to:
  /// **'Auswählen'**
  String get holidaysPromptAction;

  /// No description provided for @holidaysPromptDismiss.
  ///
  /// In de, this message translates to:
  /// **'Nicht jetzt'**
  String get holidaysPromptDismiss;

  /// No description provided for @calendarHoliday.
  ///
  /// In de, this message translates to:
  /// **'Feiertag'**
  String get calendarHoliday;

  /// No description provided for @calendarSchoolHoliday.
  ///
  /// In de, this message translates to:
  /// **'Schulferien'**
  String get calendarSchoolHoliday;

  /// No description provided for @calendarHolidayOff.
  ///
  /// In de, this message translates to:
  /// **'Feiertag, frei'**
  String get calendarHolidayOff;

  /// No description provided for @holidayOffFrom.
  ///
  /// In de, this message translates to:
  /// **'Feiertag frei · laut Rhythmus {shiftName}'**
  String holidayOffFrom(String shiftName);
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
