**Die Hintergrundprocesse der openWB**

Es gibt zwei arten von Dienste/Serivces die bei der 1.9'er openWB im Hintergrund laufen.
erstens die dringend nötigen und zweitens die nur auf Benutzerwunsche je nach Hardware verwemdet werdem.


| Service | Nötig | vom Benutzer<br>abschaltbar  | atreboot | cron5min | Bemerkung |
|:------------------ |:---------------:|:----------------:|-------------------:|-------------------:|-------------------:|
| mqttsub | JA | NEIN| restart | restart | Empfängt MQTT Nachrichten |
| legacy_run_server | Ja | NEIN | Start | restart | nicht bei openWB_Lite |
| modbusserver(2)| NEIN | JA| restart | restart | bei openwb_lite abschaltbar |
| isss| JA | NEIN| restart | restart | bei "nur Ladepunkt" (1) |
| buchse| JA | NEIN | restart | restart | bei "nur Ladepunkt" (1)  |
| smarthomehandler<br>alt | NEIN | JA | restart | restart | nur einer der beiden ist aktiv |
| smarthomemq<br>neu | NEIN | JA | restart | restart | nur einer der beiden ist aktiv |
| rse | NEIN| NEIN | restart | restart | Nur wenn RSE Kontakt genutzt wird |
| pushbutton| NEIN| JA | restart | restart | Nur wenn Ladetaster vorhanden |
| rfid| NEIN| JA| restart | restart | je nach RFID Mode|
| readrfid| NEIN| JA| restart | restart | je nach RFID Mode |
| tsp| NEIN |JA | restart | restart | Versendet Events  (3)|
| TWCManager| NEIN| JA| Start | restart | 
| Chrome | NEIN| JA| restart | restart | nur wenn Display vorhanden |
| X11 | NEIN| NEIN | -- | -- | nur wenn Display vorhanden |
|lightdm | NEIN | NEIN | Stop | | Stop wenn kein Display |


(1) Je nach Hardware gesteuert über Personalisierung der SD Karte.

(2) Nur bei der orginal openWB ab ca. 1.9.265.

(3) nur bei openWB_Lite