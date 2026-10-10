# Testbericht

Jeder Eintrag nennt Befehl, Umgebung und tatsächliches Ergebnis. Nicht
ausführbare Prüfungen werden als „nicht ausgeführt“ mit Grund aufgeführt.

## Phase 0/1 – 2026-10-10

Umgebung: Linux x64 (Ubuntu 24.04, Cloud-Container), Flutter 3.47.7 stable,
Dart 3.13.5. Kein Android-SDK, kein Xcode, kein Gerät/Emulator.

| Befehl | Ergebnis |
|---|---|
| `dart format --output=none --set-exit-if-changed .` | Exit 0, keine Abweichungen |
| `flutter analyze` | „No issues found!“ (strict-casts, strict-inference, strict-raw-types, erweiterte Lints) |
| `flutter test --timeout 60s` | 24 Tests, 24 bestanden, 0 fehlgeschlagen |
| `dart run build_runner build --delete-conflicting-outputs` | drift-Code erzeugt (`app_database.g.dart`) |
| `flutter gen-l10n` | DE/EN generiert, keine fehlenden Schlüssel |
| `flutter build appbundle` | **nicht ausgeführt** – kein Android-SDK im Container (CI-Workflow enthält Debug-APK-Build) |
| `flutter build ipa` | **nicht ausgeführt** – nur auf macOS/Xcode möglich |
| Gerätetests Android/iOS | **nicht ausgeführt** – keine Geräte in dieser Umgebung |

### Abgedeckte Tests

- `test/core/date/local_date_test.dart`: ISO-Parsing inkl. ungültiger Daten,
  Schaltjahre (2000/2024/2100), 29. Februar, Jahreswechsel, negative
  Differenzen, DST-Datum (29./30.03.2026), `addMonths`-Clamping, ISO-Wochentage,
  Sortierung, `floorMod` für negative Werte.
- `test/core/date/local_time_test.dart`: Parsing, Formatierung, Vergleich,
  Überlauf von Minuten.
- `test/core/result/result_test.dart`: `fold`/`map`, `guardStorage` mappt
  Exceptions auf `StorageFailure`.
- `test/core/ui/app_colors_test.dart`: alle semantischen Farbpaare ≥ 4,5:1
  (Light und Dark), Body-Text-Kontrast beider Themes. Fund: Früh-Farbe Light
  ursprünglich 3,78:1 → auf `#9A5E0B` (5,28:1) korrigiert.
- `test/features/settings/drift_settings_repository_test.dart`: Defaults,
  Round-Trip aller Felder, Stream-Aktualisierung, unbekannte Werte fallen auf
  Defaults zurück (In-Memory-SQLite).
- `test/app/app_test.dart`: Start auf „Heute“, Navigation über alle vier Tabs
  (Deutsch), Sprachwechsel auf Englisch mit Persistenz, Dark-Theme,
  Mindesthöhe der Navigationsleiste.

## Phase 2 – 2026-10-10

Umgebung: wie Phase 0/1 (Linux-Container, Flutter 3.47.7, kein Gerät).

| Befehl | Ergebnis |
|---|---|
| `dart format --output=none --set-exit-if-changed .` | Exit 0 |
| `flutter analyze` | „No issues found!“ |
| `flutter test --timeout 30s` | 49 Tests, 49 bestanden, 0 fehlgeschlagen |
| `flutter gen-l10n` | 52 neue Schlüssel in DE und EN, keine fehlenden |
| `flutter build apk` / `ipa`, Gerätetests | **nicht ausgeführt** – kein SDK/Gerät im Container |

### Neue Tests

- `test/features/shifts/shift_setup_test.dart` (17): Ankertag = Slot 0,
  Zyklus-Wiederholung, Tage vor dem Anker (negative Differenz → `floorMod`),
  Stabilität über DST (29.03./25.10.2026), 29.02.2028 und Jahreswechsel,
  Versionierung (neue Version ab `validFrom`, Vergangenheit bleibt), Overrides
  (gewinnen, merken Rotationsschicht, unbekannter Typ fällt zurück),
  `daysFrom`, `nextWorkDayAfter`, Nachtschicht über Mitternacht,
  `RotationRules` (Presets gültig, leer/zu lang/unbekannt ungültig, Anker).
- `test/features/shifts/drift_shift_repository_test.dart` (8): Round-Trip
  und Upsert der Schichttypen, Versionen (gleiches `validFrom` ersetzt,
  `replaceHistory` löscht Historie), Overrides setzen/ersetzen/entfernen,
  Fremdschlüssel-Verstoß liefert `Failure` statt Exception, defekte Zeilen
  werden übersprungen, `watch()` emittiert nach Änderungen.
