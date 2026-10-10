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

### Offene Prüfungen

- Golden-Tests für zentrale Screens (ab Phase 2, wenn echte Inhalte existieren).
- Migrationstests (ab erster Schema-Erhöhung).
- Textskalierung 200 % und Screenreader auf realen Geräten.
