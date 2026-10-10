# Changelog

Alle nennenswerten Änderungen. Format angelehnt an Keep a Changelog;
Versionierung SemVer. Noch unveröffentlicht.

## [Unreleased] – Branch `develop/initial-app`

### Phase 0 – Projektstart (2026-10-10)
- Flutter 3.47.7 / Dart 3.13.5 Grundgerüst (`flutter create --empty`, Android + iOS).
- Projektdokumente: `CLAUDE.md`, `README.md`, `ARCHITECTURE.md` (ADR-001 … ADR-008),
  `TEST_REPORT.md`, `RELEASE_CHECKLIST.md`, `PRIVACY_DATA_MAP.md`,
  `TRADEMARK_CLEARANCE.md`.
- Strikte Analyzer-Konfiguration, CI-Workflow (format, analyze, test).

### Phase 1 – Grundgerüst (2026-10-10)
- Clean-Architecture-Ordnerstruktur (feature-first).
- Riverpod Composition Root, GoRouter mit vier Tabs (Heute, Kalender,
  Gewohnheiten, Auswertung) und Einstellungen.
- Designsystem: Farb-, Typografie-, Abstands-, Radius- und Motion-Tokens,
  Light/Dark-Theme, Komponenten (`RyPage`, `RyCard`, `RyButton`, `RyEmptyState`,
  Snackbar/Dialog-Helfer).
- Lokalisierung DE/EN über ARB.
- Kern-Value-Objects `LocalDate`, `LocalTime`, `Clock`; `Result`/`Failure`.
- drift-Datenbank Schema v1 (Schichttypen, Rotationsmuster, Overrides,
  Gewohnheiten, Regeln, Erledigungen, Einstellungen).
- Einstellungen: Sprache und Erscheinungsbild persistent.
- Tests: LocalDate/LocalTime/Result, Farbkontrast, Settings-Repository, App-Navigation.

### Phase 2 – Schichtsystem (2026-10-10)
- Domain: `ShiftType`, `RotationPattern` (versioniert, Ankerdatum, `floorMod`),
  `ShiftOverride`, `ShiftSetup` (Override > Rotation > kein Eintrag),
  `RotationPreset` (3-Schicht/2-Schicht wöchentlich, Konti 4/5, eigener
  Rhythmus), `RotationRules` (Validierung, Ankerberechnung).
- Data: `DriftShiftRepository` (Typen upsert, Rotationsversionen, Overrides,
  Live-Stream über alle drei Tabellen; defekte Zeilen werden übersprungen).
- Onboarding in vier Schritten: Vorlage → Rhythmus (Tag antippen) → heutige
  Position mit 7-Tage-Vorschau → Schichtzeiten. Im Änderungsmodus wahlweise
  ab heute (neue Version) oder rückwirkend.
- Heute-Ansicht: heutige Schicht mit Zeiten, Hinweis bei Abweichung vom
  Rhythmus, nächste Schicht an freien Tagen, 7-Tage-Streifen.
- Kalender: Monatsraster (Mo–So), Tagesblatt zum Ändern/Zurücksetzen einer
  Schicht, Legende, Markierung geänderter Tage, Monatswechsel, „Zu heute“.
- Einstellungen: Einstieg „Rhythmus und Zeiten ändern“.
- Tests: Rotations-Engine (Anker, Vor-Anker, DST, 29. Februar, Jahreswechsel,
  Versionen, Overrides), drift-Repository, Onboarding- und Kalender-Widget-Tests.

### Phase 3 – Gewohnheiten und Auswertung (2026-10-10)
- Domain: `Habit`, versionierte `HabitRule` (Zielschichten, Wochentage,
  Erinnerungszeiten), `HabitCompletion`, `HabitPlan` (Fälligkeit:
  erstellt ≤ Tag, nicht archiviert, Regel passt zu Schicht und Wochentag),
  `HabitStatistics` (Quote nur über fällige Tage, aktuelle und beste Serie,
  offener heutiger Tag bricht die Serie nicht).
