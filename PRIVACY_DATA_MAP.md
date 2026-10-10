# Datenkarte Rytmavo (Datenschutz / App Privacy / Data Safety)

**Status: ENTWURF – rechtliche Prüfung erforderlich.** Dieses Dokument ist die technische Grundlage für die Datenschutzerklärung sowie für die Angaben bei Apple (App Privacy) und Google (Data Safety). Es ist keine Rechtsberatung und ersetzt keine anwaltliche Prüfung.

Stand: 2026-10-10 | Betreiber: [BETREIBER – vom Auftraggeber zu ergänzen] | Datenschutzkontakt: [DATENSCHUTZ-KONTAKT – vom Auftraggeber zu ergänzen]

Hinweis: "Rytmavo" ist ein Arbeitsname (siehe `TRADEMARK_CLEARANCE.md`).

## 1. Grundsatz

- Alle Daten werden **ausschließlich lokal auf dem Gerät** gespeichert.
- **Kein Server, keine Konten, keine Cloud-Synchronisierung.**
- **Kein Tracking**, keine Analyse-SDKs, keine Crash-Reporting-SDKs, keine Werbung, keine externen APIs.
- **Keine In-App-Käufe, keine Abonnements.** Die App wird einmalig im Store gekauft (Zielpreis 9,99 EUR).
- Der Betreiber erhält über die App keine Nutzerdaten.
- Es gibt keine Datenübermittlung durch die App, außer einer **vom Nutzer ausgelösten** Weitergabe einer Backup-Datei über das System-Teilen-Menü.
- Die App benötigt voraussichtlich **keine INTERNET-Berechtigung**. Das ist im finalen Build zu verifizieren (Abschnitt 8).

## 2. Datenkategorien

| Datenkategorie | Zweck | Speicherort | Verarbeitung | Weitergabe | Löschung |
|---|---|---|---|---|---|
| Schichttypen (Früh, Spät, Nacht, Frei, eigene Typen mit Name, Zeiten, Farbe) | Darstellung und Planung des Schichtsystems | Lokale SQLite-DB im App-Sandbox-Verzeichnis | Ausschließlich lokal auf dem Gerät | Keine, außer Backup-Export durch Nutzeraktion | App deinstallieren oder "Lokale Daten löschen" |
| Rotationsmuster (Abfolge, Ankerdatum) | Berechnung des Schichtplans | Lokale SQLite-DB | Lokal (Berechnung der Tagesschicht) | Keine, außer Backup-Export durch Nutzeraktion | App deinstallieren oder "Lokale Daten löschen" |
| Tagesüberschreibungen (manuelle Abweichung pro Tag) | Abbildung von Tausch, Urlaub, Sonderdiensten | Lokale SQLite-DB | Lokal | Keine, außer Backup-Export durch Nutzeraktion | App deinstallieren oder "Lokale Daten löschen" |
| Gewohnheiten (Name, Zielschichten, Wochentage, Erinnerungszeit) | Habit-Tracking, Tagesansicht | Lokale SQLite-DB | Lokal | Keine, außer Backup-Export durch Nutzeraktion | App deinstallieren oder "Lokale Daten löschen" |
| Erledigungen (eine je Gewohnheit und lokalem Kalendertag) | Verlauf, Statistik (7/30 Tage), Serien | Lokale SQLite-DB | Lokal (Statistikberechnung) | Keine, außer Backup-Export durch Nutzeraktion | App deinstallieren oder "Lokale Daten löschen" |
| Einstellungen (Sprache DE/EN, Theme, Erinnerungsstatus, Onboarding-Status) | Anpassung der App | Lokale SQLite-DB bzw. lokaler App-Speicher im Sandbox-Verzeichnis | Lokal | Keine, außer Backup-Export durch Nutzeraktion | App deinstallieren oder "Lokale Daten löschen" |
| Uhr-Übersicht (Schichten der nächsten 14 Tage: Datum, Name, Kürzel, Farbe, Zeiten) | Anzeige auf gekoppelter Apple Watch / Wear-OS-Uhr | iOS: WatchConnectivity-Kontext und App-Group-Speicher der Watch-App; Android: Wearable Data Layer und App-Speicher der Wear-App | Direkt zwischen Handy und eigener Uhr (Bluetooth/WLAN), kein Server | Nur an die gekoppelte Uhr des Nutzers | Watch-App deinstallieren; wird bei jeder Änderung überschrieben |
| Termine aus dem Gerätekalender (Titel, Beginn, Ende; nur bei aktivierter Funktion) | Warnung bei Überschneidung mit einer Schicht, optional Mitteilung am Vorabend | Nicht gespeichert; nur flüchtig im Arbeitsspeicher, Kalenderauswahl (IDs) in den Einstellungen | Lokal auf dem Gerät | Keine; Kalender-IDs sind nicht im Backup | Funktion ausschalten oder Zugriff in den Systemeinstellungen widerrufen |
| Backup-Dateien (versioniertes JSON) | Sicherung, Geräte-Umzug | Entsteht nur auf ausdrückliche Nutzeraktion; temporär im App-Cache, danach im vom Nutzer gewählten Ziel | Erzeugung lokal; Teilen über System-Teilen-Menü (share_plus); Import über Dateiauswahl (file_picker) | Nur an das vom Nutzer gewählte Ziel (z. B. Dateien, E-Mail, Cloud-Dienst des Nutzers) | Temporäre Datei durch App entfernen; Kopien beim Nutzer löscht der Nutzer selbst |

