# Einrichtungsanleitung – Karl Lotze Bildarchiv

## Was du brauchst
- Google-Konto: akgoodnews@gmail.com ✓
- Mac mit Safari und Terminal ✓
- Visual Studio Code ✓

---

## Teil 1: Firebase einrichten (ca. 15 Minuten)

### Schritt 1 – Firebase-Projekt erstellen
1. Öffne https://console.firebase.google.com
2. Klicke auf **„Projekt hinzufügen"**
3. Projektname: `karl-lotze-bilder` → Weiter
4. Google Analytics: **deaktivieren** → Projekt erstellen
5. Warte, bis das Projekt erstellt ist → Weiter

### Schritt 2 – Web-App registrieren
1. Im Firebase-Dashboard: Klick auf das **`</>`** Symbol (Web)
2. App-Spitzname: `karl-lotze-web` → App registrieren
3. Du siehst jetzt einen Code-Block mit `firebaseConfig`. **Lass dieses Fenster offen!**

### Schritt 3 – Konfiguration in index.html eintragen
1. Öffne `index.html` in Visual Studio Code
2. Suche den Abschnitt (Zeile ~24):
   ```
   const firebaseConfig = {
     apiKey: "DEIN_API_KEY",
     ...
   ```
3. Ersetze jeden Platzhalter (`DEIN_API_KEY` usw.) mit den echten Werten aus Firebase
4. Datei speichern

### Schritt 4 – Firestore-Datenbank aktivieren
1. Im Firebase-Dashboard links: **„Firestore Database"**
2. Klicke **„Datenbank erstellen"**
3. Wähle **„Im Testmodus starten"** → Weiter
4. Region: `europe-west3 (Frankfurt)` → Fertig

### Schritt 5 – Sicherheitsregeln anpassen
Im Firestore-Dashboard → Tab **„Regeln"** → folgenden Text einfügen:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /interessen/{document=**} {
      allow read, write: if true;
    }
    match /status/{document=**} {
      allow read, write: if true;
    }
  }
}
```
→ **Veröffentlichen**

*(Hinweis: Diese Regeln erlauben allen Zugriff. Für eine Familienwebseite mit unter 30 Bildern ist das vollkommen ausreichend.)*

---

## Teil 2: Bilder vorbereiten

### Ordnerstruktur auf deinem Mac
```
karl_lotze_bilder/
  ├── index.html
  └── fotos/
       ├── b01.jpg
       ├── b02.jpg
       └── ...
```

### Bilder benennen und komprimieren
- Benenne die Fotos: `b01.jpg`, `b02.jpg`, ... (oder beliebige Namen)
- Empfohlene Größe: max. 1500px Breite, unter 500 KB pro Bild
- Komprimieren mit: https://squoosh.app (kostenlos, im Browser)

### Bilddaten in index.html eintragen
Öffne `index.html` in VS Code, suche `window._bilder` (Zeile ~43) und passe die Liste an:

```javascript
window._bilder = [
  { id: "b01", descr: "Karl im Garten, Sommer", groesse: "30×40 cm", jahr: "1952", foto: "fotos/b01.jpg", status: "aktiv" },
  { id: "b02", descr: "Porträt mit Pfeife",     groesse: "20×30 cm", jahr: "1958", foto: "fotos/b02.jpg", status: "aktiv" },
  // ...
];
```

---

## Teil 3: GitHub Pages einrichten

### Schritt 1 – Repository erstellen
1. Öffne https://github.com (mit deinem Account einloggen)
2. Klicke auf **„New repository"**
3. Repository-Name: `karl_lotze_bilder`
4. **Public** auswählen (damit GitHub Pages funktioniert)
5. → **„Create repository"**

### Schritt 2 – Dateien hochladen (Terminal)
Öffne das Terminal auf deinem Mac und führe diese Befehle aus:

```bash
# Zum Ordner navigieren (Pfad anpassen!)
cd ~/Desktop/karl_lotze_bilder

# Git initialisieren
git init
git add .
git commit -m "Erste Version"

# Mit GitHub verbinden und hochladen
git remote add origin https://github.com/andrekiberlin/karl_lotze_bilder.git
git branch -M main
git push -u origin main
```

### Schritt 3 – GitHub Pages aktivieren
1. Gehe zu deinem Repository auf GitHub
2. Klicke oben auf **„Settings"**
3. Links im Menü: **„Pages"**
4. Unter „Source": **„Deploy from a branch"**
5. Branch: **`main`** → Ordner: **`/ (root)`** → Save
6. Nach ca. 2 Minuten ist die Seite erreichbar unter:
   **https://andrekiberlin.github.io/karl_lotze_bilder/**

---

## Teil 4: Admin-Zugang

- Öffne die Webseite und klicke auf das kleine **⚙️-Symbol** oben rechts
- Passwort (kannst du in index.html ändern): `lotze2024`
- Im Admin-Panel siehst du alle Bilder mit ihren Interessenten
- Klick auf **„Vergeben"** graut das Bild für alle aus

---

## Teil 5: Nächste Runde vorbereiten

Nach jeder Runde:
1. Öffne `index.html` in VS Code
2. Ändere bei vergebenen Bildern: `status: "aktiv"` → `status: "vergeben"`
3. Speichern, dann im Terminal:
   ```bash
   cd ~/Desktop/karl_lotze_bilder
   git add .
   git commit -m "Runde 2: vergebene Bilder entfernt"
   git push
   ```
4. Schicke den Link an die nächste Gruppe

---

## Admin-Passwort ändern

In `index.html`, Zeile ~54:
```javascript
window._adminPasswort = "lotze2024";
```
Ersetze `lotze2024` durch dein gewünschtes Passwort.

---

## Häufige Probleme

| Problem | Lösung |
|---|---|
| Bilder werden nicht angezeigt | Prüfe ob der Dateiname in `fotos/` exakt mit dem Eintrag in `window._bilder` übereinstimmt (Groß-/Kleinschreibung!) |
| Firebase-Fehler in der Konsole | Prüfe ob alle Werte in `firebaseConfig` korrekt eingetragen sind |
| Änderungen nicht sichtbar | Warte 1–2 Min. nach dem Push, dann Seite hart neuladen (Cmd+Shift+R) |
| Push funktioniert nicht | GitHub fragt evtl. nach Passwort: verwende ein „Personal Access Token" (unter github.com → Settings → Developer settings) |