- `test/features/shifts/onboarding_flow_test.dart` (2): kompletter
  Onboarding-Durchlauf (Vorlage Konti 4, Tag 8 umschalten, heutige Position,
  Fertig → Heute zeigt Nacht mit „endet am Folgetag“, Setting
  `onboardingCompleted`); Kalender-Override setzen, Markierung „geändert“,
  Rhythmus wiederherstellen, Monatswechsel, „Zu heute“.

### Befunde

- Tagesblatt öffnete sich im Branch-Navigator und lag damit unter der
  Bottom-Navigation bzw. unter Snackbars (Tap im Test traf die Snackbar).
  Behoben mit `useRootNavigator: true`.
- `tableUpdates()` in einem `async*`-Stream ließ sich nicht abbestellen
  (Test-Teardown hing). Ersetzt durch drift-Query-Stream (ADR-010).
- Widget-Tests räumen den Baum jetzt in `addTearDown` ab, damit ein
  fehlschlagender Test nicht die folgenden blockiert.

## Phase 3 – 2026-10-10

Umgebung: wie zuvor.

| Befehl | Ergebnis |
|---|---|
| `dart format --output=none --set-exit-if-changed .` | Exit 0 |
| `flutter analyze` | „No issues found!“ |
| `flutter test --timeout 30s` | 68 Tests, 68 bestanden, 0 fehlgeschlagen |
| `flutter gen-l10n` | 49 neue Schlüssel in DE und EN |
| Builds / Gerätetests | **nicht ausgeführt** – kein SDK/Gerät im Container |

### Neue Tests

- `test/features/habits/habit_plan_test.dart` (11): leere Ziele = jeden Tag
  (auch ohne Schicht), Zielschichten, Wochentage, vor Erstellung / ab
  Archivierung nicht fällig, Regelversionen (Vergangenheit behält alte
  Regel), Erledigung je Tag; Statistik: Quote nur über fällige Tage, `null`
  statt 0 % ohne fällige Tage, Zukunft nicht gezählt, Serien (offener
  heutiger Tag bricht nicht), Gesamtwerte.
- `test/features/habits/drift_habit_repository_test.dart` (6): Round-Trip
  inkl. Erinnerungszeiten, Upsert + Versionierung, idempotentes Abhaken,
  Archivieren behält Daten / Löschen kaskadiert, Reihenfolge, `watch()`.
- `test/features/habits/habits_flow_test.dart` (2): Gewohnheit anlegen
  (leerer Name abgelehnt, Schichten Früh+Nacht), Heute abhaken, Rückgängig;
  Auswertung zeigt 1 von 1 und 100 %.

## Phase 4 – 2026-10-10

| Befehl | Ergebnis |
|---|---|
| `dart format --output=none --set-exit-if-changed .` | Exit 0 |
| `flutter analyze` | „No issues found!“ |
| `flutter test --timeout 30s` | 77 Tests, 77 bestanden |
| Zustellung echter Benachrichtigungen (Android/iOS) | **nicht ausgeführt** – kein Gerät; Gradle-/Manifest-/AppDelegate-Änderungen sind beim ersten lokalen Build zu verifizieren |

### Neue Tests

- `test/features/reminders/reminder_planner_test.dart` (4): Platzhalter-
  Erinnerung je fälligem Tag (Vergangenes ausgelassen), schichtspezifische
  Zeit vor Platzhalter, freie Tage und nicht fällige Schichten übersprungen,
  erledigte Tage ausgelassen, stabile 31-Bit-IDs, Deckelung auf 60 mit
  frühesten zuerst.
- `test/features/reminders/reminder_scheduler_test.dart` (4): Planung mit
  deutschem Text, Erledigung entfernt Erinnerung, Aus → `cancelAll`,
  englischer Text bei Sprache EN.
- `test/features/habits/habits_flow_test.dart` (+1): Erinnerungszeit über
  Zeitwähler auf der Regel gespeichert, Hinweis bei global ausgeschalteten
  Erinnerungen, Schalter in den Einstellungen.

## Phase 5 – 2026-10-10

| Befehl | Ergebnis |
|---|---|
| `dart format --output=none --set-exit-if-changed .` | Exit 0 |
| `flutter analyze` | „No issues found!“ |
| `flutter test --timeout 30s` | 87 Tests, 87 bestanden |
| Teilen-Menü / Dateiauswahl (share_plus, file_picker) | **nicht ausgeführt** – Plattform-Plugins, kein Gerät; auf Android und iOS manuell prüfen |

### Neue Tests

