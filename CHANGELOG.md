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
