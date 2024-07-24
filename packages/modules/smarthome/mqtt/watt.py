#!/usr/bin/python3
import sys
import os
import time
import json
import paho.mqtt.client as mqtt
import re
numberOfSupportedDevices = 9  # limit number of smarthome devices


def on_connect(client, userdata, flags, rc):
    global devicenumber
    global fx
    print ('%s devicenr %s rx %s ' % (time_string,devicenumber,str(rc)),file=fx)
    s="openWB/SmartHome/set/Devices/"+devicenumber + "/#"
    print ('%s subs %s ' % (time_string,s),file=fx)
    client.subscribe(s, 2)


def on_message(client, userdata, msg):
    global numberOfSupportedDevices
    global aktpower
    global powerc
    print ('%s RESC devicenr [%s] message [%s] payload [%s]' % (time_string,devicenumber,msg.topic,msg.payload),file=fx)
    if (("openWB/SmartHome/set/Device" in msg.topic) and ("Aktpower" in msg.topic)):
        devicenumb = re.sub(r'\D', '', msg.topic)
        if (1 <= int(devicenumb) <= numberOfSupportedDevices):
            aktpower = int(msg.payload)
            print ('RESC %s %d aktpower=[%6d] ' % (time_string, int(devicenumb),aktpower),file=fx)
    if (("openWB/SmartHome/set/Device" in msg.topic) and ("Powerc" in msg.topic)):
        devicenumb = re.sub(r'\D', '', msg.topic)
        if (1 <= int(devicenumb) <= numberOfSupportedDevices):
            powerc = int(msg.payload)
            print ('RESC %s %d PowerC= [%6d] ' % (time_string,int(devicenumb),powerc),file=fx)


aktpower = 0
powerc = 0
devicenumber = str(sys.argv[1])
ipadr = str(sys.argv[2])
uberschuss = int(sys.argv[3])
file_string = '/var/www/html/openWB/ramdisk/smarthome_device_' + str(devicenumber) + '_mqtt.log'
if os.path.isfile(file_string):
    fx = open(file_string, 'a')
else:
    fx = open(file_string, 'w')
named_tuple = time.localtime()  # getstruct_time
time_string = time.strftime("%m/%d/%Y, %H:%M:%S mqtt watt.py", named_tuple)
client = mqtt.Client("openWB-mqttsmarthomecust" + devicenumber)
client.on_connect = on_connect
client.on_message = on_message
startTime = time.time()
waitTime = 2
client.connect("localhost")
while True:
    client.loop()
    elapsedTime = time.time() - startTime
    if elapsedTime > waitTime:
        break
client.publish("openWB/SmartHome/set/Devices/"+str(devicenumber) +
               "/Ueberschuss", payload=str(uberschuss), qos=0, retain=True)
client.loop(timeout=2.0)
client.disconnect()
file_stringpv = '/var/www/html/openWB/ramdisk/smarthome_device_' + str(devicenumber) + '_pv'
# PV-Modus
pvmodus = 0
if os.path.isfile(file_stringpv):
    f = open(file_stringpv, 'r')
    pvmodus = int(f.read())
    f.close()
answer = '{"power":' + str(aktpower) + ',"powerc":' + str(powerc) + ',"on":' + str(pvmodus) + '} '
f1 = open('/var/www/html/openWB/ramdisk/smarthome_device_ret' + str(devicenumber), 'w')
json.dump(answer, f1)
print ('%s devicenr %s aktpower %6d ' % (time_string,devicenumber,aktpower),file=fx)
f1.close()
fx.close()