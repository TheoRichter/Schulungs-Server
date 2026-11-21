#!/bin/bash
# Schreibt pro pc-xx die MariaDB-Compose-Datei, stoppt den alten Container,
# benennt die Datei um und startet MariaDB mit dem vorhandenen Volume <pc-xx>_mariadb_data

BASE="/var/www/html/docker"

anzahl=$(find "$BASE" -maxdepth 1 -type d -name "pc*" | wc -l)
echo "Gefundene pc-Ordner: $anzahl"

for dir in "$BASE"/pc*/; do
    name=$(basename "$dir")                  # z. B. pc-05
    nr=$(echo "$name" | grep -o '[0-9]*$')   # z. B. 05
    volume="${name}_mariadb_data"
    port="30${nr}"

    if [ -z "$nr" ]; then
        echo "WARNUNG: Keine Nummer in $name gefunden, übersprungen"
        continue
    fi

    # Nur fortfahren, wenn das vorhandene Volume wirklich existiert
    if ! docker volume inspect "$volume" > /dev/null 2>&1; then
        echo "WARNUNG: Volume $volume nicht gefunden, $name übersprungen"
        continue
    fi

    (
        cd "$BASE/$name/$name" || { echo "WARNUNG: $BASE/$name/$name nicht vorhanden, übersprungen"; exit 1; }

        # Alten Container stoppen: alle, die das Volume nutzen oder den Port belegen
        alte=$( { docker ps -aq --filter "volume=$volume"; docker ps -aq --filter "publish=$port"; } | sort -u )
        if [ -n "$alte" ]; then
            echo "Stoppe alte Container für $name:"
            docker ps -a --filter "id=$(echo $alte | tr ' ' '\n' | head -n1)" --format '  {{.Names}}' > /dev/null
            for id in $alte; do
                echo "  $(docker inspect --format '{{.Name}}' "$id")"
            done
            docker stop $alte
            docker rm $alte
        else
            echo "Kein alter Container für $name gefunden"
        fi

        cat > docker-compose-mariadb.yml << 'EOF'
services:
  mariadb:
    restart: always
    image: mariadb:12.3
    environment:
      MARIADB_ROOT_PASSWORD: "${MariaDB_ROOT_PASSWORD}"
      MARIADB_DATABASE: "${MariaDB_DATABASE}"
      MARIADB_USER: "${MariaDB_USER}"
      MARIADB_PASSWORD: "${MariaDB_PASSWORD}"
    ports:
      - "30__NR__:3306"
    env_file:
      - .env
    healthcheck:
      test: ["CMD", "healthcheck.sh", "--connect", "--innodb_initialized"]
      interval: 1s
      timeout: 5s
      retries: 10
    volumes:
      - mariadb_data:/var/lib/mysql
      - ./init-db.sql:/docker-entrypoint-initdb.d/init-db.sql:ro

volumes:
  mariadb_data:
    name: __NAME___mariadb_data
EOF

        sed -i "s/__NR__/${nr}/g; s/__NAME__/${name}/g" docker-compose-mariadb.yml

        if [ -f docker-compose.yml ]; then
            cp docker-compose.yml docker-compose.yml.bak
            echo "Backup erstellt: $(pwd)/docker-compose.yml.bak"
        fi

        mv -f docker-compose-mariadb.yml docker-compose.yml
        echo "Umbenannt: $(pwd)/docker-compose.yml (Port $port, Volume $volume)"

        docker compose pull
        docker compose up -d
    )
done

echo "Fertig."