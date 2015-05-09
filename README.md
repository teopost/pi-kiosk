# Pi-Kiosk
Pi-Kiosk è una soluzione basata su raspberry pi, che consente di eseguire lo slideshow di una cartella di immagini su un televisore.

Pi-Kiosk prevede l'utilizzo di btsync per l'aggiornamento delle immagini. Grazie a btsync è possibile utilizzare un computer desktop o uno smartphone per tenere aggiornata la presentazione.

Pi-Kiosk spegne il televisore la sera e lo riaccende la mattina utilizzando lo standard cec dell'HDMI presente ormai in quasi tutti i televisori di ultima generazione.

1. Materiale occorrente
---
* n.1 [Raspberry Pi](http://goo.gl/MybLy9)
* n.1 [Case](http://goo.gl/Znz5zb)
* n.1 [Scheda di memoria](http://goo.gl/3OPHrh)
* n.1 [Adattatore USB WiFi nano](http://goo.gl/O1TmFa)
* n.1 [Alimentatore 2A per Raspberry](http://goo.gl/jWQpXN)
* n.1 Cavo HDMI
* n.1 Televisore con HDMI cec

2. Preparare la Raspberry
---
Installate l'ultima versione del sistema operativo raspbian. Ci sono centinaia di guide su internet su come farlo. Se hai linux, ecco la centunesima:

* Aprire una finestra terminal e da root inserire l'SD nel card reader del computer. Eseguire questo comando:
```bash
# df -h
```
*  Eseguire l'umount della scheda: (sdb1 è solo un esempio, il nome potrebbe essere diverso)
```bash
# umount /dev/sdb1
```
* Scrivere l'immagine nella SD
```bash
# dd if=./immagine.img of=/dev/sdX bs=4k
```
* Eseguire questo comando per essere sicuri che tutta la cache sia scritta nell'SD
```bash
# sync
```

3. Installare pi-kiosk
---
* Installare il programma di visualizzazione immagini
```bash
$ sudo apt-get install feh
```
* Collegarsi in ssh sulla rasp e posizionarsi su /mnt
```bash
$ cd /mnt
```
* Scaricare il software
```bash
$ git clone https://github.com/teopost/pi-kiosk
```

4. Configurare il software
---
Per disabilitare lo screensaver editare il file autostart situato sotto /etc/xdg/lxsession/LXDE-pi.
```bash
@lxpanel --profile LXDE-pi
@pcmanfm --desktop --profile LXDE-pi
# @xscreensaver -no-splash           # <-- COMMENTARE
@xset s off
@xset -dpms
@xset s noblank
@/mnt/pi-kiosk/bin/slideshow.sh      # <-- AGGIUNGERE
```
Nel file, commentare la riga che contiene xscreensaver e aggiungere la riga in fondo per l'esecuzione automatica di pi-kiosk.

5. Installazione di btsync
---
Per sincronizzare le immagini installare [btsync](http://getsync.com). Ovviamente la versione per ARM.

6. Spegnimento automatico
---
Per spegnere e riaccendere automaticamente il televisore occorre installare la libreria cec per raspberry. Operazione da fare come root
```bash
# apt-get instal cec-client
# apt-get -y install udev libudev-dev autoconf automake libtool gcc liblockdev1
# git clone https://github.com/Pulse-Eight/libcec
# cd libcec/
# ./bootstrap
# ./configure --with-rpi-include-path=/opt/vc/include --with-rpi-lib-path=/opt/vc/lib --enable-rpi
# cec-client
# make
# make install
# ldconfig
```
7. Pianificare lo spegnimento
--
Nel crontab dell'utente pi, incollare le seguenti righe:
```bash
# .---------------- [m]inute: minuto (0 - 59)
# |  .------------- [h]our: ora (0 - 23)
# |  |  .---------- [d]ay [o]f [m]onth: giorno del mese (1 - 31)
# |  |  |  .------- [mon]th: mese (1 - 12) OPPURE jan,feb,mar,apr...
# |  |  |  |  .---- [d]ay [o]f [w]eek: giorno della settimana (0 - 6) (domenica=0 o 7)  OPPURE sun,mon,tue,wed,thu,fri,sat
# |  |  |  |  |

54 23 * * * /mnt/pi-kiosk/bin/turntv.sh off
30  7 * * * /mnt/pi-kiosk/bin/turntv.sh on && sleep 3 && /mnt/pi-kiosk/bin/turntv.sh input
```

Riferimenti
---
* http://raspberry-at-home.com/control-rpi-with-tv-remote/
* http://raspberrypi.stackexchange.com/questions/8698/how-can-my-raspberry-pi-turn-on-off-my-samsung-tv

```bash
# lista comandi
echo h | cec-client -s -d 1

# Attiva la porta cec come attiva
echo "as" | cec-client -s

```

* http://www.whizzy.org/wp-content/uploads/2012/11/cecsimple.sh_.txt
