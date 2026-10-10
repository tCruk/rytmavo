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
}
