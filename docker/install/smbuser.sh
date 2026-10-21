#!/bin/bash
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
echo
echo -e -n "${TUERKIS} Zur Netzfreigabe unter Windows den Samba-User Anlegen. ${NC}"
echo
#
# Benutzername und Passwort
USER="smbuser"
PASS="smbuser"
#
# 1. Systembenutzer anlegen (ohne Home-Verzeichnis, falls nur für Samba)
if ! id "$USER" &>/dev/null; then
    useradd -M -s /sbin/nologin "$USER"
    echo
    echo -e -n "${TUERKIS}Systembenutzer $USER angelegt. ${NC}" 
    echo
else
    echo
    echo -e -n "${TUERKIS}Systembenutzer $USER existiert bereits. ${NC}"
    echo
fi
#
# 2. Samba-Benutzer anlegen (Passwort automatisch setzen)
echo -e  "$PASS\n$PASS" | smbpasswd -s -a "$USER"
#
# 3. Benutzer aktivieren
smbpasswd -e "$USER"
#
echo
echo -e -n "${TUERKIS} Samba-Benutzer $USER erstellt und aktiviert. ${NC}"
echo