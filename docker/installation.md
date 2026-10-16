# Installation des Docker-Server

### Vorwort

![Proxmox](./graphics/proxmox.png)

Diese Installationsbeschreibung leht sich an einen installierten Proxmox auf einenm Hetzner Server mit 20 Windows 11 PCs

![Spezifikationen](./graphics/specs_hetzner.png)


### Erstellen eines LXC-Containers: 

**15 CPUs, 50GB RAM, 5GB SWAP und 80GB Speicher**

![Spezifikationen](./graphics/specs.png)

![Netzlaufwerke](./graphics/netzlaufwerke.png)

### Docker-Server

```bash
ip a
wget InstallationsserverIP/INSTALL.sh
bash INSTALL.sh InstallationsserverIP
```

