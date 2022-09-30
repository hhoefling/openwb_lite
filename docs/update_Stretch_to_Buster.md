
Ich verwende pri-clone um eine Kopie der laufenden Stretch Version zu erzeugen

 *rpi-clone -v -p 256M sdb*
 ( https://github.com/billw2/rpi-clone )
 
Hierbei ist /dev/sda die im Kartenleser liegende Quell-SD Karte (32GB)
und /dev/sdb eine leere 16GB Karte. Diese wird dann auf Buster "upgedated"
Der Pi3B+ bootet nur dann von externen USB Ports wenn der intern KEINE oder eine leere SD Karte enthält.
Um also meine neue Karte alternativ booten zu können ohne immer mühselig die SD Karte aus dem internen Leser zu fummeln
habe ich die Quelle ebenfalls in einem Kartenleser extern via USB angeschlossen.
Daher ist die Quelle /dev/sda. 	Der PI3B+ bootet davon ohne Probleme. Lediglich die Bootzeit verlängert sich.
		

Hier nun die Mitschrift von rpi-clone

```
Booted disk: sda 31.9GB                    Destination disk: sdb 16.0GB
---------------------------------------------------------------------------
Part      Size    FS     Label           Part   Size  FS  Label
1 /boot    43.5M  fat32  --
2 root     29.7G  ext4   --
---------------------------------------------------------------------------
== Initialize: IMAGE partition table - partition number mismatch: 2 -> 0 ==
1 /boot               (29.0M used)   : RESIZE  MKFS  SYNC to sdb1
2 root                (4.1G used)    : RESIZE  MKFS  SYNC to sdb2
---------------------------------------------------------------------------
-p 256M                : resize /boot to 524288 blocks of 512 Bytes.
Run setup script       : no.
Verbose mode           : yes.
-----------------------:
## WARNING ##          : All destination disk sdb data will be overwritten!
-----------------------:

Initialize and clone to the destination disk sdb?  (yes/no): yes
```

 