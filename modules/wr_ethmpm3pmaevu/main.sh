#!/bin/bash
OPENWBBASEDIR=$(cd `dirname $0`/../../ && pwd)
RAMDISKDIR="${OPENWBBASEDIR}/ramdisk"
MODULEDIR=$(cd `dirname $0` && pwd)
DMOD="PV"
#DMOD="MAIN"
Debug=$debug

#For development only
#Debug=1

if [ ${DMOD} == "MAIN" ]; then
	MYLOGFILE="${RAMDISKDIR}/openWB.log"
else
	MYLOGFILE="${RAMDISKDIR}/nurpv.log"
fi

if (( pvkitversion == 1 )); then
	python3 ${OPENWBBASEDIR}/modules/wr_pvkit/readlovato.py "1" "192.168.192.15" "8899" "8" >>${MYLOGFILE} 2>&1
elif (( pvkitversion == 2 )); then
	python3 ${OPENWBBASEDIR}/modules/wr_pvkit/readsdm.py "1" "192.168.192.15" "8899" "116" >>${MYLOGFILE} 2>&1
else
	python3 ${OPENWBBASEDIR}/modules/wr_pvkit/readmpm3pm.py "1" "192.168.192.15" "8899" "8" >>${MYLOGFILE} 2>&1
fi
read pvwatt <${RAMDISKDIR}/pvwatt
echo $pvwatt


