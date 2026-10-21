#!/bin/bash
#
### Farbdefinitionen ####
#   TEXT in Weiss       #
#   DATEIEN in Gelb     #
#   ORDNER in HellBlau  #
#########################
# Farbdefinitionen zur Ausgabe #
ROT='\033[0;31m' 
HELLROT='\033[1;31m'
GRUEN='\033[0;32m'
HELLGRUEN='\033[1;32m'
GELB='\033[1;33m'
BLAU='\033[0;34m'
HELLBLAU='\033[1;34m'
LILA='\033[0;35m'
HELLLILA='\033[1;35m'
DUNKELESTUERKIS='\033[0;36m'
TUERKIS='\033[1;36m'
HELLGRAU='\033[0;37m'
WEISS='\033[1;37m'
NC='\033[0m' # No Color
#
cd /root
##################################################################
### NoteJS installieren
curl -fsSL https://deb.nodesource.com/setup_24.x | sudo -E bash -
apt-get install -y nodejs
node -v
npm -v
##################################################################
####### SVWS-* Clonen und Bereitstellen
echo
echo -e -n "${TUERKIS}Installation der SVWS-Dokumentation ${NC}"
echo
git clone https://github.com/SVWS-NRW/SVWS-Dokumentation.git
#
cd /root/SVWS-Dokumentation
npm i
npm run build -- --host
mkdir /var/www/html/SVWS-Dokumentation
rm -rf /var/www/html/SVWS-Dokumentation/*
cp -r .vitepress/dist/* /var/www/html/SVWS-Dokumentation/
#
echo
echo -e -n "${HELLGRUEN} OK ${NC}"
echo
sleep 2
#
echo
echo -e -n "${TUERKIS}Installation SVWS-Gradehub ${NC}"
echo
#
## SVWS-Gradehub
cd /root
git clone https://github.com/FPfotenhauer/SVWS-GradeHub
cd SVWS-GradeHub

npm i
npm run build:web
cp .env.example .env
sed -i 's/ADMINTOOL_VISIBLE=false/ADMINTOOL_VISIBLE=true/' .env
mkdir -p /var/www/html/gradehub
cp -r dist/* /var/www/html/gradehub/
#
#
echo
echo -e -n "${HELLGRUEN} OK ${NC}"
echo
sleep 2
#
echo
echo -e -n "${TUERKIS}Installation der Schulungsunterlagen ${NC}"
echo
#
cd ..
git clone https://github.com/SVWS-NRW/Schulungsunterlagen.git
#
ip a
echo
read -p  "Hier die IP-Addresse des LXCs z.B. 10.1.0.3 eintragen: " IPADDRESSE
echo
#
ORDNER="/root/Schulungsunterlagen"
SUCHE='schulverwaltungsinfos.nrw.de/svws/wiki/index.php?title='
ERSATZ="$IPADDRESSE"
find "$ORDNER" -type f -name "*.md" -print0 | while IFS= read -r -d '' file; do
    sed -i "s|$SUCHE|$ERSATZ|g" "$file"
done
cd /root/Schulungsunterlagen
#########################################################################################################################################################################################################
### BK ##################################################################################################################################################################################################
sed -i 's|Unterrichtsfächer_(Schulbezogene_Kataloge)|/SchILD30-Wiki/Unterricht_Leistungsdaten_Noten/Fächer/Unterrichtsfächer_(Schulbezogene_Kataloge).html|g' /root/Schulungsunterlagen/schulungsmodule/BK/index.md
sed -i 's|#Details_zu_den_Fächern)|#details-zu-den-fachern)|g' /root/Schulungsunterlagen/schulungsmodule/BK/index.md
sed -i 's|Stundentafel_(Schulbezogene_Kataloge)|/SchILD30-Wiki/Export_Import_Schnittstellen/Export/Stundentafel_(Schulbezogene_Kataloge).html|g' /root/Schulungsunterlagen/schulungsmodule/BK/index.md
sed -i 's|Kurse_(Schulbezogene_Kataloge)|/SchILD30-Wiki/Export_Import_Schnittstellen/Export/Kurse_(Schulbezogene_Kataloge).html|g' /root/Schulungsunterlagen/schulungsmodule/BK/index.md
sed -i 's|Kursunterrichte_anlegen_(Tutorial)|/SchILD30-Wiki/Export_Import_Schnittstellen/Export/Kursunterrichte_anlegen_(Tutorial).html|g' /root/Schulungsunterlagen/schulungsmodule/BK/index.md
sed -i 's|Schülerspezifische_Kursarten_(Schulbezogene_Kataloge)|/SchILD30-Wiki/Schüler/Stammdaten/Schülerspezifische_Kursarten_(Schulbezogene_Kataloge).html|g' /root/Schulungsunterlagen/schulungsmodule/BK/index.md
sed -i 's|Stundentafeln_zuweisen_(Gruppenprozesse_Fächer)|/SchILD30-Wiki//Unterricht_Leistungsdaten_Noten/Fächer/Stundentafeln_zuweisen_(Gruppenprozesse_Fächer).html|g' /root/Schulungsunterlagen/schulungsmodule/BK/index.md
sed -i 's|Klassenunterrichte_bearbeiten_(Gruppenprozesse_Fächer)|/SchILD30-Wiki/Unterricht_Leistungsdaten_Noten/Fächer/Klassenunterrichte_bearbeiten_(Gruppenprozesse_Fächer).html|g' /root/Schulungsunterlagen/schulungsmodule/BK/index.md
sed -i 's|Unterrichts-Daten_(als_Excel-Daten)_(Verwaltung_Import)|/SchILD30-Wiki/Verwaltung_Administration/Unterrichts-Daten_(als_Excel-Daten)_(Verwaltung_Import).html|g' /root/Schulungsunterlagen/schulungsmodule/BK/index.md
sed -i 's|Details_zu_Fächern_bei_Schülern_ändern_(Gruppenprozesse_Fächer)|/SchILD30-Wiki/Schüler/Stammdaten/Details_zu_Fächern_bei_Schülern_ändern_(Gruppenprozesse_Fächer).html|g' /root/Schulungsunterlagen/schulungsmodule/BK/index.md
sed -i 's|Noten,_Mahnungen_und_Fehlstd._eingeben_(Gruppenprozesse_Noten,_Zeugnisvorbereitung)|/SchILD30-Wiki/Unterricht_Leistungsdaten_Noten/Noten/Noten,_Mahnungen_und_Fehlstd._eingeben_(Gruppenprozesse_Noten,_Zeugnisvorbereitung).html|g' /root/Schulungsunterlagen/schulungsmodule/BK/index.md
sed -i 's|Zeugnisvorbereitungen_und_Zeugnisdruck_(Einführung_in_SchILD-NRW)|/SchILD30-Wiki/Einführung_Grundlagen/Allgemein/Zeugnisvorbereitungen_und_Zeugnisdruck_(Einführung_in_SchILD-NRW).html|g' /root/Schulungsunterlagen/schulungsmodule/BK/index.md
sed -i 's|Installation_des_Externen_Notenmoduls_(Tutorial)|/SchILD30-Wiki/Installation_und_System/SchILD/Installation_des_Externen_Notenmoduls_(Tutorial).html|g' /root/Schulungsunterlagen/schulungsmodule/BK/index.md
sed -i 's|Verwendung_des_Externen_Notenmoduls_(Tutorial)|/SchILD30-Wiki/Unterricht_Leistungsdaten_Noten/Noten/Verwendung_des_Externen_Notenmoduls_(Tutorial).html|g' /root/Schulungsunterlagen/schulungsmodule/BK/index.md
sed -i 's|Dokumentenverwaltung_(Schüler)|/SchILD30-Wiki/Verwaltung_Administration/Dokumentenverwaltung_(Schüler).html|g' /root/Schulungsunterlagen/schulungsmodule/BK/index.md
sed -i 's|Versetzung_ins_neue_Schuljahr_und_Abschnittswechsel_durchführen_(Einführung_in_SchILD-NRW)|/SchILD30-Wiki/Einführung_Grundlagen/Allgemein/Versetzung_ins_neue_Schuljahr_und_Abschnittswechsel_durchführen_(Einführung_in_SchILD-NRW).html|g' /root/Schulungsunterlagen/schulungsmodule/BK/index.md
sed -i 's|#Abschnittswechsel_ohne_Versetzung_(Halbjahreswechsel)|#abschnittswechsel-ohne-versetzung-halbjahreswechsel-findet-ein-abschnittswechsel-vom-1-ins-2-halbjahr-statt-wird-keine|g' /root/Schulungsunterlagen/schulungsmodule/BK/index.md
sed -i 's|Noten,_Mahnungen_und_Fehlstd._eingeben_(Gruppenprozesse_Noten,_Zeugnisvorbereitung)|/SchILD30-Wiki/Installation_und_System/SchILD/Installation_des_Externen_Notenmoduls_(Tutorial).html|g' /root/Schulungsunterlagen/schulungsmodule/BK/index.md
sed -i 's|Mahnbriefe_drucken_(Tutorial)|/SchILD30-Wiki/Export_Import_Schnittstellen/Export/Mahnbriefe_drucken_(Tutorial).html|g' /root/Schulungsunterlagen/schulungsmodule/BK/index.md
sed -i 's|Abschluss_berechnen_(Gruppenprozesse_BK-Abschluss)|/SchILD30-Wiki/Zeugnisse_Abschlüsse/Zeugnisse/Abschluss_berechnen_(Gruppenprozesse_BK-Abschluss).html|g' /root/Schulungsunterlagen/schulungsmodule/BK/index.md
sed -i 's|#Administration_von_ScHILD_als_Vorbereitung|#administration-von-schild-als-vorbereitung|g' /root/Schulungsunterlagen/schulungsmodule/BK/index.md
sed -i 's|#Gegebenenfalls_Abfrage_an_Schüler|#gegebenenfalls-abfrage-an-schuler|g' /root/Schulungsunterlagen/schulungsmodule/BK/index.md
sed -i 's|#Überprüfung_der_angelegten_Leistungsdaten|/#uberprufung-der-angelegten-leistungsdaten|g' /root/Schulungsunterlagen/schulungsmodule/BK/index.md
sed -i 's|#Noteneintragung|/#noteneintragung|g' /root/Schulungsunterlagen/schulungsmodule/BK/index.md
sed -i 's|#Teilleistungen,_Projektkursarbeiten,_...|#teilleistungen-projektkursarbeiten|g' /root/Schulungsunterlagen/schulungsmodule/BK/index.md
sed -i 's|#Zeugnisbemerkungen|#zeugnisbemerkungen|g' /root/Schulungsunterlagen/schulungsmodule/BK/index.md
sed -i 's|#Fehlstundenberechnung|#fehlstundenberechnung|g' /root/Schulungsunterlagen/schulungsmodule/BK/index.md
sed -i 's|#Eingabe_von_Konferenz-_und_Zeugnisdatum|#eingabe-von-konferenz-und-zeugnisdatum|g' /root/Schulungsunterlagen/schulungsmodule/BK/index.md
sed -i 's|#Sonstiges|#sonstiges|g' /root/Schulungsunterlagen/schulungsmodule/BK/index.md
sed -i 's|#Versetzungsberechnung|#versetzungsberechnung|g' /root/Schulungsunterlagen/schulungsmodule/BK/index.md
sed -i 's|#Überweisungszeugnisse,_Abgangs-_und_Abschlusszeugnisse|#uberweisungszeugnisse-abgangs-und-abschlusszeugnisse|g' /root/Schulungsunterlagen/schulungsmodule/BK/index.md
sed -i 's|Abgeschlossene_Fächer_holen_(Gruppenprozesse_Noten,_Zeugnisvorbereitung)|/SchILD30-Wiki/Unterricht_Leistungsdaten_Noten/Noten/Abgeschlossene_Fächer_holen_(Gruppenprozesse_Noten,_Zeugnisvorbereitung).html|g' /root/Schulungsunterlagen/schulungsmodule/BK/index.md
sed -i 's|Sprach-Referenzniveaus_ermitteln_(Gruppenprozesse_Allgemein)|/SchILD30-Wiki/Export_Import_Schnittstellen/Export/Sprach-Referenzniveaus_ermitteln_(Gruppenprozesse_Allgemein).html|g' /root/Schulungsunterlagen/schulungsmodule/BK/index.md
sed -i 's|#Zeugnisdruck_und_Archivierung|#zeugnisdruck-und-archivierung|g' /root/Schulungsunterlagen/schulungsmodule/BK/index.md
sed -i 's|Beliebte_Fehler_beim_Zeugnisdruck_(Tutorial)|/SchILD30-Wiki/Zeugnisse_Abschlüsse/Zeugnisse/Beliebte_Fehler_beim_Zeugnisdruck_(Tutorial).html|g' /root/Schulungsunterlagen/schulungsmodule/BK/index.md
sed -i 's|Versetzung/Übertrag_ins_neue_Halbjahr_oder_Abschluss_(Gruppenprozesse_Lernabschnitte,_Versetzung)|/SchILD30-Wiki/Zeugnisse_Abschlüsse/Zeugnisse/Versetzung_Übertrag_ins_neue_Halbjahr_oder_Abschluss_(Gruppenprozesse_Lernabschnitte,_Versetzung).html|g' /root/Schulungsunterlagen/schulungsmodule/BK/index.md
#######################################################################################################################################################################################################
#### SEK I
sed -i 's|Unterrichtsf%C3%A4cher_(Schulbezogene_Kataloge)|/SchILD30-Wiki/Unterricht_Leistungsdaten_Noten/Fächer/Unterrichtsfächer_(Schulbezogene_Kataloge).html|g' /root/Schulungsunterlagen/schulungsmodule/sek_i/index.md
sed -i 's|#Details_zu_den_F%C3%A4chern)|#details-zu-den-fachern)|g' /root/Schulungsunterlagen/schulungsmodule/sek_i/index.md
sed -i 's|Stundentafel_(Schulbezogene_Kataloge)|/SchILD30-Wiki/Export_Import_Schnittstellen/Export/Stundentafel_(Schulbezogene_Kataloge).html|g' /root/Schulungsunterlagen/schulungsmodule/sek_i/index.md
sed -i 's|Kurse_(Schulbezogene_Kataloge)|/SchILD30-Wiki/Export_Import_Schnittstellen/Export/Kurse_(Schulbezogene_Kataloge).html|g' /root/Schulungsunterlagen/schulungsmodule/sek_i/index.md
sed -i 's|Kursunterrichte_anlegen_(Tutorial)|/SchILD30-Wiki/Export_Import_Schnittstellen/Export/Kursunterrichte_anlegen_(Tutorial).html|g' /root/Schulungsunterlagen/schulungsmodule/sek_i/index.md
sed -i 's|Sch%C3%BClerspezifische_Kursarten_(Schulbezogene_Kataloge)|/SchILD30-Wiki/Schüler/Stammdaten/Schülerspezifische_Kursarten_(Schulbezogene_Kataloge).html|g' /root/Schulungsunterlagen/schulungsmodule/sek_i/index.md
sed -i 's|Stundentafeln_zuweisen_(Gruppenprozesse_F%C3%A4cher)|/SchILD30-Wiki//Unterricht_Leistungsdaten_Noten/Fächer/Stundentafeln_zuweisen_(Gruppenprozesse_Fächer).html|g' /root/Schulungsunterlagen/schulungsmodule/sek_i/index.md
sed -i 's|Klassenunterrichte_bearbeiten_(Gruppenprozesse_F%C3%A4cher)|/SchILD30-Wiki/Unterricht_Leistungsdaten_Noten/Fächer/Klassenunterrichte_bearbeiten_(Gruppenprozesse_Fächer).html|g' /root/Schulungsunterlagen/schulungsmodule/sek_i/index.md
sed -i 's|Unterrichts-Daten_(als_Excel-Daten)_(Verwaltung_Import)|/SchILD30-Wiki/Verwaltung_Administration/Unterrichts-Daten_(als_Excel-Daten)_(Verwaltung_Import).html|g' /root/Schulungsunterlagen/schulungsmodule/sek_i/index.md
sed -i 's|Details_zu_F%C3%A4chern_bei_Schülern_%C3%A4ndern_(Gruppenprozesse_F%C3%A4cher)|/SchILD30-Wiki/Schüler/Stammdaten/Details_zu_Fächern_bei_Schülern_ändern_(Gruppenprozesse_Fächer).html|g' /root/Schulungsunterlagen/schulungsmodule/sek_i/index.md
sed -i 's|Noten,_Mahnungen_und_Fehlstd._eingeben_(Gruppenprozesse_Noten,_Zeugnisvorbereitung)|/SchILD30-Wiki/Unterricht_Leistungsdaten_Noten/Noten/Noten,_Mahnungen_und_Fehlstd._eingeben_(Gruppenprozesse_Noten,_Zeugnisvorbereitung).html|g' /root/Schulungsunterlagen/schulungsmodule/sek_i/index.md
sed -i 's|Zeugnisvorbereitungen_und_Zeugnisdruck_(Einführung_in_SchILD-NRW)|/SchILD30-Wiki/Einführung_Grundlagen/Allgemein/Zeugnisvorbereitungen_und_Zeugnisdruck_(Einführung_in_SchILD-NRW).html|g' /root/Schulungsunterlagen/schulungsmodule/sek_i/index.md
sed -i 's|Installation_des_Externen_Notenmoduls_(Tutorial)|/SchILD30-Wiki/Installation_und_System/SchILD/Installation_des_Externen_Notenmoduls_(Tutorial).html|g' /root/Schulungsunterlagen/schulungsmodule/sek_i/index.md
sed -i 's|Verwendung_des_Externen_Notenmoduls_(Tutorial)|/SchILD30-Wiki/Unterricht_Leistungsdaten_Noten/Noten/Verwendung_des_Externen_Notenmoduls_(Tutorial).html|g' /root/Schulungsunterlagen/schulungsmodule/sek_i/index.md
sed -i 's|Dokumentenverwaltung_(Schüler)|/SchILD30-Wiki/Verwaltung_Administration/Dokumentenverwaltung_(Schüler).html|g' /root/Schulungsunterlagen/schulungsmodule/sek_i/index.md
sed -i 's|Versetzung_ins_neue_Schuljahr_und_Abschnittswechsel_durchführen_(Einführung_in_SchILD-NRW)|/SchILD30-Wiki/Einführung_Grundlagen/Allgemein/Versetzung_ins_neue_Schuljahr_und_Abschnittswechsel_durchführen_(Einführung_in_SchILD-NRW).html|g' /root/Schulungsunterlagen/schulungsmodule/sek_i/index.md
sed -i 's|#Abschnittswechsel_ohne_Versetzung_(Halbjahreswechsel)|#abschnittswechsel-ohne-versetzung-halbjahreswechsel-findet-ein-abschnittswechsel-vom-1-ins-2-halbjahr-statt-wird-keine|g' /root/Schulungsunterlagen/schulungsmodule/sek_i/index.md
sed -i 's|Noten,_Mahnungen_und_Fehlstd._eingeben_(Gruppenprozesse_Noten,_Zeugnisvorbereitung)|/SchILD30-Wiki/Installation_und_System/SchILD/Installation_des_Externen_Notenmoduls_(Tutorial).html|g' /root/Schulungsunterlagen/schulungsmodule/sek_i/index.md
sed -i 's|Mahnbriefe_drucken_(Tutorial)|/SchILD30-Wiki/Export_Import_Schnittstellen/Export/Mahnbriefe_drucken_(Tutorial).html|g' /root/Schulungsunterlagen/schulungsmodule/sek_i/index.md
sed -i 's|Abschluss_berechnen_(Gruppenprozesse_BK-Abschluss)|/SchILD30-Wiki/Zeugnisse_Abschlüsse/Zeugnisse/Abschluss_berechnen_(Gruppenprozesse_BK-Abschluss).html|g' /root/Schulungsunterlagen/schulungsmodule/sek_i/index.md
sed -i 's|#Administration_von_ScHILD_als_Vorbereitung|#administration-von-schild-als-vorbereitung|g' /root/Schulungsunterlagen/schulungsmodule/sek_i/index.md
sed -i 's|#Gegebenenfalls_Abfrage_an_Schüler|#gegebenenfalls-abfrage-an-schuler|g' /root/Schulungsunterlagen/schulungsmodule/sek_i/index.md
sed -i 's|#Überprüfung_der_angelegten_Leistungsdaten|/#uberprufung-der-angelegten-leistungsdaten|g' /root/Schulungsunterlagen/schulungsmodule/sek_i/index.md
sed -i 's|#Noteneintragung|/#noteneintragung|g' /root/Schulungsunterlagen/schulungsmodule/sek_i/index.md
sed -i 's|#Teilleistungen,_Projektkursarbeiten,_...|#teilleistungen-projektkursarbeiten|g' /root/Schulungsunterlagen/schulungsmodule/sek_i/index.md
sed -i 's|#Zeugnisbemerkungen|#zeugnisbemerkungen|g' /root/Schulungsunterlagen/schulungsmodule/sek_i/index.md
sed -i 's|#Fehlstundenberechnung|#fehlstundenberechnung|g' /root/Schulungsunterlagen/schulungsmodule/sek_i/index.md
sed -i 's|#Eingabe_von_Konferenz-_und_Zeugnisdatum|#eingabe-von-konferenz-und-zeugnisdatum|g' /root/Schulungsunterlagen/schulungsmodule/sek_i/index.md
sed -i 's|#Sonstiges|#sonstiges|g' /root/Schulungsunterlagen/schulungsmodule/sek_i/index.md
sed -i 's|#Versetzungsberechnung|#versetzungsberechnung|g' /root/Schulungsunterlagen/schulungsmodule/sek_i/index.md
sed -i 's|#Überweisungszeugnisse,_Abgangs-_und_Abschlusszeugnisse|#uberweisungszeugnisse-abgangs-und-abschlusszeugnisse|g' /root/Schulungsunterlagen/schulungsmodule/sek_i/index.md
sed -i 's|Abgeschlossene_F%C3%A4cher_holen_(Gruppenprozesse_Noten,_Zeugnisvorbereitung)|/SchILD30-Wiki/Unterricht_Leistungsdaten_Noten/Noten/Abgeschlossene_Fächer_holen_(Gruppenprozesse_Noten,_Zeugnisvorbereitung).html|g' /root/Schulungsunterlagen/schulungsmodule/sek_i/index.md
sed -i 's|Sprach-Referenzniveaus_ermitteln_(Gruppenprozesse_Allgemein)|/SchILD30-Wiki/Export_Import_Schnittstellen/Export/Sprach-Referenzniveaus_ermitteln_(Gruppenprozesse_Allgemein).html|g' /root/Schulungsunterlagen/schulungsmodule/sek_i/index.md
sed -i 's|#Zeugnisdruck_und_Archivierung|#zeugnisdruck-und-archivierung|g' /root/Schulungsunterlagen/schulungsmodule/sek_i/index.md
sed -i 's|Beliebte_Fehler_beim_Zeugnisdruck_(Tutorial)|/SchILD30-Wiki/Zeugnisse_Abschlüsse/Zeugnisse/Beliebte_Fehler_beim_Zeugnisdruck_(Tutorial).html|g' /root/Schulungsunterlagen/schulungsmodule/sek_i/index.md
sed -i 's|Versetzung/Übertrag_ins_neue_Halbjahr_oder_Abschluss_(Gruppenprozesse_Lernabschnitte,_Versetzung)|/SchILD30-Wiki/Zeugnisse_Abschlüsse/Zeugnisse/Versetzung_Übertrag_ins_neue_Halbjahr_oder_Abschluss_(Gruppenprozesse_Lernabschnitte,_Versetzung).html|g' /root/Schulungsunterlagen/schulungsmodule/sek_i/index.md
#######################################################################################################################################################################################################
cd /root/Schulungsunterlagen
npm i
npm run build -- --host
mkdir /var/www/html/Schulungsunterlagen
rm -rf /var/www/html/Schulungsunterlagen/*
cp -r .vitepress/dist/* /var/www/html/Schulungsunterlagen/
#
echo
echo -e -n "${HELLGRUEN} OK ${NC}"
echo
sleep 2
#
echo
echo -e -n "${TUERKIS}Installation der SchILD30-Wiki ${NC}"
echo
#
cd /root
git clone https://github.com/TheoRichter/SchILD30-Wiki.git
# Automatische VitePress-Vorbereitung + Build + Deployment
# für SchILD30-Wiki

PROJECT_DIR="$HOME/SchILD30-Wiki"
SOURCE_DIR="$PROJECT_DIR"
DOCS_DIR="$PROJECT_DIR/docs"
WEB_DIR="/var/www/html/SchILD30-Wiki"

set -e


echo "=== Starte automatische VitePress-Vorbereitung ==="

# Projekt prüfen
if [ ! -d "$PROJECT_DIR" ]; then
  echo "Fehler: Projektordner nicht gefunden: $PROJECT_DIR"
  exit 1
fi

cd "$PROJECT_DIR"

# package.json
if [ ! -f package.json ]; then
  echo "Erzeuge package.json..."
  npm init -y
fi

# VitePress installieren
if ! npm list vitepress >/dev/null 2>&1; then
  echo "Installiere VitePress..."
  npm install vitepress --save-dev
fi

mkdir -p "$DOCS_DIR/.vitepress"

############################################
# ROOT index.md automatisch erzeugen
############################################

# README.md als Startseite verwenden, falls vorhanden
if [ -f "$PROJECT_DIR/README.md" ]; then
  cp "$PROJECT_DIR/README.md" "$DOCS_DIR/index.md"
else
  echo "# SchILD30-Wiki" > "$DOCS_DIR/index.md"
  echo "" >> "$DOCS_DIR/index.md"
fi

echo "" >> "$DOCS_DIR/index.md"


############################################
# Unterordner erkennen + index.md erzeugen
############################################

# Markdown-Unterordner aus dem gesamten Projekt übernehmen
# (außer docs selbst)
for src in "$SOURCE_DIR"/*/; do
  [ -d "$src" ] || continue

  folder=$(basename "$src")

  if [ "$folder" = "docs" ] || [ "$folder" = "node_modules" ]; then
    continue
  fi

  mkdir -p "$DOCS_DIR/$folder/"

  # Ganze Ordnerstruktur inkl. Bilder/PNG/JPG/GIF/SVG rekursiv kopieren
  rsync -a \
    --include='*/' \
    --include='*.md' \
    --include='*.png' \
    --include='*.jpg' \
    --include='*.jpeg' \
    --include='*.gif' \
    --include='*.svg' \
    --exclude='*' \
    "${src}/" "$DOCS_DIR/$folder/" >/dev/null 2>&1 || true

    # Spezialfall: graphics komplett vollständig übernehmen
  if [ "$folder" = "graphics" ]; then
    mkdir -p "$DOCS_DIR/graphics"
    cp -r "${src}/"* "$DOCS_DIR/graphics/" 2>/dev/null || true
  fi

  # Danach Markdown-Dateien zusätzlich sauber nachziehen

    # Alle Markdown-Dateien inkl. Unterordner rekursiv kopieren
  find "$src" -type f -name "*.md" | while read file; do
    rel_path="${file#$src}"
    target_dir="$DOCS_DIR/$folder/$(dirname "$rel_path")"

    mkdir -p "$target_dir"
    cp -f "$file" "$target_dir/"
  done

