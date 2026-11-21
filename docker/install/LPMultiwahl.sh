#!/bin/bash
# Ergänzt in allen docker-compose-wenom.yml das SSL-Volume und den Port 82xx:7443

BASE="/var/www/html/docker"
COMPOSE="docker-compose-wenom.yml"
VOL="./apache/multiwahl-ssl.conf:/etc/apache2/sites-enabled/multiwahl-ssl.conf"

# Alle Ordner pc-xx einlesen
mapfile -t DIRS < <(find "$BASE" -maxdepth 1 -type d -name 'pc-*' | sort)
echo "Gefundene PCs: ${#DIRS[@]}"

for dir in "${DIRS[@]}"; do
    NAME="$(basename "$dir")"               # z.B. pc-01
    NUM="${NAME#pc-}"                       # z.B. 01
    FILE="$dir/$NAME/$COMPOSE"              # /var/www/html/docker/pc-01/pc-01/...
    PORT="82${NUM}:7443"

    if [ ! -f "$FILE" ]; then
        echo "$NAME: $FILE nicht gefunden, übersprungen"
        continue
    fi

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

    echo "$NAME: angepasst (Port $PORT)"
done