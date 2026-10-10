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