done

# Danach docs-Unterordner verarbeiten
for dir in "$DOCS_DIR"/*/; do
  [ -d "$dir" ] || continue

  folder=$(basename "$dir")
  index_file="$dir/index.md"

  echo "Bearbeite Ordner: $folder"

  # Kein automatischer Bereich-Block in README/index

  # Unterordner index.md erzeugen
  echo "# $folder" > "$index_file"
  echo "" >> "$index_file"
  echo "## Inhalte" >> "$index_file"
  echo "" >> "$index_file"

  for file in "$dir"*.md; do
    [ -f "$file" ] || continue

    filename=$(basename "$file")

    if [ "$filename" != "index.md" ]; then
      name="${filename%.md}"
      echo "- [$name](./$filename)" >> "$index_file"
    fi
  done

done

############################################
# config.mjs erzeugen
############################################

cat > "$DOCS_DIR/.vitepress/config.mjs" << 'EOF'
import { defineConfig, loadEnv } from 'vite'

export default defineConfig(({ mode }) => {
  const env = loadEnv(mode, process.cwd(), '')

  return {
    base: env.BASE === undefined ? '/SchILD30-Wiki/' : env.BASE,
    title: 'SchILD-NRW 3',
    description: 'Erklärungen und Funktionsweisen zu Schulungen für SchILD3',
    lastUpdated: true,

    themeConfig: {
      outline: {
        label: 'Auf dieser Seite',
      },

      docFooter: {
        next: 'Nächste Seite',
        prev: 'Vorherige Seite',
      },

      lastUpdated: {
        text: 'Diese Seite wurde zuletzt bearbeitet am',
        formatOptions: {
          dateStyle: 'full',
          timeStyle: 'medium',
        },
      },

      search: {
        provider: 'local',
      },

      

      sidebar: [
        {
          text: 'Dokumentation',
          items: [
            { text: 'Start', link: '/' }
          ]
        }
      ]
    }
  }
})
EOF

############################################
############################################
# generate-sidebar.js erzeugen
############################################

cat > "$PROJECT_DIR/generate-sidebar.js" << 'EOF'
const fs = require('fs')
const path = require('path')

const docsDir = path.join(__dirname, 'docs')

function cleanName(name) {
  return name
    .replace(/\.md$/, '')
    .replace(/_/g, ' ')
    .replace(/-/g, ' ')
}

function buildSidebar(dir, base = '') {
  const entries = fs.readdirSync(dir, { withFileTypes: true })

  const dirs = entries
    .filter(e => 
      e.isDirectory() &&
      e.name !== '.vitepress' &&
      e.name !== 'graphics'
    )
    .sort((a, b) => a.name.localeCompare(b.name))

  const files = entries
    .filter(e => e.isFile() && e.name.endsWith('.md') && e.name !== 'index.md')
    .sort((a, b) => a.name.localeCompare(b.name))

  const items = []

  // Erst Unterordner vollständig erzeugen
  for (const folder of dirs) {
    const folderPath = path.join(dir, folder.name)
    const childBase = `${base}/${folder.name}`
    const childItems = buildSidebar(folderPath, childBase)

    items.push({
      text: cleanName(folder.name),
      collapsed: true,
      
      items: childItems
    })
  }

  // Danach einzelne MD-Dateien hinzufügen
  for (const file of files) {
    const name = file.name.replace(/\.md$/, '')

    items.push({
      text: cleanName(name),
      link: `${base}/${name}`
    })
  }

  return items
}

const sidebar = buildSidebar(docsDir, '')

const config = `import { defineConfig, loadEnv } from 'vite'

export default defineConfig(({ mode }) => {
  const env = loadEnv(mode, process.cwd(), '')

  return {
    base: env.BASE === undefined ? '/SchILD30-Wiki/' : env.BASE,
    title: 'SchILD-NRW 3',
    description: 'Erklärungen und Funktionsweisen zu Schulungen für SchILD3',
    lastUpdated: true,

    themeConfig: {
      outline: {
        label: 'Auf dieser Seite',
      },

      docFooter: {
        next: 'Nächste Seite',
        prev: 'Vorherige Seite',
      },

      lastUpdated: {
        text: 'Diese Seite wurde zuletzt bearbeitet am',
        formatOptions: {
          dateStyle: 'full',
          timeStyle: 'medium',
        },
      },

      search: {
        provider: 'local',
      },

      nav: [],

      sidebar: ${JSON.stringify(sidebar, null, 2)}
    }
  }
})
`

fs.writeFileSync(
  path.join(docsDir, '.vitepress', 'config.mjs'),
  config,
  'utf8'
)

console.log('config.mjs mit vollständiger Sidebar erzeugt.')
EOF

node "$PROJECT_DIR/generate-sidebar.js"

############################################
# Build
############################################

echo "=== Starte VitePress Build ==="
npx vitepress build docs

############################################
# Deployment
############################################

sudo mkdir -p "$WEB_DIR"
sudo rm -rf "$WEB_DIR"/*
sudo cp -r "$DOCS_DIR/.vitepress/dist"/* "$WEB_DIR"/

sudo chown -R www-data:www-data "$WEB_DIR"
sudo chmod -R 755 "$WEB_DIR"
echo
echo -e -n "${HELLGRUEN}=== Deployment abgeschlossen === ${NC}"
echo
sleep 2

