// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Rytmavo';

  @override
  String get navToday => 'Heute';

  @override
  String get navCalendar => 'Kalender';

  @override
  String get navHabits => 'Gewohnheiten';

  @override
  String get navStats => 'Auswertung';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get settingsOpen => 'Einstellungen öffnen';

  @override
  String get commonOk => 'OK';

  @override
  String get commonCancel => 'Abbrechen';

  @override
  String get commonSave => 'Speichern';

  @override
  String get commonDelete => 'Löschen';

  @override
  String get commonUndo => 'Rückgängig';

  @override
  String get commonRetry => 'Erneut versuchen';

  @override
  String get commonClose => 'Schließen';

  @override
  String get commonBack => 'Zurück';

  @override
  String get commonNext => 'Weiter';

  @override
  String get commonDone => 'Fertig';

  @override
  String get commonEdit => 'Bearbeiten';

  @override
  String get commonAdd => 'Hinzufügen';

  @override
  String get commonLoading => 'Wird geladen …';

  @override
  String get errorGenericTitle => 'Etwas ist schiefgelaufen';

  @override
  String get errorGenericBody =>
      'Die Daten konnten nicht geladen werden. Bitte versuche es erneut.';

  @override
  String get todayTitle => 'Heute';

  @override
  String get todayEmptyTitle => 'Noch kein Schichtplan';

  @override
  String get todayEmptyBody =>
      'Richte dein Schichtsystem ein, damit Rytmavo deine Schichten und Gewohnheiten anzeigen kann.';

  @override
  String get todaySetupAction => 'Schichtsystem einrichten';

  @override
  String get calendarTitle => 'Kalender';

  @override
  String get calendarJumpToToday => 'Zu heute springen';

  @override
  String get habitsTitle => 'Gewohnheiten';

  @override
  String get habitsEmptyTitle => 'Noch keine Gewohnheiten';

  @override
  String get habitsEmptyBody =>
      'Lege Gewohnheiten an, die zu deinen Schichten passen – zum Beispiel „Nach der Nachtschicht 20 Minuten spazieren“.';

  @override
  String get habitsAddAction => 'Gewohnheit anlegen';

  @override
  String get statsTitle => 'Auswertung';

  @override
  String get statsEmptyTitle => 'Noch keine Auswertung';

  @override
  String get statsEmptyBody =>
      'Sobald du Gewohnheiten abhakst, siehst du hier deine Erfolgsquote über geplante Tage.';

  @override
  String get shiftEarly => 'Früh';

  @override
  String get shiftLate => 'Spät';

  @override
  String get shiftNight => 'Nacht';

  @override
  String get shiftOff => 'Frei';

  @override
  String get shiftEarlyShort => 'F';

  @override
  String get shiftLateShort => 'S';

  @override
  String get shiftNightShort => 'N';

  @override
  String get shiftOffShort => '–';

  @override
  String get settingsSectionAppearance => 'Darstellung';

  @override
  String get settingsLanguage => 'Sprache';

  @override
  String get settingsLanguageSystem => 'Systemsprache';

  @override
  String get settingsLanguageGerman => 'Deutsch';

  @override
  String get settingsLanguageEnglish => 'Englisch';

  @override
  String get settingsTheme => 'Erscheinungsbild';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsThemeLight => 'Hell';

  @override
  String get settingsThemeDark => 'Dunkel';

  @override
  String get settingsSectionReminders => 'Erinnerungen';

  @override
  String get settingsRemindersStatus => 'Status der Erinnerungen';

  @override
  String get settingsRemindersOff => 'Aus – Erinnerungen sind nicht aktiviert.';

  @override
  String get settingsSectionData => 'Daten';

  @override
  String get settingsExport => 'Daten exportieren';

  @override
  String get settingsImport => 'Daten importieren';

  @override
  String get settingsDeleteData => 'Lokale Daten löschen';

  @override
  String get settingsSectionAbout => 'Über die App';

  @override
  String get settingsPrivacy => 'Datenschutz';

  @override
  String get settingsImprint => 'Impressum';

  @override
  String get settingsSupport => 'Support';

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsComingSoon => 'In einer späteren Phase verfügbar.';

  @override
  String a11yShiftBadge(String shiftName) {
    return 'Schicht: $shiftName';
  }

  @override
  String get onboardingTitle => 'Schichtsystem einrichten';

  @override
  String get onboardingEditTitle => 'Schichtsystem ändern';

  @override
  String onboardingStepOf(int current, int total) {
    return 'Schritt $current von $total';
  }

  @override
  String get onboardingPresetTitle => 'Wie arbeitest du?';

  @override
  String get onboardingPresetBody =>
      'Wähle eine Vorlage. Im nächsten Schritt kannst du jeden Tag einzeln anpassen.';

  @override
  String get presetWeekly3Name => '3-Schicht, wöchentlich';

  @override
  String get presetWeekly3Desc =>
      '5 Früh · 2 frei · 5 Spät · 2 frei · 5 Nacht · 2 frei';

  @override
  String get presetWeekly2Name => '2-Schicht, wöchentlich';

  @override
  String get presetWeekly2Desc => '5 Früh · 2 frei · 5 Spät · 2 frei';

  @override
  String get presetConti4Name => 'Konti, 4 Gruppen';

  @override
  String get presetConti4Desc => '2 Früh · 2 Spät · 2 Nacht · 2 frei';

  @override
  String get presetConti5Name => 'Konti, 5 Gruppen';

  @override
  String get presetConti5Desc => '2 Früh · 2 Spät · 2 Nacht · 4 frei';

  @override
  String get presetCustomName => 'Eigener Rhythmus';

  @override
  String get presetCustomDesc => 'Baue deinen Zyklus selbst, Tag für Tag.';

  @override
  String get presetCurrentName => 'Aktueller Rhythmus';

  @override
  String get presetCurrentDesc => 'Deinen bestehenden Zyklus weiter anpassen.';

  @override
  String cycleLength(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Tage',
      one: '1 Tag',
    );
    return '$_temp0';
  }

  @override
  String get onboardingRhythmTitle => 'Dein Rhythmus';

  @override
  String get onboardingRhythmBody =>
      'Tippe auf einen Tag, um die Schicht zu wechseln.';

  @override
  String onboardingDayN(int number) {
    return 'Tag $number';
  }

  @override
  String get onboardingAddDay => 'Tag hinzufügen';

  @override
  String get onboardingRemoveDay => 'Letzten Tag entfernen';

  @override
  String get onboardingTodayTitle => 'Welcher Tag ist heute?';

  @override
  String get onboardingTodayBody =>
      'Wähle, an welcher Stelle deines Zyklus du heute stehst. Daraus berechnet Rytmavo alle anderen Tage.';

  @override
  String get onboardingPreview => 'Vorschau';

  @override
  String get onboardingTimesTitle => 'Schichtzeiten';

  @override
  String get onboardingTimesBody =>
      'Die Zeiten erscheinen in der Tagesansicht und im Kalender.';

  @override
  String get onboardingNightHint =>
      'Eine Nachtschicht zählt zu dem Tag, an dem sie beginnt.';

  @override
  String get onboardingEditHint =>
      'Änderungen gelten ab heute. Vergangene Tage bleiben, wie sie waren.';

  @override
  String get onboardingSaveError =>
      'Speichern fehlgeschlagen. Bitte versuche es erneut.';

  @override
  String get shiftStart => 'Beginn';

  @override
  String get shiftEnd => 'Ende';

  @override
  String shiftTimeRange(String start, String end) {
    return '$start–$end';
  }

  @override
  String get shiftEndsNextDay => 'endet am Folgetag';

  @override
  String get todayNextDays => 'Nächste Tage';

  @override
  String todayOverriddenFrom(String shiftName) {
    return 'Geändert · laut Rhythmus $shiftName';
  }

  @override
  String get todayNoEntry => 'Kein Eintrag';

  @override
  String get todayDayOffBody => 'Heute hast du frei.';

  @override
  String todayNextShift(String shiftName, String date) {
    return 'Nächste Schicht: $shiftName, $date';
  }

  @override
  String get calendarPrevMonth => 'Vorheriger Monat';

  @override
  String get calendarNextMonth => 'Nächster Monat';

  @override
  String get calendarChanged => 'geändert';

  @override
  String calendarDayA11y(String date, String shiftName) {
    return '$date, $shiftName';
  }

  @override
  String daySheetRotation(String shiftName) {
    return 'Laut Rhythmus: $shiftName';
  }

  @override
  String get daySheetChange => 'Schicht für diesen Tag';

  @override
  String get daySheetReset => 'Rhythmus wiederherstellen';

  @override
  String daySheetSaved(String date) {
    return 'Schicht für $date geändert';
  }

  @override
  String daySheetResetDone(String date) {
    return 'Rhythmus für $date wiederhergestellt';
  }

  @override
  String get settingsSectionShifts => 'Schichtsystem';

  @override
  String get settingsEditShifts => 'Rhythmus und Zeiten ändern';

  @override
  String get settingsShiftsNotSet => 'Noch nicht eingerichtet';
}