- Data: `DriftHabitRepository` (Habit upsert, Regelversionen, Erledigungen
  idempotent, Archivieren, Löschen mit Kaskade, Reihenfolge, Live-Stream).
- Gewohnheiten: Liste mit Fälligkeits-Zusammenfassung, Formular (Name, Notiz,
  Symbol, Farbe, „Jeden Tag“ oder bestimmte Schichten, Wochentage), Menü
  Bearbeiten/Archivieren/Wiederherstellen/Löschen, archivierte einblendbar.
- Heute: Abschnitt „Gewohnheiten heute“ mit Fortschritt, Abhaken und
  Rückgängig per Snackbar.
- Auswertung: Zeitraum 7/30/90 Tage, Gesamtquote, je Gewohnheit Quote,
  erledigt/fällig, aktuelle und beste Serie.
- Tests: Fälligkeit und Statistik, drift-Repository, Widget-Flows
  (Gewohnheit anlegen → abhaken → rückgängig; Auswertung).

### Phase 6 – Feinschliff (2026-10-10)
- Einstellungen → Über die App: Datenschutzhinweis, Impressum und Support als
  eigene Seiten (`InfoScreen`, Texte DE/EN in den ARB-Dateien, Betreiberdaten
  als markierte Platzhalter), Versionszeile aus `package_info_plus`.
- Letzte „In einer späteren Phase“-Platzhalter entfernt.
- Tests: Über-Seiten und Version, Darstellung bei 200 % Textskalierung.

### Phase 5 – Backup (2026-10-10)
- Domain: `BackupDocument` (Schema v1: Schichtarten, Rotationen,
  Überschreibungen, Gewohnheiten, Regeln, Erledigungen, Einstellungen),
  `BackupCodec` (JSON, strikte Validierung inkl. Referenzprüfung und
  Schema-Version), Ports `BackupRepository` und `BackupFileGateway`.
- Data: `DriftBackupRepository` (Export über die Feature-Repositories, Import
  ersetzt alle Daten in einer Transaktion, `deleteAll`),
  `PlatformBackupFileGateway` (share_plus, file_picker, temporäre Datei im
  App-Cache wird nach dem Teilen gelöscht).
- Einstellungen → Daten: Exportieren (Teilen-Menü), Importieren (Datei-Auswahl,
  Vorschau mit Datum/Anzahl, Bestätigung), Lokale Daten löschen (Bestätigung).
  Jede Aktion endet mit einer Rückmeldung; ungültige Dateien werden erklärt.

### Phase 4 – Erinnerungen (2026-10-10)
- Domain: `PlannedReminder` (stabile IDs je Habit und Tag), `ReminderPlanner`
  (rollendes Fenster 14 Tage, max. 60, nur fällige, nicht erledigte Tage,
  Zeit je Schicht oder Platzhalter `*`), `NotificationGateway`-Port.
- Data: `LocalNotificationGateway` über `flutter_local_notifications`
  (nicht-exakte Android-Alarme, iOS Time-Sensitive, Instant als UTC-TZDateTime
  ohne Zeitzonen-Plugin).
- `ReminderScheduler`: Neuplanung (entprellt) bei Änderung von Schichten,
  Gewohnheiten, Erledigungen und Einstellungen, beim Start und beim
  Zurückkehren in die App; bei ausgeschalteten Erinnerungen werden alle
  entfernt.
- Gewohnheitsformular: Erinnerungszeit (jeden Tag) bzw. je Zielschicht.
- Einstellungen: Erinnerungs-Schalter mit Systemberechtigung; verweigerte
  Berechtigung wird erklärt.
- Android: `POST_NOTIFICATIONS`, `RECEIVE_BOOT_COMPLETED`, Boot-Receiver,
  Core-Library-Desugaring. iOS: `UNUserNotificationCenter`-Delegate.
- Tests: Planer, Scheduler mit aufzeichnendem Gateway (DE/EN-Texte,
  Erledigung entfernt Erinnerung, Aus = alles abbrechen), Widget-Flow.
