# Rytmavo – Regeln für Coding-Agenten

Diese Datei ist verbindlich für jede KI-gestützte Änderung in diesem Repository.
Die Produktspezifikation (Masterprompt v3.0) hat Vorrang; dieses Dokument
übersetzt sie in konkrete Arbeitsregeln.

## 1. Produktgrenzen (unveränderlich)

- Bezahl-App (Ziel 9,99 EUR). **Keine** In-App-Käufe, Abos, Paywall, Werbung,
  RevenueCat, Konten, Server, Cloud-Sync, Analytics-/Crash-SDKs, externe APIs.
- Offline-first. Keine `INTERNET`-Berechtigung, solange keine Abhängigkeit sie
  nachweislich braucht (im Merged Manifest prüfen).
- Sprachen: Deutsch (Fallback) und Englisch. Keine weiteren ohne Auftrag.
- „Rytmavo“ ist ein Arbeitsname (siehe `TRADEMARK_CLEARANCE.md`). Keine
  Veröffentlichung, Markenanmeldung, Domainregistrierung, kostenpflichtige
  Aktion ohne ausdrückliche Freigabe des Auftraggebers.

## 2. Architektur (Feature-first Clean Architecture)

```
lib/app/        Bootstrap, Router (GoRouter), DI (Riverpod), Theme, l10n
lib/core/       date/ (LocalDate, LocalTime, Clock), result/ (Result, Failure),
                database/ (AppDatabase, Migrationen), ui/ (Tokens, Komponenten)
lib/features/<feature>/domain|data|presentation
```

- **domain**: reine Dart-Entities, Value Objects, Repository-Interfaces,
  Use Cases / Services mit reinen Funktionen. Keine Imports von Flutter, drift,
  Plattform-Plugins.
- **data**: drift-Tabellen (`data/tables/`), Mapper, Repository-Implementierungen.
- **presentation**: Widgets, Riverpod-Controller (`Notifier`/`AsyncNotifier`).
  Keine SQL, keine Schichtberechnung in Widgets.
- Abhängigkeiten zeigen nach innen. Composition Root ist `lib/app/di/providers.dart`
  plus `bootstrap()`. Keine globalen veränderlichen Singletons.
- Fehler: `Result<T>`/`Failure` an Layer-Grenzen; UI mappt Failure-Typen auf
  lokalisierte Texte. Keine verschluckten Exceptions.
- Datum/Zeit: Alle Kalenderlogik auf `LocalDate` (Kalender-Tagesdifferenzen,
  `floorMod`). Nie `Duration(hours: 24)` für Tage. „Jetzt“ nur über `Clock`.
- Datenbank: Schema-Änderung = `schemaVersion` erhöhen + Schritt in `onUpgrade`
  + Migrationstest. Nie Nutzerdaten in einer Migration verwerfen.
- Regelhistorie: Rotationsmuster und Habit-Regeln sind versioniert (`validFrom`).
  Bearbeiten erzeugt eine neue Version; Vergangenheit wird nicht umgedeutet.

## 3. Designsystem

- Tokens in `lib/core/ui/tokens/` (`AppColors` ThemeExtension, `AppSpacing`,
  `AppRadius`, `AppMotion`, `AppTypography`). Feature-Widgets verwenden **keine**
  Farb-, Abstands- oder Radius-Literale.
- Komponenten in `lib/core/ui/components/` (`RyPage`, `RyCard`, `RyButton`,
  `RyEmptyState`, `showRySnackBar`, `showRyConfirmDialog`). Erst wiederverwenden,
  dann erweitern, zuletzt neu bauen.
- Bedeutung nie nur über Farbe: Schichten tragen Kürzel/Icon zusätzlich zur Farbe.
- Touch-Ziele ≥ 48 dp, Semantics/Tooltips für Icon-Buttons, Reduced Motion über
  `AppMotion.durationFor`, Textskalierung bis 200 % muss funktionieren.
- Light und Dark Mode sind gleichwertig; Kontrast ≥ 4,5:1 (Test in
  `test/core/ui/app_colors_test.dart`).

## 4. Lokalisierung

- `lib/app/l10n/app_de.arb` (Template) und `app_en.arb`; generiert nach
  `lib/app/l10n/generated/` (`flutter gen-l10n`, läuft auch bei `flutter pub get`).
- Jeder neue UI-Text kommt in beide ARB-Dateien im selben Commit.
  Keine hart kodierten UI-Strings in Widgets.

## 5. Qualitätsgates (vor jedem Commit)

```bash
dart format --output=none --set-exit-if-changed .
flutter analyze            # Ziel: 0 Issues
flutter test               # alle Tests grün
dart run build_runner build --delete-conflicting-outputs   # nach Schema-Änderungen
```

- Neue Domainlogik braucht deterministische Unit-Tests (Grenzfälle: vor
  Ankerdatum, 29. Februar, Jahreswechsel, DST, Nacht über Mitternacht).
- Keine `// ignore:`-Direktiven ohne Begründung im Kommentar.
- Keine Behauptung „getestet“ ohne ausgeführten Befehl und Ergebnis in
  `TEST_REPORT.md`.

## 6. Git-Workflow

- Es gibt nur den Branch `main` (Entscheidung des Auftraggebers vom
  2026-10-10). Entwicklung und Commits erfolgen direkt auf `main`; jeder
  Commit muss die Qualitätsgates bestehen.
- Größere, riskante Umbauten dürfen auf einem kurzlebigen `feature/<thema>`
  vorbereitet und per Pull Request nach `main` gebracht werden.
- Commit nach jeder abgeschlossenen Phase bzw. jedem in sich geschlossenen
  Arbeitspaket; Conventional-Commits-Präfixe (`feat:`, `fix:`, `test:`, `docs:`,
  `chore:`, `refactor:`).
- Keine Force-Pushes auf geschützte Branches, kein History-Rewrite auf fremden
  Branches.
- Pull Requests (falls genutzt) mit Beschreibung, Testergebnissen und Review;
  **Merge nur nach ausdrücklicher Zustimmung des Auftraggebers.**
- Nie committen: Secrets, `key.properties`, Keystores, Provisioning Profiles,
  `.env`, lokale IDE-Konfiguration, Build-Ausgaben.

## 7. Delegation an Subagenten

- Orchestrator (stärkstes Modell) plant, verteilt, reviewt, integriert, testet
  und berichtet. Subagenten erhalten: Dateien/Ownership, Schnittstellen,
  Akzeptanzkriterien, Tests.
- Modellwahl: Architektur/Schichtlogik/Reviews → stärkstes Reasoning;
  Flutter-Implementierung/Tests/Übersetzung → Coding-Modell.
- Keine parallele Bearbeitung derselben Datei. Generierte Dateien (`*.g.dart`,
  `l10n/generated/`) werden nach dem Merge neu erzeugt, nicht manuell gemerged.
- Delegierte Ergebnisse werden nie blind integriert: Diff lesen, Architektur
  prüfen, Tests ausführen. Fehlende unabhängige Reviews werden im Bericht
  gekennzeichnet.

## 8. Berichtsformat nach jeder Phase

Umgesetzt · Tests (Befehle + Ergebnis) · Offene Risiken · Nächste Phase ·
Benötigte Entscheidungen.