Hinweise:
- Schichtdaten und Gewohnheiten können je nach Beruf (z. B. Pflege) Rückschlüsse auf Lebensgewohnheiten zulassen. Sie werden deshalb nicht außerhalb des Geräts verarbeitet. Eine Einordnung als besondere Datenkategorie ist im Rahmen der Rechtsprüfung zu klären (Abschnitt 8).
- Eine Backup-Datei ist **unverschlüsselt**, sofern keine Verschlüsselung implementiert wird. Der Nutzer wird vor dem Export darauf hingewiesen (Text DE/EN in der App).

## 3. Berechtigungen

| Berechtigung | Plattform | Zweck | Anmerkung |
|---|---|---|---|
| Benachrichtigungen (opt-in) | iOS: Systemabfrage; Android 13+: `POST_NOTIFICATIONS` | Lokale Erinnerungen | Abfrage erst, wenn der Nutzer Erinnerungen aktiviert |
| `RECEIVE_BOOT_COMPLETED` | Android | Erinnerungen nach Neustart neu planen | Im Manifest deklariert (Phase 4) |
| `SCHEDULE_EXACT_ALARM` / `USE_EXACT_ALARM` | Android | Exakte Alarme | **Nur falls wirklich nötig.** Standard: nicht-exakte Alarme. Ohne Berechtigung deklarieren, solange keine exakte Zustellung gefordert ist |
| Standort | – | – | Wird nicht verwendet |
| Kontakte | – | – | Wird nicht verwendet |
| Kalender (opt-in) | iOS: `NSCalendarsFullAccessUsageDescription` / `NSCalendarsUsageDescription`; Android: `READ_CALENDAR` + `WRITE_CALENDAR` | Termine während einer Schicht erkennen und anzeigen | Abfrage erst beim Einschalten unter Einstellungen → Gerätekalender. Die App liest nur (Titel, Beginn, Ende, Kalender); sie schreibt nichts und speichert keine Termine. `WRITE_CALENDAR` ist nur deklariert, weil `device_calendar_plus` Vollzugriff als Lesen+Schreiben anfragt (eine Berechtigungsgruppe, ein Dialog). |
| Health / Fitness | – | – | Wird nicht verwendet |
| Kamera / Mikrofon / Fotos | – | – | Wird nicht verwendet |
| Zugriff auf Dateien | Android / iOS | Backup-Import | Über System-Dateiauswahl (file_picker), keine pauschale Speicherberechtigung |
| INTERNET | Android | – | Voraussichtlich **nicht** deklariert; Merged Manifest im finalen Build prüfen |

## 4. Drittanbieter-SDKs und Bibliotheken

Alle Bibliotheken laufen lokal im App-Prozess. Die Angaben zum Netzwerkzugriff sind Erwartungen und **im finalen Build zu verifizieren** (Quellcode-Audit, Merged Manifest, Netzwerktest, z. B. mit deaktiviertem Netz und Proxy-Mitschnitt).

| Paket | Zweck | Netzwerkzugriff (erwartet) | Verifikation |
|---|---|---|---|
| flutter_riverpod | Zustandsverwaltung | Nein | Zu verifizieren im finalen Build |
| go_router | Navigation | Nein | Zu verifizieren im finalen Build |
| drift | Typsichere lokale Datenbank | Nein | Zu verifizieren im finalen Build |
| drift_flutter (sqlite3) | SQLite-Anbindung und native Bibliothek | Nein | Zu verifizieren im finalen Build |
| path_provider | Pfade im App-Sandbox-Verzeichnis | Nein | Zu verifizieren im finalen Build |
| flutter_local_notifications | Lokale Erinnerungen | Nein | Zu verifizieren im finalen Build |
| timezone | Zeitzonen für Erinnerungen | Nein | Zu verifizieren im finalen Build |
| intl | Datums- und Zahlenformate | Nein | Zu verifizieren im finalen Build |
| flutter_localizations | Lokalisierung DE/EN | Nein | Zu verifizieren im finalen Build |
| share_plus | System-Teilen-Menü für Backup | Nein (Weitergabe erfolgt über die vom Nutzer gewählte Ziel-App) | Zu verifizieren im finalen Build |
| file_picker | Auswahl der Backup-Datei beim Import | Nein | Zu verifizieren im finalen Build |
| package_info_plus | Anzeige von Version und Build | Nein | Zu verifizieren im finalen Build |
| com.google.android.gms:play-services-wearable (Android, Handy + Uhr) | Übertragung der Schichtübersicht an die gekoppelte Wear-OS-Uhr | Nein für unsere Daten (Gerät-zu-Gerät); Google-Play-Dienste selbst sind Systemsoftware | Merged Manifest auf `INTERNET` prüfen |
| WatchConnectivity / WidgetKit (iOS, Systemframeworks) | Übertragung an die Apple Watch, Komplikation | Nein (Gerät-zu-Gerät) | Systemframework |
| androidx.wear (Compose, Tiles, Komplikationen), Guava (nur Wear-App) | Oberfläche der Wear-OS-App | Nein | Zu verifizieren im finalen Build |

