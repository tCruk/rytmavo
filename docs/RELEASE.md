# Release-Vorbereitung

Ergänzt `RELEASE_CHECKLIST.md` um die konkreten Handgriffe. Nichts davon
veröffentlicht etwas; Store-Uploads erfolgen nur nach ausdrücklicher Freigabe.

## App-Icon

Quelle: `assets/icon/app_icon_source.png` (1254 × 1254, Rytmavo-„R“).
Alle Plattform-Icons werden daraus erzeugt:

```bash
python3 -m pip install pillow   # einmalig
python3 tool/generate_icons.py
```

Erzeugt werden iOS (`AppIcon.appiconset`, alle Größen aus `Contents.json`,
ohne Alphakanal) und Android (klassisches `ic_launcher` je Dichte sowie
adaptives Icon mit Vorder- und Hintergrundebene in `mipmap-anydpi-v26`).
Die Grafik wird auf das abgerundete Quadrat beschnitten; die Ecken außerhalb
werden mit dem Hintergrundverlauf gefüllt, weil iOS und Android ihre eigene
Maske anlegen.

## Android

1. Keystore einmalig erzeugen (nicht ins Repository!):
   ```bash
   keytool -genkey -v -keystore ~/rytmavo-release.jks -keyalg RSA \
     -keysize 2048 -validity 10000 -alias rytmavo
   ```
2. `android/key.properties.example` nach `android/key.properties` kopieren
   und ausfüllen. Die Datei und `*.jks` stehen in `.gitignore`.
3. Bauen:
   ```bash
   flutter build appbundle --release   # Play Store (AAB)
   flutter build apk --release         # Sideload-Test
   ```
   Ohne `key.properties` wird der Release-Build mit dem Debug-Schlüssel
   signiert (Gradle warnt) – gut zum Testen, nicht für den Store.
4. Release-Builds sind minimiert (R8) und ressourcenbereinigt; die
   nötigen Keep-Regeln für `flutter_local_notifications` stehen in
   `android/app/proguard-rules.pro`. Nach dem ersten Release-Build
   Erinnerungen auf dem Gerät prüfen.
5. `applicationId` ist `com.rytmavo.rytmavo` (vorläufig, Arbeitsname).
   Ausgelieferte Sprachen: Deutsch (Standard) und Englisch.

## iOS

1. Team-ID des Apple-Developer-Kontos in `ios/Flutter/Signing.xcconfig`
   eintragen (`DEVELOPMENT_TEAM`). Die ID ist kein Geheimnis und darf
   committet werden; Zertifikate und Profile verwaltet Xcode automatisch.
2. Auf macOS: `flutter build ipa --release`, Archiv in Xcode validieren.
3. `CFBundleDevelopmentRegion` ist `de`, `CFBundleLocalizations` = de, en.
4. Mindestversion iOS 15.0, an zwei Stellen gleich: `Runner.xcodeproj`
   (`IPHONEOS_DEPLOYMENT_TARGET`) und `Flutter/AppFrameworkInfo.plist`
   (`MinimumOSVersion`).
5. Plugins werden über Swift Package Manager eingebunden
   (`FlutterGeneratedPluginSwiftPackage` im Xcode-Projekt). Es gibt kein
   Podfile mehr. Wer noch ein `ios/Pods`-Verzeichnis oder eine
   `Podfile.lock` aus einem früheren Build hat, führt einmal
   `cd ios && pod deintegrate` aus und löscht `ios/Podfile.lock`.

## Version

`version:` in `pubspec.yaml` (`x.y.z+build`) wird für Android
(`versionName`/`versionCode`) und iOS (`CFBundleShortVersionString`/
`CFBundleVersion`) übernommen. Build-Nummer vor jedem Store-Upload erhöhen.
