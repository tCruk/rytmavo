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
  String get shiftsEditAction => 'Schichtmodell bearbeiten';

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
  String get settingsExportSubtitle =>
      'Alle Daten als unverschlüsselte JSON-Datei teilen oder sichern.';

  @override
  String get settingsImportSubtitle =>
      'Sicherung wiederherstellen. Ersetzt alle aktuellen Daten.';

  @override
  String get settingsDeleteDataSubtitle =>
      'Entfernt alle Schichten, Gewohnheiten und Einstellungen von diesem Gerät.';

  @override
  String get backupExportFailed =>
      'Export fehlgeschlagen. Bitte versuche es erneut.';

  @override
  String get backupImportTitle => 'Sicherung importieren?';

  @override
  String backupImportMessage(String date, int habits, int shiftTypes) {
    return 'Die Sicherung vom $date enthält $habits Gewohnheiten und $shiftTypes Schichtarten. Alle aktuellen Daten werden ersetzt.';
  }

  @override
  String get backupImportConfirm => 'Importieren';

  @override
  String get backupImportDone => 'Sicherung wiederhergestellt.';

  @override
  String get backupImportInvalid =>
      'Die Datei ist keine gültige Rytmavo-Sicherung.';

  @override
  String get backupImportFailed =>
      'Import fehlgeschlagen. Deine Daten wurden nicht verändert.';

  @override
  String get backupDeleteTitle => 'Alle lokalen Daten löschen?';

  @override
  String get backupDeleteMessage =>
      'Schichten, Gewohnheiten, Erledigungen und Einstellungen werden unwiderruflich gelöscht. Exportiere vorher eine Sicherung, wenn du die Daten behalten möchtest.';

  @override
  String get backupDeleteDone => 'Alle lokalen Daten wurden gelöscht.';

  @override
  String get backupDeleteFailed => 'Löschen fehlgeschlagen.';

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

  @override
  String get habitNewTitle => 'Neue Gewohnheit';

  @override
  String get habitEditTitle => 'Gewohnheit bearbeiten';

  @override
  String get habitName => 'Name';

  @override
  String get habitNameHint => 'z. B. 20 Minuten spazieren';

  @override
  String get habitNameRequired => 'Bitte gib einen Namen ein.';

  @override
  String get habitDescription => 'Notiz (optional)';

  @override
  String get habitIcon => 'Symbol';

  @override
  String get habitColor => 'Farbe';

  @override
  String get habitDueOn => 'Fällig an';

  @override
  String get habitDueEveryDay => 'Jeden Tag';

  @override
  String get habitDueOnShifts => 'Nur an bestimmten Schichten';

  @override
  String get habitWeekdays => 'Nur an Wochentagen (optional)';

  @override
  String get habitWeekdaysAny => 'Alle Wochentage';

  @override
  String get habitRuleHint =>
      'Änderungen an der Fälligkeit gelten ab heute. Vergangene Tage werden nicht neu bewertet.';

  @override
  String get habitArchive => 'Archivieren';

  @override
  String get habitArchiveBody =>
      'Die Gewohnheit verschwindet aus der Liste. Ihre Historie bleibt in der Auswertung erhalten.';

  @override
  String get habitArchived => 'Gewohnheit archiviert';

  @override
  String get habitDelete => 'Endgültig löschen';

  @override
  String get habitDeleteBody =>
      'Alle Erledigungen dieser Gewohnheit werden gelöscht. Das lässt sich nicht rückgängig machen.';

  @override
  String get habitDeleted => 'Gewohnheit gelöscht';

  @override
  String get habitSaved => 'Gewohnheit gespeichert';

  @override
  String get habitShowArchived => 'Archivierte anzeigen';

  @override
  String get habitRestore => 'Wiederherstellen';

  @override
  String get habitDueSummaryEveryDay => 'Jeden Tag';

  @override
  String habitDueSummaryShifts(String shifts) {
    return 'An: $shifts';
  }

  @override
  String get habitReorder => 'Reihenfolge ändern';

  @override
  String get todayHabitsSection => 'Gewohnheiten heute';

  @override
  String get todayHabitsNone => 'Heute ist keine Gewohnheit fällig.';

  @override
  String todayHabitsProgress(int done, int total) {
    return '$done von $total erledigt';
  }

  @override
  String todayHabitDone(String name) {
    return '$name erledigt';
  }

  @override
  String todayHabitUndone(String name) {
    return '$name wieder offen';
  }

  @override
  String a11yHabitToggle(String name, String state) {
    return '$name, $state';
  }

  @override
  String get a11yStateDone => 'erledigt';

  @override
  String get a11yStateOpen => 'offen';

  @override
  String get statsPeriod7 => '7 Tage';

  @override
  String get statsPeriod30 => '30 Tage';

  @override
  String get statsPeriod90 => '90 Tage';

  @override
  String get statsOverall => 'Gesamt';

  @override
  String get statsRate => 'Erfolgsquote';

  @override
  String statsDueDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fällige Tage',
      one: '1 fälliger Tag',
    );
    return '$_temp0';
  }

  @override
  String statsCompleted(int done, int total) {
    return '$done von $total';
  }

  @override
  String get statsNotDue => 'In diesem Zeitraum nicht fällig';

  @override
  String get statsStreak => 'Aktuelle Serie';

  @override
  String get statsBestStreak => 'Beste Serie';

  @override
  String statsStreakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Tage',
      one: '1 Tag',
    );
    return '$_temp0';
  }

  @override
  String get statsByShift => 'Nach Schicht';

  @override
  String statsPercent(int value) {
    return '$value %';
  }

  @override
  String get reminderBodyPlain => 'Heute fällig.';

  @override
  String reminderBodyWithShift(String shiftName) {
    return 'Heute fällig ($shiftName).';
  }

  @override
  String get settingsRemindersToggle => 'Erinnerungen';

  @override
  String get settingsRemindersOn =>
      'An – du wirst an fällige Gewohnheiten erinnert.';

  @override
  String get settingsRemindersDenied =>
      'Berechtigung verweigert. Aktiviere Mitteilungen für Rytmavo in den Systemeinstellungen.';

  @override
  String get settingsRemindersHint =>
      'Erinnerungen werden pro Gewohnheit eingestellt. Android stellt sie nicht sekundengenau zu, um Akku zu sparen.';

  @override
  String get habitReminder => 'Erinnerung';

  @override
  String get habitReminderOff => 'Keine Erinnerung';

  @override
  String get habitReminderAt => 'Erinnern um';

  @override
  String get habitReminderPerShift => 'Zeit je Schicht';

  @override
  String get habitReminderGlobalOff =>
      'Erinnerungen sind in den Einstellungen ausgeschaltet.';

  @override
  String get settingsVersionUnknown => 'Unbekannt';

  @override
  String get infoPrivacyTitle => 'Datenschutz';

  @override
  String get infoPrivacyBody =>
      'Stand: Oktober 2026\n\n# 1. Verantwortlicher\n\nVerantwortlicher im Sinne der Datenschutz-Grundverordnung (DSGVO) ist:\n\nTim Kremers\nResinovo\nIn Venrath 17B\n41812 Erkelenz\nDeutschland\n\nTelefon: +49 176 43594878\nE-Mail: kontakt@resinovo.de\n\n# 2. Datenschutzbeauftragter\n\nEin Datenschutzbeauftragter ist nicht bestellt, da die gesetzlichen Voraussetzungen hierfür nicht vorliegen.\n\n# 3. Das Wichtigste in Kürze\n\nRytmavo funktioniert vollständig offline. Es gibt kein Benutzerkonto, keine Werbung, kein Tracking und keine Server des Anbieters. Alle Daten bleiben auf deinem Gerät. Daten verlassen das Gerät nur, wenn du selbst eine Sicherung exportierst oder teilst.\n\n# 4. Lokale Datenverarbeitung auf dem Gerät\n\nDie App speichert folgende Daten ausschließlich lokal auf deinem Gerät im App-Speicher: Schichtarten mit Zeiten und Farben, Rotationsmuster und Ankerdatum, Tagesänderungen, Gewohnheiten mit Regeln und Erinnerungszeiten, Erledigungen je Tag sowie App-Einstellungen (Sprache, Design, Erinnerungsstatus). Diese Daten werden nicht an den Anbieter übertragen. Du kannst sie in der App einzeln löschen, unter Einstellungen → Daten vollständig löschen oder die App deinstallieren. Ob Gerätesicherungen (z. B. iCloud, Google-Backup) diese Daten enthalten, richtet sich nach deinem Gerät und den Regeln von Apple bzw. Google.\n\nRechtsgrundlage: Art. 6 Abs. 1 lit. b DSGVO (Bereitstellung der App-Funktionen).\n\n# 5. Erinnerungen (Mitteilungen)\n\nAuf Wunsch plant die App lokale Erinnerungen über das Benachrichtigungssystem deines Geräts. Dafür fragt sie einmalig nach der Berechtigung für Mitteilungen. Es werden keine Push-Dienste und keine Server genutzt; die Erinnerungen entstehen und bleiben auf dem Gerät. Du kannst sie jederzeit in den Einstellungen der App oder des Geräts abschalten.\n\n# 6. Gerätekalender (optional)\n\nNur wenn du unter Einstellungen → Gerätekalender „Kalendertermine anzeigen“ einschaltest, fragt die App nach Zugriff auf den Kalender deines Geräts. Sie liest dann Titel und Zeiten der Termine aus den von dir gewählten Kalendern, um sie in der Kalenderansicht anzuzeigen, Überschneidungen mit deinen Schichten zu markieren und dich auf Wunsch am Vorabend zu erinnern. Die Termine werden nur auf dem Gerät ausgewertet, nicht verändert, nicht in der App gespeichert und nicht übertragen. Den Zugriff kannst du jederzeit in der App ausschalten oder in den Systemeinstellungen widerrufen.\n\nRechtsgrundlage: Art. 6 Abs. 1 lit. a DSGVO (deine Einwilligung durch das Einschalten der Funktion und die Freigabe des Kalenderzugriffs).\n\n# 7. Sicherung, Import und Teilen\n\nEine Sicherung (JSON-Datei) entsteht nur auf deine Anweisung. Beim Teilen übergibt die App die Datei an das von dir gewählte Ziel (z. B. Dateien-App, E-Mail, Cloud-Speicher); ab dort gelten die Datenschutzbestimmungen des jeweiligen Anbieters. Beim Import liest die App nur die Datei, die du selbst auswählst. Der Anbieter erhält diese Dateien nicht. Die Datei ist unverschlüsselt.\n\n# 8. Kauf über die App Stores\n\nDer Kauf der App wird ausschließlich über den Apple App Store bzw. Google Play abgewickelt. Dabei verarbeiten Apple bzw. Google deine Daten als eigenständig Verantwortliche nach ihren Datenschutzbestimmungen. Der Anbieter erhält keine personenbezogenen Kaufdaten.\n\n# 9. Keine Verarbeitung auf Servern des Anbieters\n\nAlle Funktionen laufen auf dem Gerät. Sollten künftig serverbasierte Funktionen hinzukommen, wird diese Datenschutzerklärung vorher angepasst und in der App angezeigt.\n\n# 10. Empfänger und Drittlandübermittlung\n\nEine Übermittlung an Dritte erfolgt nicht, außer an die von dir beim Teilen gewählten Ziele sowie an Apple bzw. Google im Rahmen des Kaufs. Eine Übermittlung in Drittländer durch den Anbieter findet nicht statt.\n\n# 11. Speicherdauer\n\nLokale Daten bleiben gespeichert, bis du sie löschst oder die App deinstallierst. E-Mail-Anfragen an den Anbieter werden gelöscht, sobald das Anliegen erledigt ist und keine gesetzlichen Aufbewahrungspflichten bestehen.\n\n# 12. Keine automatisierte Entscheidungsfindung\n\nEine automatisierte Entscheidungsfindung oder ein Profiling findet nicht statt.\n\n# 13. Minderjährige\n\nDie App richtet sich an Berufstätige. Sie ist nicht für Kinder unter 13 Jahren bestimmt; wissentlich werden keine personenbezogenen Daten von Kindern erhoben.\n\n# 14. Deine Rechte\n\nDu hast das Recht auf Auskunft (Art. 15 DSGVO), Berichtigung (Art. 16), Löschung (Art. 17), Einschränkung der Verarbeitung (Art. 18) und Datenübertragbarkeit (Art. 20) sowie das Recht, erteilte Einwilligungen mit Wirkung für die Zukunft zu widerrufen. Soweit eine Verarbeitung auf berechtigten Interessen beruht, kannst du jederzeit Widerspruch einlegen (Art. 21 DSGVO). Eine E-Mail an kontakt@resinovo.de genügt. Da die App-Daten nur auf deinem Gerät liegen, kannst du Auskunft, Export und Löschung direkt in der App selbst vornehmen.\n\n# 15. Beschwerderecht\n\nDu hast das Recht, dich bei einer Datenschutz-Aufsichtsbehörde zu beschweren. Zuständig ist die Landesbeauftragte für Datenschutz und Informationsfreiheit Nordrhein-Westfalen, Kavalleriestraße 2–4, 40213 Düsseldorf.\n\n# 16. Änderungen dieser Datenschutzerklärung\n\nDiese Erklärung wird angepasst, wenn sich die Rechtslage, die Technik oder der Funktionsumfang der App ändert. Die jeweils aktuelle Fassung findest du in der App unter Einstellungen → Datenschutz.';

  @override
  String get infoImprintTitle => 'Impressum';

  @override
  String get infoImprintBody =>
      'Angaben gemäß § 5 DDG\n\nTim Kremers\nResinovo\nIn Venrath 17B\n41812 Erkelenz\nDeutschland\n\n# Kontakt\n\nTelefon: +49 176 43594878\nE-Mail: kontakt@resinovo.de\nWebsite: resinovo.de\n\n# Rechtsform\n\nEinzelunternehmen\n\n# Umsatzsteuer-ID\n\nUmsatzsteuer-Identifikationsnummer gemäß § 27a UStG: DE462344595\n\n# Verantwortlich für den Inhalt\n\nTim Kremers (Anschrift wie oben), auch im Sinne von § 18 Abs. 2 MStV.\n\n# Verbraucherstreitbeilegung\n\nWir sind nicht verpflichtet und nicht bereit, an Streitbeilegungsverfahren vor einer Verbraucherschlichtungsstelle teilzunehmen. Die Plattform der Europäischen Kommission zur Online-Streitbeilegung wurde zum 20. Juli 2025 eingestellt.\n\n# Barrierefreiheit\n\nResinovo ist ein Kleinstunternehmen im Sinne des Barrierefreiheitsstärkungsgesetzes und daher nach § 3 Abs. 3 BFSG von dessen Anforderungen ausgenommen. Wir bemühen uns dennoch um eine barrierearme App (Systemschriftgrößen, helles und dunkles Design, Screenreader-Beschriftungen). Hinweise auf Barrieren nehmen wir gern unter kontakt@resinovo.de entgegen.\n\n# Haftung für Inhalte\n\nAls Diensteanbieter sind wir für eigene Inhalte in dieser App nach den allgemeinen Gesetzen verantwortlich. Die Inhalte wurden mit Sorgfalt erstellt; Schichtpläne und Auswertungen sind Hilfsmittel zur Planung und ersetzen nicht die Angaben des Arbeitgebers.\n\n# Urheberrecht\n\nDie vom Anbieter erstellten Inhalte und Werke in dieser App unterliegen dem deutschen Urheberrecht. Vervielfältigung, Bearbeitung, Verbreitung und jede Art der Verwertung außerhalb der Grenzen des Urheberrechts bedürfen der schriftlichen Zustimmung. Marken- und Produktnamen Dritter werden nur zur Beschreibung verwendet und sind Eigentum der jeweiligen Inhaber.\n\n„Rytmavo“ ist ein vorläufiger Arbeitsname.';

  @override
  String get infoSupportTitle => 'Support';

  @override
  String infoSupportBody(String version) {
    return 'Bei Fragen oder Problemen erreichst du uns unter:\n\nE-Mail: kontakt@resinovo.de\nWebsite: resinovo.de\n\n# Hilfreich bei einer Anfrage\n\nApp-Version: $version\n\nBeschreibe, was du getan hast und was stattdessen passiert ist. Bitte sende keine Sicherungsdatei mit, wenn du die Daten darin nicht teilen möchtest.\n\n# Daten sichern\n\nEine Sicherung erstellst du jederzeit unter Einstellungen → Daten → Daten exportieren.';
  }

  @override
  String get settingsSectionCalendar => 'Gerätekalender';

  @override
  String get calendarSyncToggle => 'Kalendertermine anzeigen';

  @override
  String get calendarSyncOn =>
      'An – Termine erscheinen im Kalender, Überschneidungen mit Schichten werden markiert.';

  @override
  String get calendarSyncOff => 'Aus – Rytmavo liest keine Termine.';

  @override
  String get calendarSyncDenied =>
      'Kein Zugriff auf den Kalender. Erlaube ihn für Rytmavo in den Systemeinstellungen.';

  @override
  String get calendarSyncOpenSettings => 'Systemeinstellungen öffnen';

  @override
  String get calendarSyncCalendars => 'Kalender';

  @override
  String get calendarSyncAllCalendars => 'Alle Kalender';

  @override
  String calendarSyncSomeCalendars(int count, int total) {
    return '$count von $total Kalendern';
  }

  @override
  String get calendarSyncPickTitle => 'Kalender auswählen';

  @override
  String get calendarSyncPickApply => 'Übernehmen';

  @override
  String get calendarSyncNoCalendars =>
      'Keine Kalender auf diesem Gerät gefunden.';

  @override
  String get calendarSyncReminder => 'Am Vorabend erinnern';

  @override
  String get calendarSyncReminderOn =>
      'Mitteilung um 18:00 Uhr am Tag vor der Schicht.';

  @override
  String get calendarSyncReminderNeedsReminders =>
      'Schalte dafür zuerst die Erinnerungen ein.';

  @override
  String get calendarSyncHint =>
      'Rytmavo liest Termine nur auf diesem Gerät, ändert nichts daran und speichert sie nicht. Ganztägige Termine werden angezeigt, zählen aber nicht als Konflikt.';

  @override
  String get conflictsTitle => 'Terminkonflikte';

  @override
  String conflictDuringShift(String time, String shiftName) {
    return '$time · während $shiftName';
  }

  @override
  String get conflictUntitled => 'Termin ohne Titel';

  @override
  String reminderConflictTitle(String shiftName) {
    return 'Morgen: Termin während $shiftName';
  }

  @override
  String reminderConflictBodyOne(String title, String time, String shiftTime) {
    return '„$title“ ($time) überschneidet sich mit deiner Schicht ($shiftTime).';
  }

  @override
  String reminderConflictBodyMany(int count, String shiftTime) {
    return '$count Termine überschneiden sich mit deiner Schicht ($shiftTime).';
  }

  @override
  String get calendarHasEvents => 'Termine';

  @override
  String get daySheetEvents => 'Termine';

  @override
  String get eventAllDay => 'Ganztägig';

  @override
  String get holidayNewYear => 'Neujahr';

  @override
  String get holidayEpiphany => 'Heilige Drei Könige';

  @override
  String get holidayWomensDay => 'Internationaler Frauentag';

  @override
  String get holidayGoodFriday => 'Karfreitag';

  @override
  String get holidayEasterSunday => 'Ostersonntag';

  @override
  String get holidayEasterMonday => 'Ostermontag';

  @override
  String get holidayLabourDay => 'Tag der Arbeit';

  @override
  String get holidayLiberationDay => 'Tag der Befreiung';

  @override
  String get holidayAscension => 'Christi Himmelfahrt';

  @override
  String get holidayWhitSunday => 'Pfingstsonntag';

  @override
  String get holidayWhitMonday => 'Pfingstmontag';

  @override
  String get holidayCorpusChristi => 'Fronleichnam';

  @override
  String get holidayAssumption => 'Mariä Himmelfahrt';

  @override
  String get holidayChildrensDay => 'Weltkindertag';

  @override
  String get holidayGermanUnity => 'Tag der Deutschen Einheit';

  @override
  String get holidayReformation => 'Reformationstag';

  @override
  String get holidayAllSaints => 'Allerheiligen';

  @override
  String get holidayRepentance => 'Buß- und Bettag';

  @override
  String get holidayChristmas => '1. Weihnachtstag';

  @override
  String get holidayBoxingDay => '2. Weihnachtstag';

  @override
  String get schoolHolidayWinter => 'Winterferien';

  @override
  String get schoolHolidayMidYear => 'Halbjahresferien';

  @override
  String get schoolHolidayCarnival => 'Fastnachtsferien';

  @override
  String get schoolHolidaySpring => 'Frühjahrsferien';

  @override
  String get schoolHolidayEaster => 'Osterferien';

  @override
  String get schoolHolidayWhitsun => 'Pfingstferien';

  @override
  String get schoolHolidaySummer => 'Sommerferien';

  @override
  String get schoolHolidayAutumn => 'Herbstferien';

  @override
  String get schoolHolidayChristmas => 'Weihnachtsferien';

  @override
  String get schoolHolidayDayOff => 'Schulfreier Tag';

  @override
  String get stateBw => 'Baden-Württemberg';

  @override
  String get stateBy => 'Bayern';

  @override
  String get stateBe => 'Berlin';

  @override
  String get stateBb => 'Brandenburg';

  @override
  String get stateHb => 'Bremen';

  @override
  String get stateHh => 'Hamburg';

  @override
  String get stateHe => 'Hessen';

  @override
  String get stateMv => 'Mecklenburg-Vorpommern';

  @override
  String get stateNi => 'Niedersachsen';

  @override
  String get stateNw => 'Nordrhein-Westfalen';

  @override
  String get stateRp => 'Rheinland-Pfalz';

  @override
  String get stateSl => 'Saarland';

  @override
  String get stateSn => 'Sachsen';

  @override
  String get stateSt => 'Sachsen-Anhalt';

  @override
  String get stateSh => 'Schleswig-Holstein';

  @override
  String get stateTh => 'Thüringen';

  @override
  String get holidaysTitle => 'Feiertage & Ferien';

  @override
  String get holidaysNationwideOnly => 'Nur bundesweite Feiertage';

  @override
  String get holidaysIntro =>
      'Bundesweite Feiertage wie Neujahr, Ostern oder der 3. Oktober sind immer markiert. Mit deinem Bundesland kommen regionale Feiertage und auf Wunsch die Schulferien dazu.';

  @override
  String get holidaysStateLabel => 'Bundesland';

  @override
  String get holidaysSchoolToggle => 'Schulferien markieren';

  @override
  String get holidaysSchoolToggleBody =>
      'Ferien der allgemeinbildenden Schulen als farbiges Band unter den Tagen.';

  @override
  String get holidaysSchoolNeedsState => 'Dafür zuerst ein Bundesland wählen.';

  @override
  String get holidaysDaysOffToggle => 'An Feiertagen frei';

  @override
  String get holidaysDaysOffBody =>
      'Gesetzliche Feiertage ersetzen Schichten aus deinem Rhythmus durch „Frei“. Musst du doch arbeiten, änderst du den Tag im Kalender.';

  @override
  String get holidaysSave => 'Speichern';

  @override
  String get holidaysSaved => 'Feiertage & Ferien gespeichert';

  @override
  String holidaysSchoolDataUntil(String date) {
    return 'Schulferien bekannt bis $date.';
  }

  @override
  String get holidaysSource =>
      'Feiertage berechnet die App selbst. Schulferien stammen aus dem OpenHolidays-Projekt (openholidaysapi.org, Datenlizenz ODbL 1.0) und werden mit App-Updates ergänzt. Angaben ohne Gewähr. Feiertage einzelner Gemeinden (z. B. Mariä Himmelfahrt in Teilen Bayerns) sind nicht enthalten.';

  @override
  String get holidaysPromptTitle => 'Feiertage und Ferien markieren?';

  @override
  String get holidaysPromptBody =>
      'Wähle dein Bundesland, dann zeigt der Kalender auch regionale Feiertage und Schulferien.';

  @override
  String get holidaysPromptAction => 'Auswählen';

  @override
  String get holidaysPromptDismiss => 'Nicht jetzt';

  @override
  String get calendarHoliday => 'Feiertag';

  @override
  String get calendarSchoolHoliday => 'Schulferien';

  @override
  String get calendarHolidayOff => 'Feiertag, frei';

  @override
  String holidayOffFrom(String shiftName) {
    return 'Feiertag frei · laut Rhythmus $shiftName';
  }
}
