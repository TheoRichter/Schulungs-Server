# Installation des Docker-Server

### Vorwort

![Proxmox](/graphics/proxmox.png)

Diese Installationsbeschreibung lehnt sich an einen installierten Proxmox auf einenm Hetzner Server mit 20 **Windows 11** PCs

![Spezifikationen](/graphics/specs_hetzner.png)

### Erstellen eines LXC-Containers: 

**15 CPUs, 50GB RAM, 5GB SWAP und 80GB Speicher**

![Spezifikationen](/graphics/specs.png)

Bei der Installation habe ich nur die **eth0**-Schnittstelle mit der **vmbr0**-Bridge  eingerichtet.

Nach der fertigen Installation habe ich noch die **eth1**-Schnittstelle mit der **vmbr2**-Bridge  hinzugefügt.

![Netzlaufwerke](/graphics/netzlaufwerke.png)

### Docker-Server

Nach dem erstellendes LXC-Container wechsel wir auf die Konsole oder Shell und melden uns als Benutzer **root** an.

Dort geben wir untenstehenden Text ein:

(Bei unserem Beispiel ist DieInstallationsquellen**IP**: 10.1.0.5)

```bash
ip a
wget DieInstallationsquellenIP/INSTALL.sh
bash INSTALL.sh DieInstallationsquellenIP
```

![Shell](/graphics/shell.png)

Nach dem Drücken von **Enter** beginnt der Installationsvorgang.

Nach einiger Zeit erscheint eine Text Eingabe zum Eintragen der IP des docker-servers:

![ShellIP](/graphics/shellIP.png)

Nach dem Drücken von **Enter** kommt die Eingabeaufforderung zum Festlegen der SchILD3-Version:

![ShellSchILD3](/graphics/shellSchILD3.png)

Danach erscheint mehre Eingabeaufforderungen: (bei dem Beispiel wähle ich 3 STACKs)

![ShellSTACKs](/graphics/shellSTACKs.png)

Nach der fertigen Installation muß der Arbeitsmodus des SVWS-Servers fest gelegt werden. Meine Auswahl ist der **dev** Modus.

![ShellDev](/graphics/shellDev.png)

Nach dem Drücken von **Enter** werden die DatenabnkSchemata Eingespielt.

![ShellSchemata](/graphics/shellSchemata.png)

Jetzt dauert das einige Zeit und am Ende erscheint dieser Bildschirm.

![ShellEnde](/graphics/shellEnde.png)

