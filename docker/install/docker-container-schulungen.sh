#!/bin/bash
#################################
### SQliteDatenbankSchematas  ###
### in Maridb Schreiben       ###  
### Erstellt von Theo Richter ###
### am 15.10.2024     (c)     ###
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
URL="$1"
#
echo
echo -e -n "${TUERKIS}Installation der Docker-STACKs ${NC}"
echo
###############################################################
### Die Steuerdatei: schulungen.txt ausfuellen ################
###############################################################
echo
read -p  "Die aktuelle SVWS-Version (z.B. 1.4.1) eingeben: " SVWSVERSION
echo
##################################################################
cd /var/www/html/inc/conf                                      ###
######## geaendert am 10-08-2026                               ###
sed -i 's/00004/'$SVWSVERSION'/g' config.inc.php               ###
##################################################################
cd /var/www/html/sh                                            ###
######## geaendert am 19-10-2026                               ###
sed -i 's/SVWSVERSION/'$SVWSVERSION'/g' SVWSVersion.sh         ###
##################################################################
cd /root
echo
read -p  "Die Docker-Servers IP (z.B. 10.1.0.3) eingeben: " SERVERNAME
echo
read -p  "Das MariaDB ROOT PASSWORD eingeben: " MariaDB_ROOT_PASSWORD
echo
echo -e -n "${HELLBLAU}Die Anzahl der PCs(STACKS).  ${NC}"
echo
read -p  "Nummer des ersten Rechners: " ANFANG
read -p  "Nummer des lezten Rechners: " ENDE
##############################################################################################################################################################################################
#### openssl Zertifikat fuer wenom                                                                                                                                                         ###
openssl req -x509 -nodes -days 3650 -newkey rsa:4096 -keyout /root/theos.key -out /root/theos.crt -subj "/C=DE/ST=NRW/L=BRA/O=NONE/CN=localhost" -addext "subjectAltName = IP:$SERVERNAME" ###
##############################################################################################################################################################################################
### SchILD3 PCs in SVWS-Arbeitsverzeichnisse                                                                                                                                               ###
for (( i=$ANFANG; i<= $ENDE; i++));
do
    # einstellige Zahlen sollen mit fuehrender 0 ausgegeben werden, z.B. 05
    if [ $i -lt 10 ];
    then NUMMER="0${i}"
    else
	NUMMER="${i}"
    fi
    # Hier wird die Ausgabe zusammengestrickt
    echo -n "PC-$NUMMER:$SERVERNAME:" >> schid3connection.txt
    echo "30$NUMMER:100$NUMMER" >> schid3connection.txt
done
############################################################################
while read ZEILE; do
  WINPC=$(echo $ZEILE | awk -F : '{print $1}')
  SERVERNAME=$(echo $ZEILE | awk -F : '{print $2}')
  MariaDBPort=$(echo $ZEILE | awk -F : '{print $3}')
  SVWSPort=$(echo $ZEILE | awk -F : '{print $4}')
