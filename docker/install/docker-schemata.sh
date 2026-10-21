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
MariaDBPort=""
WebserverPortHTTP=""
WebserverPortHTTPS=""
PHPmyAdminPort=""
SVWSPort=""
SVWSVersion=""
STACK=""
MariaDB_ROOT_PASSWORD=""
PHPmyAdminName=""
WebserverName=""
DB_NAME=""
DB_USER=""
DB_MYSQL_PW=""
SCHULFORM=""
ANZAHL="14"
################################################################################ 
echo
echo -e -n "${HELLBLAU}Den Status des SVWS-Version eintragen. ${NC}"
echo
read -p  "Hier stable oder alpha oder dev eintragen: " SVWSSTATUS
echo
########################################################################################################################################
while read ZEILE; do
  STACK=$(echo $ZEILE | awk -F : '{print $1}')
#
echo
echo -e -n "${WEISS}### Starten der Docker-Container ${GELB}$STACK-mariadb-1 ${WEISS}und ${GELB}$STACK-svws-server-1 ${WEISS}### ${NC}" 
echo
docker start $STACK-mariadb-1
docker start $STACK-svws-server-1
done < schulungen.txt
#
echo
echo -e -n "${HELLGRUEN} OK ${NC}" 
echo
sleep 3
################################################################################
while read ZEILE; do
  STACK=$(echo $ZEILE | awk -F : '{print $1}')
  MariaDBPort=$(echo $ZEILE | awk -F : '{print $2}')
  WebServerPortHTTP=$(echo $ZEILE | awk -F : '{print $3}')
  WebServerPortHTTPS=$(echo $ZEILE | awk -F : '{print $4}')
  WebServerName=$(echo $ZEILE | awk -F : '{print $5}')
  SVWSPort=$(echo $ZEILE | awk -F : '{print $6}')
  MariaDB_ROOT_PASSWORD=$(echo $ZEILE | awk -F : '{print $7}')
  SVWSVersion=$(echo $ZEILE | awk -F : '{print $8}')
  SERVERNAME=$(echo $ZEILE | awk -F : '{print $9}')
  Pfad=$(echo $ZEILE | awk -F : '{print $10}') 
