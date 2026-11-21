#!/bin/bash
# 1. LPMultiwahl.zip laden und entpacken
# 2. pro pc-xx: apache überschreiben, www ergänzen (inkl. chown)
# 3. docker-compose-wenom.yml um SSL-Volume und Port 82xx:7443 erweitern
# 4. in docker-compose.yml umbenennen und docker compose up -d starten

BASE="/var/www/html/docker"
COMPOSE="docker-compose-wenom.yml"
VOL="./apache/multiwahl-ssl.conf:/etc/apache2/sites-enabled/multiwahl-ssl.conf"
ZIP_URL="https://github.com/TheoRichter/Schulungs-Server/raw/main/docker/install/LPMultiwahl.zip"

# --- Download und Entpacken (einmalig, in temporärem Ordner) ---
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

echo "Lade LPMultiwahl.zip herunter ..."
if ! curl -fsSL -o "$TMP/LPMultiwahl.zip" "$ZIP_URL"; then
    echo "Fehler: Download fehlgeschlagen ($ZIP_URL)"
    exit 1
fi

mkdir -p "$TMP/unzip"
if ! unzip -q "$TMP/LPMultiwahl.zip" -d "$TMP/unzip"; then
    echo "Fehler: ZIP konnte nicht entpackt werden"
    exit 1
fi

# Falls die ZIP einen einzelnen Wrapper-Ordner enthält, eine Ebene tiefer gehen
SRC="$TMP/unzip"
if [ ! -d "$SRC/apache" ] && [ ! -d "$SRC/www" ]; then
    SUB="$(find "$SRC" -mindepth 1 -maxdepth 1 -type d | head -n1)"
    [ -n "$SUB" ] && SRC="$SUB"
fi
echo "Quelle: $SRC"

# --- Alle Ordner pc-xx einlesen ---
mapfile -t DIRS < <(find "$BASE" -maxdepth 1 -type d -name 'pc-*' | sort)
echo "Gefundene PCs: ${#DIRS[@]}"

for dir in "${DIRS[@]}"; do
    NAME="$(basename "$dir")"               # z.B. pc-01
    NUM="${NAME#pc-}"                       # z.B. 01
    TARGET="$dir/$NAME"                     # /var/www/html/docker/pc-01/pc-01
    FILE="$TARGET/$COMPOSE"
    NEWFILE="$TARGET/docker-compose.yml"
    PORT="82${NUM}:7443"

    if [ ! -d "$TARGET" ]; then
        echo "$NAME: $TARGET nicht gefunden, übersprungen"
        continue
    fi

    # apache: vorhandene Dateien werden überschrieben
    if [ -d "$SRC/apache" ]; then
        mkdir -p "$TARGET/apache"
        cp -rf "$SRC/apache/." "$TARGET/apache/"
    fi

    # www: nur ergänzen, vorhandene Dateien bleiben unverändert
    if [ -d "$SRC/www" ]; then
        mkdir -p "$TARGET/www"
        cp -rn "$SRC/www/." "$TARGET/www/" || true
        chown -R www-data:www-data "$TARGET/www"
    fi

    # docker-compose-wenom.yml anpassen und umbenennen
    if [ -f "$FILE" ]; then
        cp "$FILE" "$FILE.bak"

        awk -v vol="$VOL" -v port="$PORT" '
        { lines[NR] = $0 }
        END {
            all = ""
            for (j = 1; j <= NR; j++) all = all lines[j] "\n"
            vdone = (index(all, vol) > 0)
            pdone = (index(all, port) > 0)

            for (i = 1; i <= NR; i++) {
                print lines[i]
                # Erstes eingerücktes "volumes:" (Service-Ebene)
                if (!vdone && lines[i] ~ /^[ \t]+volumes:[ \t]*$/) {
                    match(lines[i+1], /^[ \t]*/)
                    ind = substr(lines[i+1], 1, RLENGTH)
                    if (ind == "") ind = "      "
                    print ind "- " vol
                    vdone = 1
                }
                # Erstes "ports:"
                if (!pdone && lines[i] ~ /^[ \t]+ports:[ \t]*$/) {
                    match(lines[i+1], /^[ \t]*/)
                    ind = substr(lines[i+1], 1, RLENGTH)
                    if (ind == "") ind = "      "
                    print ind "- \"" port "\""
                    pdone = 1
                }
            }
        }' "$FILE.bak" > "$FILE"

        # Eine bereits vorhandene docker-compose.yml vor dem Überschreiben sichern
        [ -f "$NEWFILE" ] && cp "$NEWFILE" "$NEWFILE.bak"
        mv -f "$FILE" "$NEWFILE"
        echo "$NAME: $COMPOSE angepasst (Port $PORT) und in docker-compose.yml umbenannt"
    elif [ -f "$NEWFILE" ]; then
        echo "$NAME: $COMPOSE nicht vorhanden, nutze bestehende docker-compose.yml"
    else
        echo "$NAME: weder $COMPOSE noch docker-compose.yml gefunden, übersprungen"
        continue
    fi

    # Container starten
    echo "$NAME: starte Container ..."
    (cd "$TARGET" && docker compose up -d)
done