#!/bin/bash
############################################################################
# Quelldatei und Zieldatei
QUELLE="schulungen.txt"
ZIEL="letzteZeile.txt"
#############################################################################
# Prüfen, ob Quelldatei existiert
if [ ! -f "$QUELLE" ]; then
  echo "Datei '$QUELLE' nicht gefunden."
  exit 1
fi
#############################################################################
# Letzte Zeile auslesen und in Zieldatei schreiben
tail -n 1 "$QUELLE" > "$ZIEL"
cp $ZIEL /var/www/html/sh
chmod -R 777 /var/www/html/sh/$ZIEL
chown -R www-data:www-data /var/www/html/sh/$ZIEL
##############################################################################
while read ZEILE; do
  STACK=$(echo $ZEILE | awk -F : '{print $1}')
##############################################################################
######## geaendert am 05-08-2025                                           ###
sed -i 's/00002/'$STACK'/g' /var/www/html/inc/conf/config.inc.php          ###
##############################################################################
done  < letzteZeile.txt
