#!/bin/bash
# ════════════════════════════════════════════════════
# FOTO-IMPORT – Karl Lotze Bildarchiv
# Komprimieren, umbenennen, verschieben, Vorlage ausgeben
# Aufruf: ./foto-import.sh
# ════════════════════════════════════════════════════

REPO=~/Desktop/karl_lotze_bilder
NEU=$REPO/fotos/neu
ZIEL=$REPO/fotos
BASIS="karl_lotze"

# Prüfen ob Dateien im Eingangsordner liegen
if [ -z "$(ls $NEU/*.{jpg,jpeg,JPG,JPEG,png,PNG,heic,HEIC} 2>/dev/null)" ]; then
  echo "Keine Bilddateien in $NEU gefunden."
  exit 1
fi

# Schritt 1: Komprimieren mit sips
echo ""
echo "Komprimiere Fotos..."
for f in $NEU/*.{jpg,jpeg,JPG,JPEG,png,PNG,heic,HEIC}; do
  [ -f "$f" ] || continue
  sips -s format jpeg -s formatOptions 75 "$f" --out "$f.compressed.jpg" > /dev/null
  mv "$f.compressed.jpg" "$f"
done

# Schritt 2: Umbenennen und in fotos/ verschieben
echo "Benenne um und verschiebe..."
i=1
for f in $(ls $NEU/*.{jpg,jpeg,JPG,JPEG,png,PNG,heic,HEIC} 2>/dev/null | sort); do
  [ -f "$f" ] || continue
  NEUER_NAME="${BASIS}_${i}.jpg"
  mv "$f" "$ZIEL/$NEUER_NAME"
  echo "  → $NEUER_NAME"
  i=$((i+1))
done

ANZAHL=$((i-1))
echo ""
echo "Fertig! $ANZAHL Fotos importiert."
echo ""

# Schritt 3: Vorlage für window._bilder ausgeben
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Vorlage für index.html – window._bilder ersetzen:"
echo ""
echo "window._bilder = ["

j=1
for f in $(ls $ZIEL/${BASIS}_*.jpg 2>/dev/null | sort -t_ -k3 -n); do
  [ -f "$f" ] || continue
  DATEINAME=$(basename "$f")
  # Komma nach jedem Eintrag außer dem letzten
  if [ $j -lt $ANZAHL ]; then
    echo "  { id: \"b$(printf '%02d' $j)\", descr: \"BESCHREIBUNG\", groesse: \"00×00 cm\", jahr: \"19XX\", foto: \"fotos/$DATEINAME\", status: \"aktiv\" },"
  else
    echo "  { id: \"b$(printf '%02d' $j)\", descr: \"BESCHREIBUNG\", groesse: \"00×00 cm\", jahr: \"19XX\", foto: \"fotos/$DATEINAME\", status: \"aktiv\" }"
  fi
  j=$((j+1))
done

echo "];"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Schritt 4: Auf GitHub hochladen
cd $REPO
git add fotos/
git commit -m "Fotos importiert: $ANZAHL Bilder (${BASIS})"
git push