#
cd /netzlaufwerk/SVWS-Arbeitsverzeichnisse
  mkdir $WINPC
  mkdir $WINPC/Connection-Files
  mkdir $WINPC/NM3
  mkdir $WINPC/Schild-Reports
  cp -a /netzlaufwerk/Schild-NRW-3-Reports/"Reports Allgemein"/ -d $WINPC/Schild-Reports/"Reports Allgemein"/
  cp -a /netzlaufwerk/Schild-NRW-3-Reports/"Reports Leistungsübersichten"/ -d $WINPC/Schild-Reports/"Reports Leistungsübersichten"/
  cp -a /netzlaufwerk/Schild-NRW-3-Reports/"Reports PS"/ -d $WINPC/Schild-Reports/"Reports PS"/
  cp -a /netzlaufwerk/Schild-NRW-3-Reports/"Reports SI"/ -d $WINPC/Schild-Reports/"Reports SI"/
  cp -a /netzlaufwerk/Schild-NRW-3-Reports/"Reports SII"/ -d $WINPC/Schild-Reports/"Reports SII"/
  cp -a /netzlaufwerk/Schild-NRW-Reports/Oberstufenpaket/ -d $WINPC/Schild-Reports/Oberstufenpaket
  cp -a /netzlaufwerk/Schild-NRW-Reports/Serienbriefe/ -d $WINPC/Schild-Reports/Serienbriefe
  cp -a /netzlaufwerk/Schild-NRW-3-Zeugnisse-BK/ -d $WINPC/Schild-Reports/"Zeugnisse - BK"/
  cp -a /netzlaufwerk/Schild-NRW-GS-Zeugnisse/ -d $WINPC/Schild-Reports/"Zeugnisse - GS"/
  cp -a /netzlaufwerk/Schild-NRW-Zeugnisse-Sek1/ -d $WINPC/Schild-Reports/"Zeugnisse - Sek1"/
  cp -a /netzlaufwerk/Schild-NRW-Zeugnisse-Sek2/ -d $WINPC/Schild-Reports/"Zeugnisse - Sek2"/
  cp -a /netzlaufwerk/Schild-NRW-WBK-Zeugnisse/ -d $WINPC/Schild-Reports/"Zeugnisse - WBK"/
  mkdir $WINPC/Sicherungen
  mkdir $WINPC/Statistik
  cd $WINPC/Connection-Files
  wget -q --show-progress http://$URL/Connection-Files.zip
  unzip Connection-Files.zip
  rm Connection-Files.zip
