# Release-Checkliste Rytmavo

Stand: 2026-10-10 | Version: [VERSION – festzulegen] | Release-Verantwortliche/r: [NAME – vom Auftraggeber zu ergänzen]

"Rytmavo" ist ein Arbeitsname. Ein Release ist erst zulässig, wenn **alle Punkte in Abschnitt A** abgehakt sind. Punkte, die nicht geprüft wurden, bleiben unabgehakt. Kein Häkchen ohne nachvollziehbaren Beleg (Link, Protokoll, Datum).

## A. Absolute Blocker

- [ ] Markenrecherche abgeschlossen, dokumentiert und vom Auftraggeber freigegeben (`TRADEMARK_CLEARANCE.md`, Abschnitt 7). Status dort nicht mehr "OFFEN".
- [ ] Impressum mit echten Betreiberdaten vorhanden: Impressum (Tim Kremers / Resinovo, Erkelenz) in der App unter Einstellungen → Impressum; Quelle resinovo.de/impressum.
- [ ] Datenschutzerklärung DE/EN mit echten Betreiberdaten veröffentlicht und rechtlich geprüft (`PRIVACY_DATA_MAP.md`).
- [ ] Support-Kontakt festgelegt und erreichbar: kontakt@resinovo.de.
- [ ] Keine kritischen Fehler offen, kein bekannter Datenverlust (Datenbank, Backup, Import, Migration).
- [ ] Tests zu Rotationslogik (Muster, Ankerdatum, Überschreibungen, Sommer-/Winterzeit, Jahreswechsel, Nachtschicht über Mitternacht) grün.
- [ ] Tests zu Statistik und Serien (7/30 Tage, Serienberechnung, eine Erledigung je Gewohnheit und Kalendertag) grün.
- [ ] Test auf **echten Geräten, Android UND iOS** durchgeführt und protokolliert (Geräte, OS-Versionen).
- [ ] Berechtigungen verifiziert: Merged Manifest (Android) und Info.plist / Privacy-Manifest (iOS) geprüft; INTERNET-Berechtigung nicht vorhanden oder begründet.
- [ ] Store-Anforderungen (Target-API, Formulare, Metadaten, Preisstufen, Richtlinien) **zum Release-Zeitpunkt** aktuell geprüft, nicht aus dem Gedächtnis.
- [ ] Ausdrückliche Freigabe des Release durch den Auftraggeber (Datum, Name): [FREIGABE – vom Auftraggeber zu ergänzen].

## B. Qualität

### Statische Prüfungen und Tests

- [ ] `dart format --output=none --set-exit-if-changed .` ohne Änderungen.
- [ ] `flutter analyze` meldet 0 Issues.
- [ ] `flutter test` vollständig grün.
- [ ] Migrationstests: Upgrade von jeder früher ausgelieferten Datenbankversion ohne Datenverlust.
- [ ] Backup-Kompatibilität: Export und Import des versionierten JSON; ältere Backup-Versionen lesbar; defekte oder fremde Dateien werden mit verständlicher Meldung abgelehnt, ohne Daten zu überschreiben.
- [ ] "Lokale Daten löschen" und Neuinstallation getestet; Erinnerungen werden dabei entfernt.

### Erinnerungen

- [ ] Opt-in: keine Benachrichtigungsabfrage vor Aktivierung durch den Nutzer.
- [ ] Rolling-Window-Planung getestet (Neustart, Zeitzonenwechsel, Sommer-/Winterzeit, Sprachwechsel).
- [ ] Verhalten bei verweigerter Berechtigung verständlich (Hinweis, kein Absturz).
- [ ] Nicht-exakte Alarme als Standard bestätigt; Zustellverzögerung in der App-Beschreibung nicht verschwiegen.

### Barrierefreiheit

- [ ] Screenreader (TalkBack, VoiceOver): alle Elemente sinnvoll beschriftet, Lesereihenfolge korrekt.
- [ ] Textskalierung 200 %: keine abgeschnittenen oder überlappenden Texte, keine verdeckten Aktionen.
- [ ] Kontrast (hell und dunkel) mindestens WCAG AA; Schichtfarben nicht als einziger Informationsträger.
- [ ] Touch-Ziele mindestens 48 dp.
- [ ] Reduzierte Bewegung (Reduce Motion) berücksichtigt.

### Leistung und Sprachen