########################################################################################################################################################################################
#echo
#echo -e -n "${HELLGRAU}STACK:${GELB}$STACK ${HELLGRAU}SERVERNAME:${GELB}$SERVERNAME ${HELLGRAU}Pfad:${GELB}$Pfad ${NC}"
#echo
#echo -e -n "${HELLGRAU}MariaDBPort:${GELB}$MariaDBPort ${HELLGRAU}MariaDB_ROOT_PASSWORD:${GELB}$MariaDB_ROOT_PASSWORD ${NC}"
#echo
#echo -e -n "${HELLGRAU}WebserverPortHTTP:${GELB}$WebserverPortHTTP ${HELLGRAU}WebserverPortHTTPS:${GELB}$WebserverPortHTTPS ${HELLGRAU}WebserverName:${GELB}$WebserverName ${NC}"
#echo
#echo -e -n "${HELLGRAU}PHPmyAdminPort:${GELB}$PHPmyAdminPort ${HELLGRAU}PHPmyAdminName:${GELB}$PHPmyAdminName ${NC}"
#echo
#echo -e -n "${HELLGRAU}SVWSPort:${GELB}$SVWSPort ${HELLGRAU}SVWSVersion:${GELB}$SVWSVersion ${NC}" 
#echo
###################################################################################################################################################################
### ANFANG der for schleife #######################################################################################################################################
###################################################################################################################################################################
  for (( i=1; i<=$ANZAHL; i++ ))
  do
 if [[ "$i" == "1" ]]; then
   ############################################################################
   ### Angelegt der SQLITE DatenbankSchemata fuer die Schulform: Gymnasium  ###
   ############################################################################
   SCHULFORM="Gymnasium"
   DB_NAME=GOSt_DB-1_VorbereitungEFPlanung
   DB_USER=$DB_NAME
   DB_MYSQL_PW=$DB_NAME
   # SQLITE DatenbankPfad
   DB_PATH=/$Pfad/OfficelleTestDBS/$SCHULFORM/$DB_NAME.sqlite
  fi
  if [[ "$i" == "2" ]]; then
   ############################################################################
   ### Angelegt der SQLITE DatenbankSchemata fuer die Schulform: Gymnasium  ###
   ############################################################################
   SCHULFORM="Gymnasium"
   DB_NAME=GOSt_DB-2_Laufbahnen10EF-zumBlocken
   DB_USER=$DB_NAME
   DB_MYSQL_PW=$DB_NAME
   # SQLITE DatenbankPfad
   DB_PATH=/$Pfad/OfficelleTestDBS/$SCHULFORM/$DB_NAME.sqlite
  fi
  if [[ "$i" == "3" ]]; then
   ############################################################################
   ### Angelegt der SQLITE DatenbankScehemata fuer die Schulform: Gymnasium ###
   ############################################################################
   SCHULFORM="Gymnasium"
   DB_NAME=GOSt_DB-3_Blockungen10EFmitFehlern
   DB_USER=$DB_NAME
   DB_MYSQL_PW=$DB_NAME
   # SQLITE DatenbankPfad
   DB_PATH=/$Pfad/OfficelleTestDBS/$SCHULFORM/$DB_NAME.sqlite
  fi
  if [[ "$i" == "4" ]]; then
   ############################################################################
   ### Angelegt der SQLITE Datenbankscehemata fuer die Schulform: Gymnasium ###
   ############################################################################
   SCHULFORM="Gymnasium"
   DB_NAME=GOSt_DB-4-KlausurplanungEF2
   DB_USER=$DB_NAME
   DB_MYSQL_PW=$DB_NAME
   # SQLITE DatenbankPfad
   DB_PATH=/$Pfad/OfficelleTestDBS/$SCHULFORM/$DB_NAME.sqlite
 fi
 if [[ "$i" == "5" ]]; then
   ###############################################################################
   ### Angelegt der SQLITE Datenbankscehemata fuer die Schulform: Gesamtschule ###
   ###############################################################################
   SCHULFORM="Gesamtschule"
   DB_NAME=$SCHULFORM
   DB_USER=$SCHULFORM
   DB_MYSQL_PW=$SCHULFORM
   # SQLITE DatenbankPfad
   DB_PATH=/$Pfad/OfficelleTestDBS/$SCHULFORM/$SCHULFORM.sqlite
  fi
  if [[ "$i" == "6" ]]; then
   ##############################################################################
   ### Angelegt der SQLITE Datenbankscehemata fuer die Schulform: Grundschule ###
   ##############################################################################
   SCHULFORM="Grundschule"
   DB_NAME=$SCHULFORM
   DB_USER=$SCHULFORM
   DB_MYSQL_PW=$SCHULFORM
   # SQLITE DatenbankPfad
   DB_PATH=/$Pfad/OfficelleTestDBS/$SCHULFORM/$SCHULFORM.sqlite
  fi
  if [[ "$i" == "7" ]]; then
   ##############################################################################
   ### Angelegt der SQLITE Datenbankscehemata fuer die Schulform: ENM01       ###
   ##############################################################################
   DB_NAME=ENM_SVWS
   DB_USER=$DB_NAME
   DB_MYSQL_PW=$DB_NAME
   # SQLITE DatenbankPfad
   DB_PATH=/$Pfad/OfficelleTestDBS/ENM-Json/ENM-Testdaten-01/$DB_NAME.sqlite
  fi
  if [[ "$i" == "8" ]]; then
   ###############################################################################
   ### Angelegt der SQLITE Datenbankscehemata fuer die Schulform: Berufschule  ###
   ###############################################################################
   SCHULFORM="Berufschule"
   DB_NAME=$SCHULFORM
   DB_USER=$SCHULFORM
   DB_MYSQL_PW=$SCHULFORM
   # SQLITE DatenbankPfad
   DB_PATH=/$Pfad/OfficelleTestDBS/$SCHULFORM/$SCHULFORM.sqlite
  fi
  if [[ "$i" == "9" ]]; then
   ###############################################################################
   ### Angelegt der SQLITE Datenbankscehemata fuer die Schulform: S1Schulung   ###
   ###############################################################################
   SCHULFORM="S1Schulung"
   DB_NAME=$SCHULFORM
   DB_USER=$SCHULFORM
   DB_MYSQL_PW=$SCHULFORM
   # SQLITE DatenbankPfad
   DB_PATH=/$Pfad/OfficelleTestDBS/$SCHULFORM/$SCHULFORM.sqlite
  fi
  if [[ "$i" == "10" ]]; then
   ###############################################################################
   ### Angelegt der SQLITE Datenbankscehemata fuer die Schulform: S2Schulung   ###
   ###############################################################################
   SCHULFORM="S2Schulung"
   DB_NAME=$SCHULFORM
   DB_USER=$SCHULFORM
   DB_MYSQL_PW=$SCHULFORM
   # SQLITE DatenbankPfad
   DB_PATH=/$Pfad/OfficelleTestDBS/$SCHULFORM/$SCHULFORM.sqlite
  fi
  if [[ "$i" == "11" ]]; then
   ##################################################################################
   ### Angelegt der SQLITE Datenbankscehemata fuer die Schulform: Grundschule_1Hj ###
   ##################################################################################
   SCHULFORM="Grundschule"
   DB_NAME=Grundschule_1Hj
   DB_USER=$DB_NAME
   DB_MYSQL_PW=$DB_NAME
   # SQLITE DatenbankPfad
   DB_PATH=/$Pfad/OfficelleTestDBS/$SCHULFORM/$DB_NAME.sqlite
  fi
  if [[ "$i" == "12" ]]; then
   ##################################################################################
   ### Angelegt der SQLITE Datenbankscehemata fuer die Schulform: Grundschule_2Hj ###
   ##################################################################################
   SCHULFORM="Grundschule"
   DB_NAME=Grundschule_2Hj
   DB_USER=$DB_NAME
   DB_MYSQL_PW=$DB_NAME
   # SQLITE DatenbankPfad
   DB_PATH=/$Pfad/OfficelleTestDBS/$SCHULFORM/$DB_NAME.sqlite
  fi
  if [[ "$i" == "13" ]]; then
   ################################################################################################
   ### Angelegt der SQLITE Datenbankscehemata fuer die Schulform: Grundschule_1HjLeistungsdaten ###
   ################################################################################################
   SCHULFORM="Grundschule"
   DB_NAME=Grundschule_1HjLeistungsdaten
   DB_USER=$DB_NAME
   DB_MYSQL_PW=$DB_NAME
   # SQLITE DatenbankPfad
   DB_PATH=/$Pfad/OfficelleTestDBS/$SCHULFORM/$DB_NAME.sqlite
  fi
  if [[ "$i" == "14" ]]; then
   ################################################################################################
   ### Angelegt der SQLITE Datenbankscehemata fuer die Schulform: Grundschule_2HjLeistungsdaten ###
   ################################################################################################
   SCHULFORM="Grundschule"
   DB_NAME=Grundschule_2HjLeistungsdaten
   DB_USER=$DB_NAME
   DB_MYSQL_PW=$DB_NAME
   # SQLITE DatenbankPfad
   DB_PATH=/$Pfad/OfficelleTestDBS/$SCHULFORM/$DB_NAME.sqlite
  fi
  echo
  echo -e -n "${HELLROT}###!?!?!ACHTUNG DAS DAUERT JETZT ETWAS!?!?!###${WEISS}###!?!?!ACHTUNG DAS DAUERT JETZT ETWAS!?!?!###${HELLROT}###!?!?!ACHTUNG DAS DAUERT JETZT ETWAS!?!?!### ${NC}"
  echo
  echo -e -n "${WEISS}### ${TUERKIS}Anlegen des DatenbankSchemata Nummer: ${GELB}$i ${TUERKIS}von ${GELB}$ANZAHL ${TUERKIS}mit dem Namen: ${GELB}${DB_NAME} ${TUERKIS}im Docker-Container: ${GELB}$STACK ${WEISS}### ${NC}"
  echo
  sleep 4
  echo
    curl --user "root:${MariaDB_ROOT_PASSWORD}" \
     -k --insecure \
     -X "POST" "https://${SERVERNAME}:${SVWSPort}/api/schema/root/import/sqlite/${DB_NAME}" \
     -H "accept: application/json" \
     -H "Content-Type: multipart/form-data" \
     -F "database=@${DB_PATH}" \
     -F "schemaUsername=${DB_USER}" \
     -F "schemaUserPassword=${DB_MYSQL_PW}" 
  clear
  done
