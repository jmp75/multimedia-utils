
How can I use multiple soundcards with JACK?
http://jackaudio.org/faq/multiple_devices.html

http://www.penguinproducer.com/Blog/2011/11/using-multiple-devices-with-jack/

```
aplay -l 

card 1: PCH [HDA Intel PCH], device 0: ALC3226 Analog [ALC3226 Analog]
  Subdevices: 1/1
  Subdevice #0: subdevice #0

aplay -L

dmix:CARD=PCH,DEV=0
    HDA Intel PCH, ALC3226 Analog
    Direct sample mixing device
dsnoop:CARD=PCH,DEV=0
    HDA Intel PCH, ALC3226 Analog
    Direct sample snooping device
hw:CARD=PCH,DEV=0
    HDA Intel PCH, ALC3226 Analog
    Direct hardware device without any conversions
plughw:CARD=PCH,DEV=0
    HDA Intel PCH, ALC3226 Analog
    Hardware device with all software conversions
```

```
/usr/bin/alsa_out -j "Laptop audio" -d dmix:PCH -q 1 -c 2 2>&1 1> /dev/null

/usr/bin/alsa_out -j "System Speakers" -d dmix:CMI8738 -q 1 2>&1 1> /dev/null &
```