###################################################################################
### SERVERNAME                                                                  ###
sed -i 's/SERVERNAME/'$SERVERNAME'/g' Berufschule.con                           ###
### MariaDBPort                                                                 ###
sed -i 's/MariaDBPort/'$MariaDBPort'/g' Berufschule.con                         ###
### SVWSPort                                                                    ###
sed -i 's/SVWSPort/'$SVWSPort'/g' Berufschule.con                               ###
###################################################################################
### SERVERNAME                                                                  ###
sed -i 's/SERVERNAME/'$SERVERNAME'/g' Gesamtschule.con                          ###
### MariaDBPort                                                                 ###
sed -i 's/MariaDBPort/'$MariaDBPort'/g' Gesamtschule.con                        ###
### SVWSPort                                                                    ###
sed -i 's/SVWSPort/'$SVWSPort'/g' Gesamtschule.con                              ###
###################################################################################
### SERVERNAME                                                                  ###
sed -i 's/SERVERNAME/'$SERVERNAME'/g' Grundschule.con                           ###
### MariaDBPort                                                                 ###
sed -i 's/MariaDBPort/'$MariaDBPort'/g' Grundschule.con                         ###
### SVWSPort                                                                    ###
sed -i 's/SVWSPort/'$SVWSPort'/g' Grundschule.con                               ###
###################################################################################
### SERVERNAME                                                                  ###
sed -i 's/SERVERNAME/'$SERVERNAME'/g' Grundschule_1Hj.con                       ###
### MariaDBPort                                                                 ###
sed -i 's/MariaDBPort/'$MariaDBPort'/g' Grundschule_1Hj.con                     ###
### SVWSPort                                                                    ###
sed -i 's/SVWSPort/'$SVWSPort'/g' Grundschule_1Hj.con                           ###
###################################################################################
### SERVERNAME                                                                  ###
sed -i 's/SERVERNAME/'$SERVERNAME'/g' Grundschule_2Hj.con                       ###
### MariaDBPort                                                                 ###
sed -i 's/MariaDBPort/'$MariaDBPort'/g' Grundschule_2Hj.con                     ###
### SVWSPort                                                                    ###
sed -i 's/SVWSPort/'$SVWSPort'/g' Grundschule_2Hj.con                           ###
###################################################################################
### SERVERNAME                                                                  ###
sed -i 's/SERVERNAME/'$SERVERNAME'/g' Grundschule_1HjLeistungsdaten.con         ###
### MariaDBPort                                                                 ###
sed -i 's/MariaDBPort/'$MariaDBPort'/g' Grundschule_1HjLeistungsdaten.con       ###
### SVWSPort                                                                    ###
sed -i 's/SVWSPort/'$SVWSPort'/g' Grundschule_1HjLeistungsdaten.con             ###
###################################################################################
### SERVERNAME                                                                  ###
sed -i 's/SERVERNAME/'$SERVERNAME'/g' Grundschule_2HjLeistungsdaten.con         ###
### MariaDBPort                                                                 ###
sed -i 's/MariaDBPort/'$MariaDBPort'/g' Grundschule_2HjLeistungsdaten.con       ###
### SVWSPort                                                                    ###
sed -i 's/SVWSPort/'$SVWSPort'/g' Grundschule_2HjLeistungsdaten.con             ###
###################################################################################
### SERVERNAME                                                                  ###
sed -i 's/SERVERNAME/'$SERVERNAME'/g' GOSt_DB-1_VorbereitungEFPlanung.con       ###
### MariaDBPort                                                                 ###
sed -i 's/MariaDBPort/'$MariaDBPort'/g' GOSt_DB-1_VorbereitungEFPlanung.con     ###
### SVWSPort                                                                    ###
sed -i 's/SVWSPort/'$SVWSPort'/g' GOSt_DB-1_VorbereitungEFPlanung.con           ###
###################################################################################
### SERVERNAME                                                                  ###
sed -i 's/SERVERNAME/'$SERVERNAME'/g' GOSt_DB-2_Laufbahnen10EF-zumBlocken.con   ###
### MariaDBPort                                                                 ###
sed -i 's/MariaDBPort/'$MariaDBPort'/g' GOSt_DB-2_Laufbahnen10EF-zumBlocken.con ###
### SVWSPort                                                                    ###
sed -i 's/SVWSPort/'$SVWSPort'/g' GOSt_DB-2_Laufbahnen10EF-zumBlocken.con       ###
###################################################################################
### SERVERNAME                                                                  ###
sed -i 's/SERVERNAME/'$SERVERNAME'/g' GOSt_DB-3_Blockungen10EFmitFehlern.con    ###
### MariaDBPort                                                                 ###
sed -i 's/MariaDBPort/'$MariaDBPort'/g' GOSt_DB-3_Blockungen10EFmitFehlern.con  ###
### SVWSPort                                                                    ###
sed -i 's/SVWSPort/'$SVWSPort'/g' GOSt_DB-3_Blockungen10EFmitFehlern.con        ###
###################################################################################
### SERVERNAME                                                                  ###
sed -i 's/SERVERNAME/'$SERVERNAME'/g' GOSt_DB-4-KlausurplanungEF2.con           ###
### MariaDBPort                                                                 ###
sed -i 's/MariaDBPort/'$MariaDBPort'/g' GOSt_DB-4-KlausurplanungEF2.con         ###
### SVWSPort                                                                    ###
sed -i 's/SVWSPort/'$SVWSPort'/g' GOSt_DB-4-KlausurplanungEF2.con               ###
###################################################################################
### SERVERNAME                                                                  ###
sed -i 's/SERVERNAME/'$SERVERNAME'/g' ENM_SVWS.con                              ###
### MariaDBPort                                                                 ###
sed -i 's/MariaDBPort/'$MariaDBPort'/g' ENM_SVWS.con                            ###
### SVWSPort                                                                    ###
sed -i 's/SVWSPort/'$SVWSPort'/g' ENM_SVWS.con                                  ###
###################################################################################
### SERVERNAME                                                                  ###
sed -i 's/SERVERNAME/'$SERVERNAME'/g' S1Schulung.con                            ###
### MariaDBPort                                                                 ###
sed -i 's/MariaDBPort/'$MariaDBPort'/g' S1Schulung.con                          ###
### SVWSPort                                                                    ###
sed -i 's/SVWSPort/'$SVWSPort'/g' S1Schulung.con                                ###
###################################################################################
### SERVERNAME                                                                  ###
sed -i 's/SERVERNAME/'$SERVERNAME'/g' S2Schulung.con                            ###
### MariaDBPort                                                                 ###
sed -i 's/MariaDBPort/'$MariaDBPort'/g' S2Schulung.con                          ###
### SVWSPort                                                                    ###
sed -i 's/SVWSPort/'$SVWSPort'/g' S2Schulung.con                                ###
###################################################################################
#
chmod -R 777 /netzlaufwerk/SVWS-Arbeitsverzeichnisse/$WINPC
###chown -R nobody:nogroup /netzlaufwerk/SVWS-Arbeitsverzeichnisse/$WINPC
#
done < schid3connection.txt
################################################################################################################################################################################################
#
cd /netzlaufwerk/SchILD3
rm server.json
wget -q --show-progress http://$URL/server.json
##############################################################
sed -i 's/svwsversion/'$SVWSVERSION'/g' server.json        ###
##############################################################
cd /netzlaufwerk
mkdir OfficelleTestDBS
cd OfficelleTestDBS
##mkdir EigeneSchemata
wget -q --show-progress http://$URL/SchulungsSchemata.zip
unzip SchulungsSchemata.zip
rm SchulungsSchemata.zip
chmod -R 777 /netzlaufwerk/
chown -R www-data:www-data /netzlaufwerk/
#
Zahl="$ANFANG"
#######################################
if [[ "$ANFANG" == "$Zahl" ]]; then ###
#######################################
cd /var/www/html/inc/status-links                                                                                                                                                                               ###
anzahl="$ENDE"                                                                                                                                                                                                  ###
LOCALEIP="$SERVERNAME"                                                                                                                                                                                          ###
dateiname="pcs.inc.php"
inhalt=""

