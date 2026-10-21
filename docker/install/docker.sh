#/!/bin/bash
##################################
# Installation mit Apache2 php   #
# Shellinabox und Samba          #
# und Samba mit Schematas        #
# Erstellt am 10.10.2026 von TR  #
##################################
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
# Variabelen Festlegen
Pfad="root"
WEB="$1"
VERZEICHNISS="$2"
# Pruefen on der Benutzer root oder sudo ist
if ! [ $( id -u ) = 0 ]; then
    echo -e -n "${HELLROT}Bitte fuehren Sie dieses Script als root im root-Verzeichniss aus! ${NC}" 1>&2
    echo
    exit 1
fi
if [ -z "$VERZEICHNISS" ]; then
    URL="$WEB"
else
    URL="$WEB/$VERZEICHNISS"
fi
wget -q --show-progress http://$URL/.bashrc
cp .bashrc.1 .bashrc
#
echo
echo -e -n "${TUERKIS}Update und Upgrade des Debian ${NC}"
echo
sleep 1
apt-get update && apt upgrade -y && apt install net-tools ssh gnupg2 ca-certificates curl git unzip mc zip samba apache2 php sudo htop libsqlite3-dev sqlite3 php-sqlite3 -y
a2ensite default-ssl.conf
a2enmod ssl
systemctl restart apache2
systemctl status apache2 --no-pager
echo
echo -e -n "${TUERKIS}Autoremove der nicht mehr genutzten Dateien ${NC}"
echo
sleep 1
apt-get autoremove -y
echo
echo -e -n "${TUERKIS}Einstellen der Zeitzone Europa/Berlin und des Deutschen TastaturLayout. ${NC}"
echo
sleep 1
##dpkg-reconfigure tzdata
## timezone auf Europa/Berlin stellen
timedatectl set-timezone Europe/Berlin
##dpkg-reconfigure locales
## locales auf de_DE setzen
apt update
apt install -y locales
sed -i '/^# de_DE.UTF-8 UTF-8/s/^# //' /etc/locale.gen
locale-gen
update-locale LANG=de_DE.UTF-8
export LANG=de_DE.UTF-8
export LC_ALL=de_DE.UTF-8
#
echo
echo -e -n "${HELLGRUEN}OK. ${NC}"
echo
sleep 1
#
wget -q --show-progress http://$URL/ssh.zip
unzip ssh.zip
mv sshd_config /etc/ssh
systemctl restart ssh
systemctl status ssh --no-pager
## php.ini POST download limit auf 3800MB erhöht
wget -q --show-progress http://$URL/php.zip
unzip php.zip
mv php.ini /etc/php/8.4/apache2
systemctl restart apache2
systemctl status apache2 --no-pager
#
#Automatisches Update
wget -q --show-progress http://$URL/update.sh
wget -q --show-progress http://$URL/crontab
wget -q --show-progress http://$URL/jahrgangswechsel_datenbank.sh
mkdir -p /var/log/cron
mv update.sh /usr/local/sbin/update.sh
chmod -R 744 /usr/local/sbin/update.sh
mv jahrgangswechsel_datenbank.sh /usr/local/sbin/jahrgangswechsel_datenbank.sh
chmod -R 744 /usr/local/sbin/jahrgangswechsel_datenbank.sh
mv crontab /etc/crontab
clear
#
# DockerWebseiten
mkdir /var/www/.docker
chmod -R 777 /var/www/.docker
chown -R www-data:www-data /var/www/.docker
cd /var/www/html
#########################################################################################################################
wget -q --show-progress http://$URL/DockerWebseiten.zip      ##
#########################################################################################################################
rm index.html
unzip DockerWebseiten.zip
rm DockerWebseiten.zip
#########################################################################################################################
##chmod -R 744 /var/www/html/
chown -R www-data:www-data /var/www/html/
#################################
### Die IP des LXCs eingeben  ###
#################################
echo
read -p  "Hier die IP-Addresse des LXCs z.B. 10.1.0.3 eintragen: " IPADDRESSE
echo
##########################################################################
######## geaendert am 05-08-2025                                       ###
sed -i 's/00001/'$IPADDRESSE'/g' inc/conf/config.inc.php               ###
##########################################################################
# Samba einrichten
echo
echo -e -n "${TUERKIS}Installation des SAMBA-SERVERS erstellen ${NC}"
echo
echo
read -p  "Hier die SCHILD_VERSIONSNR z.B. 3.5.0 eintragen: " SCHILD_VERSIONSNR
echo
##########################################################################
######## geaendert am 10-08-2026                                       ###
sed -i 's/00003/'$SCHILD_VERSIONSNR'/g' inc/conf/config.inc.php        ###
##########################################################################
sleep 2
mkdir /netzlaufwerk/
ln -s /netzlaufwerk /var/www/html/netzlaufwerk
mkdir /netzlaufwerk/SchILD3
mkdir /netzlaufwerk/fonts
mkdir /netzlaufwerk/SVWS-Arbeitsverzeichnisse
mkdir /netzlaufwerk/installationfiles
######################################################################
## BasisReports aus git-Quelle in /netzlaufwerk Laden               ##
cd /netzlaufwerk                                                    ##
git clone https://github.com/SVWS-NRW/SVWS-Dokumentation.git        ##
git clone https://github.com/SVWS-NRW/Schild-NRW-Zeugnisse-Sek1.git ##
git clone https://github.com/SVWS-NRW/Schild-NRW-Zeugnisse-Sek2.git ##
git clone https://github.com/SVWS-NRW/Schild-NRW-3-Zeugnisse-BK.git ##
git clone https://github.com/SVWS-NRW/Schild-NRW-GS-Zeugnisse.git   ##
git clone https://github.com/SVWS-NRW/Schild-NRW-WBK-Zeugnisse.git  ##
git clone https://github.com/SVWS-NRW/Schild-NRW-Reports.git        ##
git clone https://github.com/SVWS-NRW/Schild-NRW-3-Reports.git      ##
######################################################################
#
cd /netzlaufwerk/SchILD3
wget -q --show-progress http://$URL/Admin.ini
#
cd /$Pfad
wget -q --show-progress https://github.com/SVWS-NRW/Schild3-BetaTest/releases/download/v$SCHILD_VERSIONSNR/Setup_SchILD3_v$SCHILD_VERSIONSNR.zip
mv /root/Setup_SchILD3_v$SCHILD_VERSIONSNR.zip /netzlaufwerk/installationfiles/
unzip /netzlaufwerk/installationfiles/Setup_SchILD3_v$SCHILD_VERSIONSNR.zip -d /netzlaufwerk/SchILD3/
#
wget -q --show-progress http://$URL/WINGDNG.zip
unzip WINGDNG.zip -d /netzlaufwerk/fonts
#
tee -a /etc/samba/smb.conf <<EOF

