#!/bin/bash
################################################################
### LPMultiwahl in vorhandene STACKs nachruesten             ###
### 1. haengt in schulungen.txt den LP-Port :82xx an         ###
### 2. laedt LPMultiwahl.zip in jeden STACK und entpackt es  ###
### 3. verschiebt multiwahl/ nach www/multiwahl              ###
### 4. traegt Port 82xx:7443 und das Volume ein              ###
### 5. startet den Webserver-Container neu                   ###
###                                                          ###
### Aufruf: bash LPMultiwahl-Nachruesten.sh <URL>            ###
################################################################
ROT='\033[1;31m'
GRUEN='\033[1;32m'
GELB='\033[1;33m'
WEISS='\033[1;37m'
NC='\033[0m' # No Color

URL="$1"
QUELLE="/root/schulungen.txt"
WEB="/var/www/html"
VOLUME="./apache/multiwahl-ssl.conf:/etc/apache2/sites-enabled/multiwahl-ssl.conf"

################################################################
### Port und Volume beim Dienst "webserver" eintragen        ###
### (nur, was noch fehlt). Liest $1, schreibt auf stdout,    ###
### Rueckgabe 1, wenn etwas nicht eingetragen werden konnte. ###
################################################################
compose_ergaenzen() {
  awk -v vol="$VOLUME" -v port="$2:7443" '
  function einzug(s) { match(s, /^ */); return RLENGTH }
  function liste(k,  s) {   # Einzug der Listeneintraege unter Zeile k
    s = z[k + 1]
    if (s ~ /^ *- /) return substr(s, 1, einzug(s))
    return substr(z[k], 1, einzug(z[k])) "  "
  }
  { sub(/\r$/, ""); z[NR] = $0 }
  END {
    for (i = 1; i <= NR; i++) {
      if (!start && z[i] ~ /^ +webserver: *$/) { start = i; tiefe = einzug(z[i]); ende = NR; continue }
      if (start && z[i] !~ /^ *(#.*)?$/ && einzug(z[i]) <= tiefe) { ende = i - 1; break }
    }
    if (!start) exit 1
    for (i = start; i <= ende; i++) {
      if (z[i] ~ /^ *- / && index(z[i], "multiwahl-ssl.conf:")) vda = 1
      if (z[i] ~ /^ *- / && z[i] ~ ("[^0-9]" port "[^0-9]*$")) pda = 1
    }
    for (i = 1; i <= NR; i++) {
      print z[i]
      if (i <= start || i > ende) continue
      if (!vda && z[i] ~ /^ +volumes: *$/) { print liste(i) "- " vol; vda = 1 }
      if (!pda && z[i] ~ /^ +ports: *$/)   { print liste(i) "- \"" port "\""; pda = 1 }
    }
    if (!vda || !pda) exit 1
  }' "$1"
}

################################################################
### Einen STACK bearbeiten (im Ordner pc-xx/pc-xx)           ###
################################################################
stack_bearbeiten() {
  # unzip -o : ueberschreibt ohne Rueckfrage
  if ! wget -q --show-progress -O LPMultiwahl.zip "http://$URL/LPMultiwahl.zip" || ! unzip -qo LPMultiwahl.zip; then
    rm -f LPMultiwahl.zip
    echo -e "${ROT}$STACK: Download oder Entpacken fehlgeschlagen${NC}"
    return 1
  fi
  rm -f LPMultiwahl.zip

################################################################################
### index.html  ################################################################
sed -i 's/SERVERNAME/'$SERVERNAME'/g' tools/start/index.html                 ###
sed -i 's/SVWSPort/'$SVWSPort'/g' tools/start/index.html                     ###
sed -i 's/LPPort/'$LPPort'/g' tools/start/index.html                         ###
sed -i 's/WebServerPortHTTPS/'$WebServerPortHTTPS'/g' tools/start/index.html ###
################################################################################

  # Apache erwartet die Seite unter www/multiwahl
  if [ -d multiwahl ]; then
    mkdir -p www/multiwahl && cp -rf multiwahl/. www/multiwahl/ && rm -rf multiwahl || return 1
  fi
  if [ ! -f www/multiwahl/index.php ] || [ ! -f apache/multiwahl-ssl.conf ]; then
    echo -e "${ROT}$STACK: www/multiwahl oder apache/multiwahl-ssl.conf fehlt${NC}"
    return 1
  fi
  chown -R www-data:www-data www/multiwahl

  if [ -f docker-compose-wenom.yml ]; then
### docker-compose-wenom.yml ###########################################
sed -i 's/00002/'$WebServerPortHTTP'/g' docker-compose-wenom.yml     ###
sed -i 's/00003/'$WebServerPortHTTPS'/g' docker-compose-wenom.yml    ###
sed -i 's/00005/'$LPPort'/g' docker-compose-wenom.yml                ###
sed -i 's/WebServerName/'$WebServerName'/g' docker-compose-wenom.yml ###
########################################################################
  fi
  if [ ! -f docker-compose.yml ]; then
    echo -e "${ROT}$STACK: keine docker-compose.yml vorhanden${NC}"
    return 1
  fi

  # Port und Volume in einer Kopie eintragen und pruefen.
  # Erst wenn sie gueltig ist, wird die docker-compose.yml gesichert und ersetzt.
  if ! compose_ergaenzen docker-compose.yml "$LPPort" > docker-compose.yml.neu \
     || ! docker compose -f docker-compose.yml.neu config -q </dev/null; then
    rm -f docker-compose.yml.neu
    echo -e "${ROT}$STACK: Port/Volume nicht eintragbar, docker-compose.yml unveraendert, kein Neustart${NC}"
    return 1
  fi
  cp -p docker-compose.yml "docker-compose.yml.bak-$(date +%Y%m%d-%H%M%S)" \
    && cat docker-compose.yml.neu > docker-compose.yml || return 1
  rm -f docker-compose.yml.neu

  # nur den Webserver neu erstellen, MariaDB und SVWS laufen weiter
  if ! docker compose up -d --force-recreate webserver </dev/null; then
    echo -e "${ROT}$STACK: Container konnte nicht gestartet werden${NC}"
    return 1
  fi
  echo -e "${GRUEN}OK: https://$SERVERNAME:$LPPort/${NC}"
}

if [ -z "$URL" ]; then
  echo -e "${ROT}Aufruf: bash $0 <URL>   (ohne http://)${NC}"
  exit 1
fi
if [ ! -f "$QUELLE" ]; then
  echo -e "${ROT}Datei $QUELLE nicht gefunden.${NC}"
  exit 1
fi
if ! command -v unzip >/dev/null; then
  echo -e "${ROT}unzip ist nicht installiert.${NC}"
  exit 1
fi
if ! docker compose version >/dev/null 2>&1; then
  echo -e "${ROT}docker compose ist nicht verfuegbar.${NC}"
  exit 1
fi

################################################################
### Eingabe                                                  ###
################################################################
echo
read -p  "Nummer des ersten Rechners: " ANFANG
read -p  "Nummer des letzten Rechners: " ENDE

if ! [[ "$ANFANG" =~ ^[0-9]{1,2}$ && "$ENDE" =~ ^[0-9]{1,2}$ ]]; then
  echo -e "${ROT}Bitte nur Zahlen von 1 bis 99 eingeben.${NC}"
  exit 1
fi
# 10# : sonst wuerden 08 und 09 als (ungueltige) Oktalzahl gelesen
ANFANG=$((10#$ANFANG))
ENDE=$((10#$ENDE))
if (( ANFANG < 1 || ANFANG > ENDE )); then
  echo -e "${ROT}Der erste Rechner muss zwischen 1 und $ENDE liegen.${NC}"
  exit 1
fi

################################################################
### schulungen.txt: 82xx am Zeilenende anhaengen             ###
### Zeilen, die den Port schon haben, bleiben unveraendert.  ###
################################################################
cp -p "$QUELLE" "$QUELLE.bak-$(date +%Y%m%d-%H%M%S)" || exit 1
TMP="$(mktemp)"
trap 'rm -f "$TMP"' EXIT

awk -v anfang="$ANFANG" -v ende="$ENDE" '
BEGIN { FS = OFS = ":" }
{ sub(/\r$/, "") }
$1 ~ /^pc-[0-9][0-9]$/ {
  nr = substr($1, 4) + 0
  if (nr >= anfang && nr <= ende && NF >= 10 && $11 == "")
    $11 = "82" substr($1, 4)
}
{ print }' "$QUELLE" > "$TMP" || exit 1

cat "$TMP" > "$QUELLE" || exit 1
cp "$QUELLE" "$WEB"
cp "$QUELLE" "$WEB/sh"
cp "$QUELLE" "$WEB/docker"
echo -e "${WEISS}### ${GELB}schulungen.txt${WEISS} wurde ergaenzt ###${NC}"

################################################################
cd "$WEB/docker" || exit 1
################################################################
FEHLER=0
ANZAHL=0
# Lesen ueber Kanal 3, damit wget/unzip der Schleife keine Zeilen wegnehmen
while read -r ZEILE <&3 || [ -n "$ZEILE" ]; do
  STACK=$(echo "$ZEILE" | awk -F : '{print $1}')
  MariaDBPort=$(echo "$ZEILE" | awk -F : '{print $2}')
  WebServerPortHTTP=$(echo "$ZEILE" | awk -F : '{print $3}')
  WebServerPortHTTPS=$(echo "$ZEILE" | awk -F : '{print $4}')
  WebServerName=$(echo "$ZEILE" | awk -F : '{print $5}')
  SVWSPort=$(echo "$ZEILE" | awk -F : '{print $6}')
  MariaDB_ROOT_PASSWORD=$(echo "$ZEILE" | awk -F : '{print $7}')
  SVWSVersion=$(echo "$ZEILE" | awk -F : '{print $8}')
  SERVERNAME=$(echo "$ZEILE" | awk -F : '{print $9}')
  Pfad=$(echo "$ZEILE" | awk -F : '{print $10}')
  LPPort=$(echo "$ZEILE" | awk -F : '{print $11}')
################################################################
  # nur pc-ANFANG bis pc-ENDE bearbeiten
  [[ "$STACK" =~ ^pc-[0-9]{2}$ ]] || continue
  NR=$((10#${STACK#pc-}))
  (( NR >= ANFANG && NR <= ENDE )) || continue

  echo
  echo -e "${WEISS}### $STACK (Port $LPPort) ###${NC}"
  if [ -z "$LPPort" ]; then
    echo -e "${ROT}$STACK: Zeile in schulungen.txt ist unvollstaendig, uebersprungen${NC}"
    FEHLER=$((FEHLER + 1))
    continue
  fi

  mkdir -p "$STACK/$STACK"
  if ! cd "$STACK/$STACK"; then
    FEHLER=$((FEHLER + 1))
    continue
  fi

  if stack_bearbeiten; then
    ANZAHL=$((ANZAHL + 1))
  else
    FEHLER=$((FEHLER + 1))
  fi
################################################################
  cd "$WEB/docker" || exit 1
done 3< "$WEB/docker/schulungen.txt"
################################################################
echo
echo -e "${WEISS}Fertig: $ANZAHL STACK(s) bearbeitet, $FEHLER Fehler.${NC}"
if (( ANZAHL + FEHLER == 0 )); then
  echo -e "${ROT}Kein Rechner aus diesem Bereich steht in schulungen.txt.${NC}"
  exit 1
fi
(( FEHLER == 0 ))
