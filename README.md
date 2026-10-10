# Rytmavo

Schichtplanung und Gewohnheiten für Menschen in wechselnden Schichten.
Flutter-App für Android und iOS, offline-first, ohne Konto, Server, Werbung,
Abo oder In-App-Käufe.

> „Rytmavo“ ist ein Arbeitsname und markenrechtlich nicht freigegeben
> (siehe `TRADEMARK_CLEARANCE.md`). Keine Veröffentlichung ohne Freigabe.

## Stack

| Bereich | Wahl |
|---|---|
| Framework | Flutter 3.47.7 stable · Dart 3.13.5 |
| UI | Material 3 mit eigenem Designsystem (`lib/core/ui`) |
| State / DI | flutter_riverpod 3 |
| Navigation | go_router 18 |
| Persistenz | drift 2 + SQLite (drift_flutter) |
| Lokalisierung | flutter_localizations + ARB (DE Template, EN) |
| Erinnerungen | flutter_local_notifications 22 + timezone (Phase 4) |
| Backup | JSON-Export/Import über share_plus / file_picker (Phase 5) |

## Setup

```bash
flutter --version           # 3.47.7 stable erwartet
flutter pub get             # erzeugt auch lib/app/l10n/generated/
dart run build_runner build --delete-conflicting-outputs   # drift-Code
flutter run
```

## Qualitätsprüfung

```bash
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
```

Ergebnisse der letzten Läufe: `TEST_REPORT.md`.

## Build

```bash
flutter build appbundle --release      # Android (Signierung: lokale key.properties, nicht im Repo)
flutter build ipa --release            # nur auf macOS mit eingerichteter Signierung
```

## Projektstruktur

```
lib/app/        Bootstrap, Router, DI, Theme, Lokalisierung
lib/core/       Datum/Zeit, Result/Failure, Datenbank, Designsystem
lib/features/   shifts · habits · calendar · statistics · reminders · settings · backup
                jeweils domain/ · data/ · presentation/
test/           spiegelt lib/
```

Details: `ARCHITECTURE.md`. Regeln für Agenten und Mitwirkende: `CLAUDE.md`.

## Dokumente

- `ARCHITECTURE.md` – Schichten, Entscheidungen (ADRs)
- `CHANGELOG.md` – Änderungen je Version
- `TEST_REPORT.md` – ausgeführte Prüfungen und Ergebnisse
- `RELEASE_CHECKLIST.md` – Release-Gate
- `PRIVACY_DATA_MAP.md` – Datenkarte für Datenschutz / Store-Angaben
- `TRADEMARK_CLEARANCE.md` – Status der Markenrecherche (offen)