- [ ] Kaltstart, Monatskalender und Statistik auf einem schwachen Testgerät flüssig; keine Ruckler bei großen Datenmengen (z. B. 2 Jahre Verlauf).
- [ ] Deutsch und Englisch vollständig: keine fehlenden oder hartcodierten Texte, keine abgeschnittenen Labels, Datums- und Zahlenformate korrekt.

## C. Android

- [ ] `applicationId` final und zum freigegebenen Namen passend (nachträglich nicht änderbar).
- [ ] `versionCode` erhöht und `versionName` gesetzt.
- [ ] `targetSdk` entspricht der zum Release-Zeitpunkt gültigen Play-Store-Anforderung (verifiziert, nicht angenommen).
- [ ] Signing über lokale `key.properties` (Vorlage `android/key.properties.example`, Anleitung `docs/RELEASE.md`); **`key.properties` und Keystore nicht in Git** (`.gitignore` geprüft).
- [ ] `flutter build appbundle --release` erfolgreich; AAB auf Gerät als Release getestet.
- [ ] Merged Manifest geprüft: nur erwartete Berechtigungen (`POST_NOTIFICATIONS`, `RECEIVE_BOOT_COMPLETED`, `READ_CALENDAR`, `WRITE_CALENDAR`; kein `SCHEDULE_EXACT_ALARM` ohne Notwendigkeit; kein `INTERNET`).
- [ ] Data-Safety-Formular passend zu `PRIVACY_DATA_MAP.md` ausgefüllt.
- [ ] Preisstufe 9,99 EUR gesetzt; Länder und Währungen geprüft.
- [ ] Keine In-App-Produkte, keine Abonnements, keine Werbung angelegt oder deklariert.
- [ ] Play-Console-Pflichtangaben (App-Zugriff, Inhaltseinstufung, Zielgruppe, Werbung: nein) abgeschlossen.

## D. iOS

- [ ] Bundle ID final und zum freigegebenen Namen passend.
- [ ] Team-ID in `ios/Flutter/Signing.xcconfig` eingetragen; Signing, Provisioning und Archivierung nur auf macOS mit Xcode.
- [ ] `flutter build ipa --release` erfolgreich; Archiv validiert.
- [ ] `Info.plist`: nur Usage-Descriptions, die tatsächlich benötigt werden; keine ungenutzten Einträge.
- [ ] Privacy-Manifest und Required-Reason-APIs der Pakete geprüft.
- [ ] App-Privacy-Angaben passend zu `PRIVACY_DATA_MAP.md` ("Data Not Collected" nur nach Verifikation).
- [ ] Preisstufe (entsprechend 9,99 EUR) gesetzt; Länder geprüft.
- [ ] TestFlight nur zum Testen; Testergebnisse protokolliert.
- [ ] Keine In-App-Käufe konfiguriert.

## E. Store-Metadaten

- [ ] Screenshots (alle geforderten Geräteklassen) in DE und EN, ohne Platzhalter- oder Echtdaten Dritter.
- [ ] Beschreibung, Kurzbeschreibung und Titel in DE und EN; Name stimmt mit freigegebenem Namen überein.
- [ ] Support-URL erreichbar: [SUPPORT-URL – vom Auftraggeber zu ergänzen].
- [ ] Datenschutz-URL erreichbar: [DATENSCHUTZ-URL – vom Auftraggeber zu ergänzen].
- [ ] Altersfreigabe korrekt ausgefüllt.
- [ ] Keine irreführenden Aussagen zu Serien/Streaks, keine Gesundheits-, Heil- oder Leistungsversprechen, keine Aussagen zu Schlaf- oder Arbeitsschutz.
- [ ] Kein Verweis auf Cloud, Konto, Synchronisierung, Abo oder Werbung; Hinweis auf Offline-Nutzung und einmaligen Kauf korrekt.
- [ ] Keine geschützten Namen oder Bilder Dritter in Texten, Screenshots oder Icon.

## F. Nach dem Release

- [ ] Git-Tag mit Versionsnummer gesetzt (nur nach Freigabe).
- [ ] `CHANGELOG` aktualisiert.
- [ ] Signing-Schlüssel (Android-Keystore, Passwörter, iOS-Zertifikate) **offline gesichert**, nicht im Repository, Wiederherstellung getestet.
- [ ] Store-Seiten nach Veröffentlichung kontrolliert (Name, Preis, Texte, Screenshots, Links).
- [ ] Installation aus dem Store auf je einem Android- und einem iOS-Gerät geprüft.
- [ ] Supportweg und Eingang von Rückmeldungen beobachtet.
- [ ] Offene Punkte und bekannte Einschränkungen für die nächste Version dokumentiert.