- `test/features/backup/backup_codec_test.dart` (7): Round-Trip aller
  Tabellen, stabiler Header, Ablehnung von Nicht-JSON, Nicht-Objekt, neuerer
  Schema-Version, hängenden Verweisen und falschen Feldtypen; leere Datei
  ergibt leeres Dokument mit Standard-Einstellungen.
- `test/features/backup/drift_backup_repository_test.dart` (3): Import →
  Export identisch und von den Feature-Repositories sichtbar, Import ersetzt
  statt zu mischen, `deleteAll` leert alle Tabellen und setzt Einstellungen
  zurück.

## Phase 6 – 2026-10-10

| Befehl | Ergebnis |
|---|---|
| `dart format --output=none --set-exit-if-changed .` | Exit 0 |
| `flutter analyze` | „No issues found!“ |
| `flutter test --timeout 30s` | 89 Tests, 89 bestanden |
| `flutter build apk` / `flutter build ios` | **nicht ausgeführt** – kein Android SDK / Xcode in der Entwicklungsumgebung; erster lokaler Build durch den Auftraggeber |

### Neue Tests

- `test/app/app_test.dart` (+2): Über-Seiten (Datenschutz, Support mit
  Versionszeile) öffnen und schließen; Heute- und Einstellungsseite bei 200 %
  Textskalierung ohne Ausnahme (Overflow) gerendert.

## Review-Runde 1 – 2026-10-10

| Befehl | Ergebnis |
|---|---|
| `dart format --output=none --set-exit-if-changed .` | Exit 0 |
| `flutter analyze` | „No issues found!“ |
| `flutter test --timeout 30s` | 90 Tests, 90 bestanden |

- `test/features/habits/habits_flow_test.dart` (geändert +1): Erinnerung in
  der Gewohnheit fragt Berechtigung ab und schaltet Erinnerungen global ein;
  verweigerte Berechtigung lässt sie aus und zeigt den Hinweis.

## Review-Runde 3 – 2026-10-10

| Befehl | Ergebnis |
|---|---|
| `dart format --output=none --set-exit-if-changed .` | Exit 0 |
| `flutter analyze` | „No issues found!“ |
| `flutter test --timeout 30s` | 92 Tests, 92 bestanden |
| Reproduktion „erst nach Neustart sichtbar“ auf Gerät | **nicht möglich** (kein Gerät); In-Prozess-Streams nachweislich korrekt, Fix absichert beide Pfade – auf Gerät gegenprüfen |

- `test/app/drift_app_flow_test.dart` (2, neu): App mit echter Drift-DB
  (In-Memory): Schichtmodell anlegen, über den Stift-Knopf bearbeiten, Heute
  zeigt sofort das neue Modell; Gewohnheit anlegen und umbenennen, Liste
  aktualisiert sich. Der Test deckte die ID-Kollision bei stehender Uhr auf.

## Review-Runde 4 – 2026-10-10

| Befehl | Ergebnis |
|---|---|
| `dart format --output=none --set-exit-if-changed .` | Exit 0 |
| `flutter analyze` | „No issues found!“ |
| `flutter test --timeout 30s` | 92 Tests, 92 bestanden |
| Mitteilungs-Dialog auf Gerät | **nicht ausgeführt** – Nutzer meldet, dass die Abfrage nicht erscheint; Plattform/OS-Version erfragt |

## Gerätekalender-Abgleich – 2026-10-10

Umgebung: Linux x64 (Cloud-Container), Flutter 3.47.7, Dart 3.13.5. Kein
Android-SDK, kein Xcode, kein Gerät.

| Befehl | Ergebnis |
|---|---|
| `dart format --output=none --set-exit-if-changed .` | Exit 0 |
| `flutter analyze` | „No issues found!“ |
| `flutter test` | 118 Tests, 118 bestanden (nach Rebase auf Uhr-Änderung) |
| Kalenderzugriff und Terminlesen auf Gerät | **nicht ausgeführt** – keine Geräte; Plugin-Aufrufe sind hinter `DeviceCalendarGateway` gekapselt und in Tests durch eine Fake-Implementierung ersetzt |

Neue Tests: `shift_conflict_detector_test.dart` (Überlappung, Kanten,
Nachtschicht über Mitternacht, freie Tage, ganztägige Termine, Overrides,
mehrtägige Termine), `conflict_reminder_planner_test.dart` (Vorabend 18:00,
Gruppierung je Tag, vergangene verworfen), `calendar_conflicts_flow_test.dart`
(Einschalten fragt Zugriff, Verweigerung, Kalenderauswahl, Heute, Monatsraster,
Tagesblatt), Scheduler- und Settings-Repository-Erweiterungen.

