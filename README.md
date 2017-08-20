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
Installate l'ultima versione del sistema operativo raspbian (quella con meno fronzoli ovvero senza l'inerfaccia grafica). Ci sono centinaia di guide su internet su come farlo. Se hai linux, ecco la centunesima:

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
$ sudo apt-get install -y feh unclutter git
```
* Collegarsi in ssh sulla rasp e posizionarsi nell home
```bash
$ cd
```
* Scaricare il software
```bash
$ git clone https://github.com/teopost/pi-kiosk
$ chmod 777 ./pi-kiosk/bin/*.sh
```
3.5 Aggiornare il software

```bash
$ sudo apt-get update
$ sudo apt-get upgrade
$ sudo rpi-update
$ sudo apt-get install lxde-core xserver-xorg xinit
$ reboot
```

4. Configurare il software
---

Per disabilitare lo screensaver editare il file autostart situato sotto /etc/xdg/lxsession/LXDE-pi. Quindi:

```bash
sudo vi /etc/xdg/lxsession/LXDE/autostart
```

```bash
@lxpanel --profile LXDE
@pcmanfm --desktop --profile LXDE
# @xscreensaver -no-splash           # <-- COMMENTARE
@/home/pi/pi-kiosk/bin/slideshow.sh      # <-- AGGIUNGERE
```
Aggiungere in /etc/rc.local

```
# Disable console blanking
setterm -blank 0 -powerdown 0 -powersave off
```

Nel file, commentare la riga che contiene xscreensaver e aggiungere la riga in fondo per l'esecuzione automatica di pi-kiosk.

Entrare nel tool raspi-config e impostare l'avvio in modalita' grafica con autologin

5. Installazione di btsync (OBSOLETO)
---
Per sincronizzare le immagini installare [btsync](http://getsync.com). Ovviamente la versione per ARM.

6. Spegnimento automatico
---
Per spegnere e riaccendere automaticamente il televisore occorre installare la libreria cec per raspberry. Operazione da fare come root.


```bash
# sudo apt-get install -y cec-utils

# sudo apt-get -y install udev libudev-dev autoconf automake libtool gcc liblockdep-dev		
# Invece del git clone prendere questa versione : https://github.com/Pulse-Eight/libcec/tree/2a80b46be78e9d849de223ab73b6f3e7b4d9fc46	
# cd libcec/		
# ./bootstrap		
# ./configure --with-rpi-include-path=/opt/vc/include --with-rpi-lib-path=/opt/vc/lib --enable-rpi				
# make		
# make install		
# ldconfig

```
7. Pianificare lo spegnimento e la riaccensione del TV
--
Nel crontab dell'utente pi, incollare le seguenti righe:
```bash
# .---------------- [m]inute: minuto (0 - 59)
# |  .------------- [h]our: ora (0 - 23)
# |  |  .---------- [d]ay [o]f [m]onth: giorno del mese (1 - 31)
# |  |  |  .------- [mon]th: mese (1 - 12) OPPURE jan,feb,mar,apr...
# |  |  |  |  .---- [d]ay [o]f [w]eek: giorno della settimana (0 - 6) (domenica=0 o 7)  OPPURE sun,mon,tue,wed,thu,fri,sat
# |  |  |  |  |

54 23 * * * /home/pi//pi-kiosk/bin/turntv.sh off
30  7 * * * /mnt/pi-kiosk/bin/turntv.sh on && sleep 3 && /mnt/pi-kiosk/bin/turntv.sh input
```

In alternativa a cec-client si puo' usare tvservice (gia' installato nella rasp)

```
54 23 * * * /usr/bin/tvservice -o
30  7 * * * /usr/bin/tvservice -p && sleep 3 && /usr/bin/xset dpms force on -display :0
```

e anche: 

```
54 23 * * * vcgencmd display_power 0
30  7 * * * vcgencmd display_power 1
```

Riferimenti
---
* http://raspberry-at-home.com/control-rpi-with-tv-remote/
* http://raspberrypi.stackexchange.com/questions/8698/how-can-my-raspberry-pi-turn-on-off-my-samsung-tv
* https://clevertap.com/blog/using-raspberry-pi-to-build-a-commercial-grade-wall-information-dashboard/


```bash
# lista comandi
echo h | cec-client -s -d 1

# Attiva la porta cec come attiva
echo "as" | cec-client -s

```

* http://www.whizzy.org/wp-content/uploads/2012/11/cecsimple.sh_.txt

Alternative
---
Lista di alcune interessanti alternative (anche se nessuna fa al caso mio)

* https://github.com/danthedeckie/streetsign
* https://pisignage.com
* https://www.screenly.io/ose/

