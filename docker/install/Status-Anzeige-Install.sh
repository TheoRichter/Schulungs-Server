#!/bin/bash
STACK=""
URL="$1"
################################################
while read ZEILE; do
  STACK=$(echo $ZEILE | awk -F : '{print $1}')
  cd /var/www/html/docker/$STACK
  wget -q --show-progress http://$URL/DockerWebseitenContainerStatus.zip
  unzip DockerWebseitenContainerStatus.zip
  chown -R www-data:www-data /var/www/html/
  rm DockerWebseitenContainerStatus.zip
sleep 1
#######################################################
### webserver_start_stop.php                        ###
sed -i 's/XX/'$STACK'/g' webserver_start_stop.php   ###
### webserver.html                                  ###
sed -i 's/XX/'$STACK'/g' webserver.html             ###
### mariadb.html                                    ###
sed -i 's/XX/'$STACK'/g' mariadb.html               ###
### mariadb_start_stop.php                          ###
sed -i 's/XX/'$STACK'/g' mariadb_start_stop.php     ###
### svws-server.html                                ###
sed -i 's/XX/'$STACK'/g' svws-server.html           ###
### svws-server_start_stop.php                      ###
sed -i 's/XX/'$STACK'/g' svws-server_start_stop.php ###
#######################################################
#
done < schulungen.txt