# Datei leeren oder neu anlegen
> "$dateiname"

# Schleife von 1 bis $anzahl
i=1
while [ "$i" -le "$anzahl" ]; do
  pcNummer=$(printf "%02d" "$i")

  cat <<EOF >> "$dateiname"
<!-- ANFANG pc-$pcNummer -->
<tr> 
  <td class="w3-border w3-center"><b>pc-$pcNummer</b></td>
  <td class="w3-border w3-center">
   <a href="https://$LOCALEIP:100$pcNummer/app/start" target="_blank" class="w3-button w3-black w3-hover-white">
     <img src="png/svws_anwendungen.png" alt="svws_anwendungen.png"></img>
   </a>
  </td>
  <td class="w3-border w3-right"><iframe src="docker/pc-$pcNummer/svws-server.html" width="45" height="40" frameborder="0"></iframe></td>
  <td class="w3-border"><iframe src="docker/pc-$pcNummer/svws-server_start_stop.php" width="126" height="40" frameborder="1"></iframe></td>
  <td class="w3-border w3-right"><iframe src="docker/pc-$pcNummer/mariadb.html" width="45" height="40" frameborder="0"></iframe></td>
  <td class="w3-border"><iframe src="docker/pc-$pcNummer/mariadb_start_stop.php" width="126" height="40" frameborder="1"></iframe></td>
  <td class="w3-border w3-right"><iframe src="docker/pc-$pcNummer/webserver.html" width="45" height="40" frameborder="0"></iframe></td>
  <td class="w3-border"><iframe src="docker/pc-$pcNummer/webserver_start_stop.php" width="126" height="40" frameborder="1"></iframe></td>
</tr>
<!-- ENDE pc-$pcNummer -->
EOF

  i=$((i + 1))
done
chown -R www-data:www-data /var/www/html/inc/status-links
echo
echo -e -n "${WEISS}Datei ${GELB}$dateiname${WEISS} mit $anzahl Einträgen wurde erfolgreich erstellt. ${NC}"
echo
sleep 3
##############################################################################################################################################
fi
#####################################################################################################################################################
cd /root
################################################################################################################################################################################################
for (( i=$ANFANG; i<= $ENDE; i++));
do
    # einstellige Zahlen sollen mit fuehrender 0 ausgegeben werden, z.B. 05
    if [ $i -lt 10 ];
    then NUMMER="0${i}"
    else
	NUMMER="${i}"
    fi
    # Hier wird die Ausgabe zusammengestrickt
    echo -n "pc-$NUMMER:30$NUMMER:80$NUMMER:81$NUMMER:" >> schulungen.txt
    echo -n "pc-$NUMMER-Webserver:" >> schulungen.txt
    echo -n "100$NUMMER:$MariaDB_ROOT_PASSWORD:" >> schulungen.txt
    echo "$SVWSVERSION:$SERVERNAME:netzlaufwerk" >> schulungen.txt