Nicht enthalten (und nicht zu ergänzen ohne Änderung dieser Datenkarte): Analytics, Crash-Reporting, Werbe-SDKs, Attribution, Push-Dienste (FCM/APNs-Remote), In-App-Purchase-Bibliotheken.

## 5. Verarbeitung durch Betriebssystem und Stores

Nicht durch die App, aber ggf. in der Datenschutzerklärung zu erwähnen:

- **Apple / Google** verarbeiten den Kauf, die Zahlung und die Lizenzverwaltung nach ihren eigenen Datenschutzbestimmungen. Der Betreiber erhält vom Store nur aggregierte Verkaufs- und Downloadberichte.
- **Absturzberichte** können vom Betriebssystem erfasst und (nur wenn der Nutzer in den Geräteeinstellungen zugestimmt hat) an Apple bzw. Google übermittelt werden. Die App selbst sendet keine Absturzberichte.
- **Geräte-Backups** (iCloud, Google-Backup) können die App-Daten nach den Systemeinstellungen des Nutzers sichern. Ob die Datenbank vom System-Backup ausgenommen werden soll, ist zu entscheiden und in der Datenschutzerklärung entsprechend zu beschreiben.
- Beim Teilen einer Backup-Datei gelten die Datenschutzbestimmungen der vom Nutzer gewählten Ziel-App.

## 6. Hinweise für Apple App Privacy

- Zielangabe: **"Data Not Collected"**, **nur wenn** die Verifikation (Abschnitt 8) bestätigt, dass die App keine Daten an den Betreiber oder Dritte übermittelt und alle SDKs ohne Datenerhebung arbeiten.
- Daten, die ausschließlich auf dem Gerät verbleiben, gelten nicht als "erhoben".
- Datenschutzerklärung (URL) ist in App Store Connect trotzdem anzugeben.
- Privacy-Manifest (`PrivacyInfo.xcprivacy`) und "Required Reason APIs" der eingebundenen Pakete prüfen (z. B. Dateizeitstempel, UserDefaults, Systemstartzeit).
- Bei jeder Änderung an Abhängigkeiten die Angaben neu prüfen.

## 7. Hinweise für Google Play Data Safety

- Angabe, dass keine Daten erhoben oder geteilt werden, **nur nach** abgeschlossener Verifikation (Abschnitt 8).
- Das **Data-Safety-Formular und eine verlinkte Datenschutzerklärung sind trotzdem Pflicht**, auch wenn keine Daten erhoben werden.
- Der vom Nutzer ausgelöste Backup-Export wird als Nutzeraktion beschrieben, nicht als Datenweitergabe durch die App. Die Einordnung ist rechtlich zu prüfen.
- Die deklarierten Berechtigungen müssen mit dem Formular und der Datenschutzerklärung übereinstimmen.

## 8. Offene Punkte

- [ ] INTERNET-Berechtigung im **Merged Manifest** des finalen Release-Builds (AAB) prüfen; Ergebnis hier dokumentieren.
- [ ] Netzwerk-Audit aller Pakete aus Abschnitt 4 (Quellcode, Abhängigkeitsbaum, Laufzeittest mit Netzwerkmitschnitt).
- [ ] Android-Berechtigungen im Merged Manifest abgleichen (`POST_NOTIFICATIONS`, `RECEIVE_BOOT_COMPLETED`, keine unnötigen Exact-Alarm-Rechte).
- [ ] iOS: `Info.plist`-Einträge und Privacy-Manifest prüfen.
- [ ] Entscheidung zu Geräte-Backups (iCloud / Google) der lokalen Datenbank.
- [ ] Entscheidung zur Verschlüsselung der Backup-Datei (Standard: unverschlüsselt, mit Hinweis).
- [ ] Rechtliche Einordnung der Schicht- und Gewohnheitsdaten (mögliche Gesundheitsnähe).
- [ ] Datenschutzerklärung DE/EN mit **echten Betreiberdaten** erstellen und rechtlich prüfen lassen.
- [ ] Impressum mit echten Betreiberdaten: Impressum (Tim Kremers / Resinovo, Erkelenz) in der App unter Einstellungen → Impressum; Quelle resinovo.de/impressum.
- [ ] Support-Kontakt festlegen: kontakt@resinovo.de.
- [ ] URL der Datenschutzerklärung für beide Stores: [URL – vom Auftraggeber zu ergänzen].
- [ ] Apple App Privacy und Google Data Safety erst nach Abschluss der Punkte oben ausfüllen.
- [ ] Datenkarte bei jeder Änderung von Abhängigkeiten oder Funktionen aktualisieren.