## Kalendertermine in der Kalenderansicht – 2026-10-10

| Befehl | Ergebnis |
|---|---|
| `dart format --output=none --set-exit-if-changed .` | Exit 0 |
| `flutter analyze` | „No issues found!“ |
| `flutter test` | 125 Tests, 125 bestanden |

Neu: `calendar_event_days_test.dart` (Tageszuordnung über Mitternacht,
Ende genau um Mitternacht, ganztägig mit exklusivem Ende, Jahreswechsel),
Flow-Test für Punkte im Monatsraster und Terminliste im Tagesblatt.

### Offene Prüfungen

- Golden-Tests für zentrale Screens (bewusst zurückgestellt: Goldens sind
  plattform- und schriftabhängig und würden ohne CI-Referenzbilder sofort
  rot; sinnvoll erst nach dem ersten Gerätebuild).
- Migrationstests (ab erster Schema-Erhöhung).
- Textskalierung 200 % und Screenreader auf realen Geräten.

## Uhr-Anzeige – 2026-10-10

| Befehl | Ergebnis |
|---|---|
| `dart format --output=none --set-exit-if-changed .` | Exit 0 |
| `flutter analyze` | „No issues found!“ |
| `flutter test --timeout 30s` | 100 Tests, 100 bestanden (nach Rebase auf main) |

- `test/features/watch/watch_snapshot_builder_test.dart` (neu, 5): 14-Tage-
  Fenster über den Jahreswechsel, Namen/Farbe/Zeiten inkl. Nachtschicht,
  Override-Markierung, Tage ohne Rotation, JSON-Form.
- `test/features/watch/watch_sync_test.dart` (neu, 3): lokalisierte Namen
  DE/EN, kein erneutes Senden unveränderter Daten, erneutes Senden nach
  Schichtänderung.

### Nicht geprüft (kein Xcode/Android SDK im Container)

- Swift-Code (iPhone-Bridge, watchOS-App, Komplikation): nicht kompiliert;
  Xcode-Targets müssen auf dem Mac angelegt werden (`docs/WATCH.md`).
- Kotlin-Code (Handy-Bridge, `android/wear`): wird erst im CI-Job
  „Android debug build“ kompiliert.
- Übertragung Handy → Uhr auf echten Geräten bzw. gekoppelten Emulatoren.

## Feiertage und Schulferien – 2026-10-10

| Befehl | Ergebnis |
|---|---|
| `dart format --output=none --set-exit-if-changed .` | Exit 0 |
| `flutter analyze` | „No issues found!“ |
| `flutter test` | 146 Tests, 146 bestanden |

- `test/features/holidays/german_public_holidays_test.dart` (neu, 6): Ostern
  für bekannte Jahre (früh/spät, 2000, 2038), neun bundesweite Feiertage 2026,
  Landesfeiertage NW/BY/BW/SL/TH/BB/HH, Buß- und Bettag (auch wenn der
  22.11. ein Mittwoch ist), Einführungsjahre (Frauentag, Reformationstag
  2017/2018, Tag der Befreiung BE), Sortierung und Jahresgrenzen für alle
  Länder.
- `test/features/holidays/holiday_calendar_test.dart` (neu, 6): Ferien mit
  inklusiven Grenzen und über den Jahreswechsel, Abschalten, Insel- und
  Berufsschul-Termine ausgeschlossen, „An Feiertagen frei“, Konsistenz der
  mitgelieferten Daten (jedes Land, Sommerferien 2025–2030).
- `test/features/holidays/holiday_flow_test.dart` (neu, 3, Widget): Markierung
  des 3. Oktober, einmalige Abfrage mit „Nicht jetzt“, Auswahl NRW mit
  Ferienband und freiem Feiertag, Arbeiten an einem freien Feiertag über das
  Tagesblatt.
- `shift_setup_test.dart` (+5): Feiertag ersetzt Arbeitsschicht, Rhythmus-
  Freitag bleibt, Override gewinnt, ohne Regel keine Änderung, nächste
  Schicht überspringt freie Feiertage.
- Einstellungen-Roundtrip und Backup-Codec um die neuen Felder erweitert;
  Kontrasttest für `holiday` (≥ 4,5:1) und `schoolHoliday` (≥ 3:1).

### Nicht geprüft

- Darstellung auf echten Geräten (kein Android SDK/Xcode im Container).
- Schulferien-Termine wurden aus der OpenHolidays API übernommen und nur
  stichprobenartig geprüft (z. B. NRW Herbst 2026: 17.10.–31.10.).
