# Rytmavo – Architektur

Stand: 2026-10-10 (Phase 3). Dieses Dokument beschreibt Schichten, Datenfluss,
Datenmodell und die Architekturentscheidungen (ADRs).

## 1. Schichten

```
app/        Bootstrap · GoRouter · Riverpod-Root · Theme · l10n
features/<f>/presentation   Widgets · Controller (Riverpod)
features/<f>/domain         Entities · Value Objects · Repository-Interfaces · Use Cases
features/<f>/data           drift-Tabellen · Mapper · Repository-Implementierungen
core/       date (LocalDate, LocalTime, Clock) · result (Result, Failure)
            database (AppDatabase) · ui (Tokens, Komponenten)
```

Abhängigkeitsregeln:

- `domain` importiert nur Dart sowie `core/date` und `core/result`. Kein Flutter,
  kein drift, keine Plugins.
- `data` implementiert die Repository-Interfaces aus `domain` und kennt
  `core/database`.
- `presentation` kennt `domain` und `core/ui`; nie `data` direkt (Ausnahme:
  das Composition Root in `app/di`).
- `app/di/providers.dart` ist der einzige Ort, der Interfaces an
  Implementierungen bindet. Tests überschreiben dort (`ProviderScope.overrides`).

## 2. Datenfluss

1. Widget liest einen Riverpod-Provider (`ref.watch`).
2. Controller (`Notifier`/`AsyncNotifier`) ruft Use Case / Repository auf.
3. Repository (data) liest/schreibt drift und mappt Rows ↔ Entities.
4. drift-Streams (`watch()`) treiben Aktualisierungen zurück in die UI.

Fehler werden als `Result<T>` (`Success`/`Error(Failure)`) zurückgegeben.
Die UI mappt `Failure`-Typen auf lokalisierte Texte; Rohfehler erreichen nie
den Nutzer.

## 3. Datum und Zeit

- `LocalDate` (Jahr/Monat/Tag) ist die Einheit aller Kalenderlogik. Differenzen
  werden über UTC-Mitternacht gerechnet, damit Sommer-/Winterzeit nie einen
  23- oder 25-Stunden-Tag erzeugt.
- `floorMod` liefert für Tage vor dem Ankerdatum eine nicht-negative Position.
- `LocalTime` (Stunde/Minute) für Schichtzeiten und Erinnerungen.
- `Clock` wird injiziert (`clockProvider`); Tests verwenden `FixedClock`.
- Nachtschichten gehören dem Kalendertag, an dem sie beginnen. Das tatsächliche
  Uhrzeitintervall (z. B. 22:00–06:00) wird separat dargestellt und in der UI
  erklärt (Phase 2).

## 4. Datenmodell (drift Schema v1)

| Tabelle | Zweck | Schlüssel |
|---|---|---|
| `shift_types` | Früh/Spät/Nacht/Frei + eigene Typen (Name, Kürzel, Farbe, Zeiten) | `id` |
| `rotation_patterns` | Versionierte Rotation: `valid_from`, `anchor_date`, `slots_json` | `id` |
| `shift_overrides` | Manuelle Tagesüberschreibung | `date` (ISO) |
| `habits` | Gewohnheit (Name, Beschreibung, Icon, Farbe, `created_on`, `archived_on`) | `id` |
| `habit_rules` | Versionierte Fälligkeitsregel: Zielschichten, Wochentage, Erinnerungen | `id` |
| `habit_completions` | Genau eine Erledigung je Habit und lokalem Kalendertag | `(habit_id, date)` |
| `settings_entries` | Key/Value-Einstellungen | `key` |

Invarianten:

- Für ein Datum gilt das Rotationsmuster mit dem größten `valid_from <= date`.
  Bearbeiten legt eine neue Version an; Historie bleibt interpretierbar.
- Override > Rotation. Ein Override ist jederzeit entfernbar.
- Habit-Fälligkeit an Tag `d`: `created_on <= d`, nicht archiviert vor `d`,
  Regel gültig an `d` passt zur Schicht von `d` (und Wochentag, falls gesetzt).
- Erfolgsquote = Erledigungen / fällige Tage. Nicht fällige Tage zählen nie
  negativ.
- Fremdschlüssel sind aktiv (`PRAGMA foreign_keys = ON`); Schichttypen, die in
  Overrides verwendet werden, können nicht gelöscht, nur archiviert werden.

## 5. Designsystem

- `AppColors` (ThemeExtension): Schichtfarben mit geprüften `on*`-Partnern,
  Erfolg/Warnung, erhöhte Flächen, weiche Linien. Light und Dark separat.
- `AppTypography`: Plattformschrift, redaktionelle Skala (keine Fremdschrift,
  keine Lizenzfrage).
- `AppSpacing` (4-pt), `AppRadius`, `AppMotion` (mit Reduced-Motion-Helfer).
- Komponenten: `RyPage` (Sliver-Seite mit großem Titel), `RyCard`, `RyButton`
  (primary/secondary/tertiary/destructive), `RyEmptyState`, `showRySnackBar`,
  `showRyConfirmDialog`.
- Primäre Navigation: `NavigationBar` mit Heute · Kalender · Gewohnheiten ·
  Auswertung; Einstellungen als Aktion in jeder App-Bar.