[netzlaufwerk]
path = /netzlaufwerk
public = yes
writable = yes
comment = SVWS Freigabe
printable = no
guest ok = yes
EOF
#
systemctl restart smbd.service
echo
echo -e -n "${TUERKIS} Ausgabe des Samba-Server Status  ${NC}"
echo
systemctl status smbd.service --no-pager
#
# Samba-User für Windows Freigabe anlegen
wget -q --show-progress http://$URL/smbuser.sh
bash smbuser.sh
echo
chmod -R 777 /netzlaufwerk/
chown -R www-data:www-data /netzlaufwerk/
wget -q --show-progress http://$URL/docker-container-schulungen.sh
wget -q --show-progress http://$URL/docker-schemata.sh
wget -q --show-progress http://$URL/Status-Anzeige-Install.sh
wget -q --show-progress http://$URL/Erste-Letzte-Zeile.sh
wget -q --show-progress http://$URL/vitepress.sh
echo
echo -e -n "${TUERKIS}Installation des DOCKERS ${NC}"
echo
sleep 3
# Add Docker's official GPG key:
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc
#
# Add the repository to Apt sources:
tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/debian
Suites: $(. /etc/os-release && echo "$VERSION_CODENAME")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF
#
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
wget -q --show-progress http://$URL/daemon.zip
unzip daemon.zip
mv daemon.json /etc/docker 
systemctl restart docker.service
systemctl status docker.service --no-pager
usermod -aG sudo www-data
usermod -aG docker www-data
sleep 2
#
bash docker-container-schulungen.sh $URL

