# Installation Installationsserver und Schulungsserver

## Installationserver

### Erstellen eines LXC-Containers: 

**1 CPU, 512MB RAM, 512 MB SWAP und 1GB Speicher**

![Spezifikationen](./graphics/specs.png)

### System Updaten und den Apache2 Webserver installieren:

```bash
apt update && apt upgrade -y && apt install –y apache2 mc ssh zip
```

Optional: Einstellen des deutschen Tastatur Layouts und der Zeitzone Europa/Berlin

```bash
dpkg-reconfigure locales && dpkg-reconfigure tzdata
```

### Installationsdaten holen, entzippen und löschen der ZIP-Datei:

```bash
cd /var/www/html
wget https://github.com/TheoRichter/Schulungs-Server/raw/refs/heads/main/downloads/SCHULUNGS-SERVER.zip
unzip SCHULUNGS-SERVER.zip
rm SCHULUNGS-SERVER.zip
ip a
```
Bitte merken Sie sich die IP des Installationsservers.


### Neuer Schulungsserver

Erstellen eines LXC-Containers, um den neuen Schulungsserver zubauen:

```bash
ip a
wget InstallationsserverIP/INSTALL.sh
bash INSTALL.sh InstallationsserverIP
```