## 6. Architekturentscheidungen (ADRs)

### ADR-001 Flutter 3.47.7 stable / Dart 3.13.5
Stand zum Projektstart (2026-10-10). Versionen sind in `pubspec.lock` und der
CI fixiert.

### ADR-002 Riverpod 3 ohne Codegenerierung
`flutter_riverpod` mit `Notifier`/`AsyncNotifier` und `Provider`. Kein
`riverpod_generator`, um die Build-Pipeline auf drift zu beschränken und
Provider explizit lesbar zu halten. Composition Root über `ProviderScope.overrides`.

### ADR-003 GoRouter mit `StatefulShellRoute.indexedStack`
Vier Tabs behalten ihren Navigationszustand; Einstellungen liegen auf dem
Root-Navigator. Routen sind Konstanten in `AppRoutes`.

### ADR-004 drift + SQLite für alle persistenten Daten (auch Einstellungen)
Ein Speicher, eine Migrationsgeschichte, ein Backup-Pfad. Einstellungen als
Key/Value-Tabelle statt `shared_preferences` (eine Abhängigkeit weniger,
gleiche Backup-Logik). Tests laufen gegen `NativeDatabase.memory()`.

### ADR-005 Versionierte Regeln statt Snapshot-Modell
Rotationsmuster und Habit-Regeln tragen `valid_from`. Änderungen erzeugen neue
Versionen; vergangene Tage werden mit der damals gültigen Regel ausgewertet.
Vorteil gegenüber Snapshots: kein Datenvolumen pro Tag, deterministisch
nachrechenbar, einfacher Export.

### ADR-006 Lokalisierung über ARB / `flutter gen-l10n`
Standardweg des Frameworks; Deutsch ist Template und Fallback. Generierte
Dateien sind eingecheckt (`lib/app/l10n/generated/`), damit Analyse und CI
ohne Vorlauf funktionieren.

### ADR-007 Plattformschrift statt eingebetteter Schriftart
Vermeidet Lizenzprüfung und App-Größe; Charakter kommt aus Skala, Gewichten
und Weißraum.

### ADR-008 Keine Crash-/Analytics-SDKs
Fehler werden nur im Debug-Modus geloggt. Entspricht der Produktgrenze
„keine Tracker“ und vereinfacht Store-Angaben (siehe `PRIVACY_DATA_MAP.md`).

### ADR-009 Bundle-/Application-ID `com.rytmavo.rytmavo` (vorläufig)
Platzhalter bis zur Markenfreigabe; **vor dem ersten Store-Upload** final
festlegen (danach auf iOS nicht mehr änderbar). Siehe `RELEASE_CHECKLIST.md`.

### ADR-010 Rotations-Repository streamt über `customSelect(...).watch()`
`tableUpdates()` in einem `async*`-Generator blockierte das Abbestellen des
Streams in Tests (hängender Teardown). Ein drift-Query-Stream mit
`readsFrom` über alle drei Tabellen liefert dieselben Updates und lässt
sich sofort abbrechen.

## 7. Schicht-Engine (Phase 2)

`ShiftSetup` ist ein unveränderlicher Snapshot aus Schichttypen, allen
Rotationsversionen und Overrides. `dayOn(date)` löst einen Tag auf:

1. `patternOn(date)`: Version mit größtem `validFrom <= date`.
2. Position im Zyklus: `floorMod(date.daysSince(anchorDate), slots.length)`.
3. Override für `date` gewinnt; `rotationShift` bleibt erhalten, damit die UI
   „geändert, laut Rhythmus X“ zeigen kann.

Beim ersten Einrichten erhält die Rotation `validFrom = 2000-01-01`, damit
der Kalender auch rückwärts gefüllt ist. Beim Ändern entsteht eine Version
ab heute (Vergangenheit bleibt), optional ersetzt sie die Historie.
Das Tagesblatt im Kalender setzt einen Override; die Wahl des Rotations-
Schichttyps entfernt ihn wieder.

## 8. Gewohnheiten (Phase 3)

`HabitPlan` ist das Pendant zu `ShiftSetup`: ein Snapshot aus Habits, allen
Regelversionen und Erledigungen. `dueRuleFor(habit, scheduledDay)` ist rein
und erhält den bereits aufgelösten Tag, sodass die Habit-Domain nicht vom
Schicht-Repository abhängt. Fällig an Tag `d`, wenn `createdOn <= d`, nicht
archiviert vor/an `d`, eine Regel mit `validFrom <= d` existiert und deren
Zielschichten (leer = immer) und Wochentage passen. Eine Regeländerung im
Formular erzeugt eine neue Version ab heute; unveränderte Bedingungen
erzeugen keine Version. Erledigungen sind `(habitId, date)`-eindeutig.
Statistik zählt nur fällige Tage; `rate` ist `null` statt 0 %, wenn nichts
fällig war.

## 9. Offene Architekturpunkte

- Phase 4: Reminder-Scheduler (Rolling Window, Rescheduling nach Neustart,
  nicht-exakte Alarme), Zeitzonen-/DST-Strategie.
- Phase 5: Backup-Schema v1 (JSON, `schemaVersion`), Import-Validierung.