###################################################################################################################################################################
### ENDE der for schleife #########################################################################################################################################
###################################################################################################################################################################
## svwsconfig.json von dem stable Modus in den alpha Modus setzen ###
if [[ "$SVWSSTATUS" == "alpha" ]]; then
  docker exec $STACK-svws-server-1 /bin/sh -c "sed 's/stable/alpha/g' /opt/app/svws/conf/svwsconfig.json > /opt/app/svws/conf/svwsconfig.json.new && \
  cat /opt/app/svws/conf/svwsconfig.json.new > /opt/app/svws/conf/svwsconfig.json && \
  rm /opt/app/svws/conf/svwsconfig.json.new"
fi
if [[ "$SVWSSTATUS" == "dev" ]]; then
  docker exec $STACK-svws-server-1 /bin/sh -c "sed 's/stable/dev/g' /opt/app/svws/conf/svwsconfig.json > /opt/app/svws/conf/svwsconfig.json.new && \
  cat /opt/app/svws/conf/svwsconfig.json.new > /opt/app/svws/conf/svwsconfig.json && \
  rm /opt/app/svws/conf/svwsconfig.json.new"
fi
##docker exec $STACK-mariadb-1 /bin/sh -c 'sed -i 's/#bind-address/bind-address/g' /etc/mysql/mariadb.conf.d/50-server.cnf'
##docker exec $STACK-mariadb-1 /bin/sh -c 'sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mysql/mariadb.conf.d/50-server.cnf'
###################################################################################################################################################################
echo
echo -e -n "${WEISS}### Stoppen der docker-container ${GELB}$STACK-mariadb-1 ${WEISS}und ${GELB}$STACK-svws-server-1 ${WEISS}### ${NC}" 
echo
    docker stop $STACK-mariadb-1
    docker stop $STACK-svws-server-1 
echo
echo -e -n " ${HELLGRUEN}OK ${NC}"
echo
#
done < schulungen.txt
#
##########################################################################################################################################
echo
echo -e -n "${WEISS}### ${GELB}Alle DatenbankSchemata eingeplegt. ${HELLROT}Bitte die Container Starten!!  ${WEISS}### ${NC}" 
echo
echo -e -n "${WEISS}### Unter ${GELB}https://$SERVERNAME ${WEISS}ist die Locale docker Webseite zu erreichen. ### ${NC}" 
echo
sleep 5
reboot
#