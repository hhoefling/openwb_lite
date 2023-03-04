#!/bin/bash
startms=$(($(date +%s%N)/1000000))
SELF=$(cd `dirname $0`   &&  pwd)
OPENWBBASEDIR=$(cd `dirname $0`/../../ && pwd)
RCT=$(basename `dirname $0`)
RCT=${RCT/bezug_/}
# rct2 oder rct2h oder rct2x

# check if config file is already in env
if [[ -z "$debug" ]]; then
	. $OPENWBBASEDIR/loadconfig.sh
	. $OPENWBBASEDIR/helperFunctions.sh
	openwbDebugLog "MAIN" 2 "${RCT^^}: $0 read modules"
fi

function Log()
{
 level=$1;
 shift;
 openwbDebugLog "MAIN" $level "${RCT^^}: $*"
}


Log 2 "pvwattmodul :$pvwattmodul"

debug=${1:-$debug}
#debug=3
#pvwattmodul="wr_${RCT,,}"

if (( debug > 2 )) ; then
  python3 $SELF/rct2.py --verbose --ip=$bezug1_ip  -w=$pvwattmodul  >>/var/log/openWB.log 2>&1 
else
  python3 $SELF/rct2.py --ip=$bezug1_ip  -w=$pvwattmodul >>/var/log/openWB.log 2>&1
fi 


endms=$(($(date +%s%N)/1000000))
let "ms=( endms - startms )"
Log 1 "wr runs $ms Millisec"


cat /var/www/html/openWB/ramdisk/pvwatt
