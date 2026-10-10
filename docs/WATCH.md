# Uhr-Anzeige: Apple Watch und Wear OS

Erste Version: **nur Anzeige**. Die Uhr zeigt die heutige Schicht, die
nächsten Tage und eine Komplikation (Apple Watch) bzw. ein Tile und eine
Komplikation (Wear OS). Gewohnheiten abhaken auf der Uhr ist ein späterer
Schritt.

## Datenfluss

```
Drift-DB ─► WatchSync (Flutter) ─► MethodChannel com.rytmavo/watch
   ├─ iOS:     AppDelegate.swift  ─► WCSession.updateApplicationContext ─► RytmavoWatch
   └─ Android: MainActivity.kt    ─► Wearable DataClient (/rytmavo/snapshot) ─► android/wear
```

- `lib/features/watch/`: `WatchSnapshotBuilder` erzeugt aus dem `ShiftSetup`
  14 datierte Tage ab heute mit bereits lokalisierten Namen (JSON, Format
  `v: 1`). `WatchSync` sendet bei Änderungen von Schichten oder Sprache,
  beim Start und beim Zurückkehren in die App; unveränderte Daten werden
  nicht erneut gesendet.
- Die Uhr wählt „heute“ selbst nach ihrem Datum. Dadurch bleiben Anzeige,
  Komplikation und Tile zwei Wochen lang richtig, auch wenn die Handy-App
  nicht geöffnet wird.
- Kein Server, keine Internet-Berechtigung: Beide Wege laufen direkt
  zwischen Handy und Uhr (Bluetooth/WLAN). Siehe `PRIVACY_DATA_MAP.md`.

JSON-Beispiel:

```json
{"v":1,"days":[
  {"date":"2026-10-10","kind":"early","name":"Früh","abbr":"F",
   "color":4288306699,"start":"06:00","end":"14:00","override":false},
  {"date":"2026-10-11","kind":"none"}
]}
```

## Apple Watch (watchOS 10+)

Quellen liegen in `ios/RytmavoWatch/` (App) und `ios/RytmavoWatchWidgets/`
(Komplikation). Die Xcode-Targets sind **noch nicht** im Projekt angelegt,
weil das Projekt nur mit Xcode sicher bearbeitet werden kann. Einmalig auf
dem Mac:

1. `ios/Runner.xcworkspace` in Xcode öffnen.
2. File › New › Target › watchOS › **App** (für bestehende iOS-App):
   Product Name `RytmavoWatch`, Interface SwiftUI, Sprache Swift,
   „Watch App for Existing iOS App“ = Runner. Bundle-ID wird
   `com.rytmavo.rytmavo.watchkitapp`.
3. Die von Xcode erzeugten Swift-Dateien im neuen Ordner löschen und
   stattdessen `RytmavoWatchApp.swift`, `ContentView.swift`,
   `Shared/WatchSnapshot.swift`, `de.lproj/` und `en.lproj/` aus
   `ios/RytmavoWatch/` zum Target hinzufügen.
4. File › New › Target › watchOS › **Widget Extension**: Name
   `RytmavoWatchWidgets`, ohne Configuration Intent, eingebettet in
   `RytmavoWatch`. Erzeugte Dateien löschen, `ShiftComplication.swift`
   hinzufügen. `Shared/WatchSnapshot.swift` und die beiden `.lproj`-Ordner
   zusätzlich diesem Target zuordnen (Target Membership).
5. Beide Watch-Targets: Signing mit Team `YXU94SP639`, Deployment Target
   watchOS 10.0, Capability **App Groups** mit `group.com.rytmavo.rytmavo`
   (gleich wie `SnapshotStore.appGroup`).
6. Schema `RytmavoWatch` auf eine gekoppelte Uhr oder den Simulator
   (iPhone + Watch-Paar) starten, danach die iPhone-App einmal öffnen.

Die iPhone-Seite (`WatchBridge` in `ios/Runner/AppDelegate.swift`) ist
bereits eingebaut und braucht kein weiteres Setup.

## Wear OS (Wear OS 3+, API 30+)

Modul `android/wear` (Kotlin, Compose for Wear OS, Tiles, Komplikation).
Es wird beim normalen Gradle-Build mitgebaut.

- Paketname und Signatur müssen mit der Handy-App übereinstimmen, sonst
  verbindet die Data Layer die beiden nicht. Das Modul nutzt deshalb
  `applicationId = com.rytmavo.rytmavo` und dieselbe `key.properties`.
- Testen: Wear-OS-Emulator mit dem Handy-Emulator koppeln (Android Studio ›
  Device Manager › Pair Wearable) oder echte Uhr per ADB über WLAN.
  `cd android && ./gradlew :wear:installDebug`, danach die Handy-App
  starten.
- Tile: auf der Uhr nach links wischen › Tile hinzufügen › „Heutige
  Schicht“. Komplikation: Zifferblatt bearbeiten › Komplikation ›
  Rytmavo.
- Play Store: Die Uhr-App wird als eigenes Bundle (`:wear:bundleRelease`)
  im selben Play-Eintrag unter dem Formfaktor Wear OS hochgeladen.

## Bekannte Grenzen

- Nur Anzeige; kein Abhaken von Gewohnheiten auf der Uhr.
- Wear-OS-Komplikation aktualisiert sich spätestens alle 30 Minuten, nach
  Mitternacht also mit bis zu 30 Minuten Verzögerung (Tile und
  Apple-Watch-Komplikation wechseln exakt um Mitternacht).
- Ohne Google-Play-Dienste auf dem Handy (z. B. manche Huawei-Geräte)
  gibt es keine Verbindung zu Wear OS.
