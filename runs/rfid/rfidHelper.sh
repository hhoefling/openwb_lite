#!/bin/bash
#
# 8.7.2022 umstellung auf python3 (needs evdev )
#
if [[ -z "$OPENWBBASEDIR" ]]; then
	OPENWBBASEDIR=$(cd "$(dirname "$0")/../../" && pwd)
	OPENWBBASEDIR=/var/www/html/openWB
	RAMDISKDIR="${OPENWBBASEDIR}/ramdisk"
fi

declare -F openwbDebugLog &> /dev/null || {
	. "$OPENWBBASEDIR/helperFunctions.sh"
}

rfidInputHandlerStart(){

	# daemon for input0
	if [[ -r /dev/input/event0 ]] ; then
		if pgrep -f '^python.*/readrfid.py -d event0' > /dev/null
		then
			openwbDebugLog "MAIN" 1 "rfid configured and handler for event0 is running"
		else
			openwbDebugLog "MAIN" 0 "rfid configured but handler for event0 not running; starting process"
			sudo python3 "$OPENWBBASEDIR/runs/rfid/readrfid.py" -d event0 &
		fi
	fi

	# daemon for input1
	if [[ -r /dev/input/event1 ]] ; then
		if pgrep -f '^python.*/readrfid.py -d event1' > /dev/null
		then
			openwbDebugLog "MAIN" 1 "rfid configured and handler for event1 is running"
		else
			openwbDebugLog "MAIN" 0 "rfid configured but handler for event1 not running; starting process"
			sudo python3 "$OPENWBBASEDIR/runs/rfid/readrfid.py" -d event1 &
		fi	
	fi
}
export -f rfidInputHandlerStart

rfidInputHandlerStop(){
	openwbDebugLog "MAIN" 0 "rfid stop readrfid.py process"
	sudo pkill -f '^python.*/readrfid.py' >/dev/null
}
export -f rfidInputHandlerStop

rfidMode2Start(){
	if pgrep -f '^python.*/rfidDaemon.py' > /dev/null
	then
		openwbDebugLog "MAIN" 1 "rfid handler already running"
	else
		openwbDebugLog "MAIN" 0 "rfid handler not running! starting process"
		python3 "$OPENWBBASEDIR/runs/rfid/rfidDaemon.py" &
	fi
}
export -f rfidMode2Start

rfidMode2UpdateList(){
	echo "$1" > "$RAMDISKDIR/rfidlist"
}
export -f rfidMode2UpdateList

rfidMode2Stop(){
	openwbDebugLog "MAIN" 1 "rfid stop rfidDaemon.py process"
	sudo pkill -f '^python.*/rfidDaemon.py' >/dev/null
}
export -f rfidMode2Stop

rfidSetup(){
	local mode=$1
	local forceRestart=$2
	local tagList=$3

	if (( forceRestart == 1 )); then
		openwbDebugLog "MAIN" 0 "rfid handler restart forced! killing daemons"
		rfidMode2Stop
		rfidInputHandlerStop
	fi
	if (( mode == 0 )); then
		rfidMode2Stop
		rfidInputHandlerStop
	else
		rfidInputHandlerStart
	fi
	if (( mode == 2 )); then
		rfidMode2UpdateList "$tagList"
		rfidMode2Start
	else
		rfidMode2Stop
	fi
}
export -f rfidSetup
