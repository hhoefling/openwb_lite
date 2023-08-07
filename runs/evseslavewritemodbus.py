#!/usr/bin/python3
# set_current for slaveeth
import sys
from pymodbus.client.sync import ModbusTcpClient

lla = int(sys.argv[1])

client = ModbusTcpClient('192.168.192.16', port=8899)
rq = client.write_registers(1000, lla, unit=1)
