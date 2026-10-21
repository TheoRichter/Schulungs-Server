#!/bin/bash
#################################
### SQliteDatenbankSchematas  ###
### in Maridb Schreiben       ###  
### Erstellt von Theo Richter ###
### am 07.10.2022     (c)     ###
#################################
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
echo
echo -e -n "${TUERKIS}Installation des DOCKER Portainer ${NC}"
echo
sleep 1
docker volume create portainer_data
docker pull portainer/portainer-ce:latest
docker run -d -p 8000:8000 -p 9443:9443 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data  portainer/portainer-ce:latest --no-setup-token
#
echo
echo -e -n " ${HELLGRUEN}OK ${NC}"
echo