done
cp schulungen.txt /var/www/html
cp schulungen.txt /var/www/html/sh
cp schid3connection.txt /var/www/html/sh
cp schulungen.txt /var/www/html/docker
###############################################################
cd /var/www/html/docker
###############################################################
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
#sleep3
########################################################################################################################################################################################
  mkdir $STACK
  cd $STACK
  mkdir $STACK
  cd $STACK
  wget -q --show-progress http://$URL/docker-compose.zip
  unzip docker-compose.zip
  cp /root/theos.crt wenom/theos.crt 
  cp /root/theos.key wenom/theos.key 
  rm docker-compose.zip
sleep 2
########################################################################
### Wird benoetigt um die Ports im docker-compos.yml zu Aendern.     ###
########################################################################
### MariaDBPort ########################################################
sed -i 's/00001/'$MariaDBPort'/g' docker-compose.yml                 ###
sed -i 's/00001/'$MariaDBPort'/g' docker-compose-svws.yml            ###
### MariaDB root Passwort ##############################################
sed -i 's/leer/'$MariaDB_ROOT_PASSWORD'/g' .env                      ###
### MariaDB_DATA #######################################################
sed -i 's/00005/'$STACK'/g' docker-compose.yml                       ###
### WebServerName ######################################################
sed -i 's/WebServerName/'$WebServerName'/g' docker-compose.yml       ###
sed -i 's/WebServerName/'$WebServerName'/g' docker-compose-wenom.yml ###
### WebServerPortHTTP  #################################################
sed -i 's/00002/'$WebServerPortHTTP'/g' docker-compose.yml           ###
sed -i 's/00002/'$WebServerPortHTTP'/g' docker-compose-wenom.yml     ###
### WebServerPortHTTPS  ################################################
sed -i 's/00003/'$WebServerPortHTTPS'/g' docker-compose.yml          ###
sed -i 's/00003/'$WebServerPortHTTPS'/g' docker-compose-wenom.yml    ###
########################################################################
### SVWSVersion  #######################################################
sed -i 's/svwslatest/'$SVWSVersion'/g' docker-compose.yml            ###
########################################################################
### SVWSPort ###########################################################
sed -i 's/00004/'$SVWSPort'/g' docker-compose.yml                    ###
sed -i 's/00004/'$SVWSPort'/g' docker-compose-svws.yml               ###
########################################################################
### index.html  ################################################################
sed -i 's/SERVERNAME/'$SERVERNAME'/g' tools/start/index.html                 ###
sed -i 's/SVWSPort/'$SVWSPort'/g' tools/start/index.html                     ###
sed -i 's/WebServerPortHTTPS/'$WebServerPortHTTPS'/g' tools/start/index.html ###
################################################################################
docker compose up -d
#
docker exec $STACK-mariadb-1 sed -i 's/^[[:space:]]*#bind-address.*/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf
#
echo
echo -e -n "${WEISS}### Stoppen der docker-container ${GELB}$WebServerName${WEISS} und ${GELB}$STACK-svws-server-1${WEISS} und ${GELB}$STACK-mariadb-1 ${WEISS}### ${NC}" 
echo
docker stop $WebServerName 
docker stop $STACK-svws-server-1 
docker stop $STACK-mariadb-1
echo
echo -e -n "${HELLGRUEN} OK ${NC}" 
echo
sleep 2
###################################################################################################################################################################################################################
cd /root
done  < schulungen.txt
######################################################################################
echo                                                                               ### 
echo -e -n "${HELLGRAU}### Installation der Statusanzeige im WebProjekt ### ${NC}" ### 
echo                                                                               ###
bash Status-Anzeige-Install.sh $URL                                                ###
echo                                                                               ###  
echo -e -n "${HELLGRUEN} OK ${NC}"                                                 ###
echo                                                                               ###
######################################################################################
echo                                                                               ### 
echo -e -n "${HELLGRAU}## Installation des letzten STACKs im WebProjekt ### ${NC}" ### 
echo                                                                               ###
bash Erste-Letzte-Zeile.sh                                                         ###
echo                                                                               ###  
echo -e -n "${HELLGRUEN} OK ${NC}"                                                 ###
echo                                                                               ###
######################################################################################
echo                                                                               ### 
echo -e -n "${HELLGRAU}## Einpflegen der DatenbankSchemata in die STACKs ## ${NC}" ### 
echo                                                                               ###
######################################################################################
bash docker-schemata.sh
