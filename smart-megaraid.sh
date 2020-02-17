#!/bin/sh

# Usage:
# smart-megaraid.sh '^# 1'		# default without args
# SMART="-t long" smart-megaraid.sh	# execute smart command

pattern='(^# [1-2]|test remaining|Hours|Error|Serial|Model|Firmware|Load|Reallocated|Pending|failure)'
test ! -z "$1" && pattern=$*

did_megaraid=0

megaraid() {
	test $did_megaraid -eq 1 && return
	drive=$1
	nr=0
	while [ $nr -lt 8 ] ; do
		test ! -z "$SMART" && smartctl -d megaraid,$nr $SMART /dev/$drive > /dev/shm/smart.$drive.$nr-out
		smartctl -d megaraid,$nr -a /dev/$drive > /dev/shm/smart.$drive.$nr
		nr=`expr $nr + 1`
	done
	did_megaraid=1
}

test -r /proc/mdstat && cat /proc/mdstat

lsblk --noheadings --scsi -o name | while read drive ; do
	test ! -z "$SMART" && smartctl $SMART /dev/$drive > /dev/shm/smart.$drive-out
	smartctl -a /dev/$drive > /dev/shm/smart.$drive
	if egrep -q '(PERC|MegaRaid|DELL)' /dev/shm/smart.$drive ; then
		megaraid $drive
		rm /dev/shm/smart.$drive
	fi
done

egrep -i "$pattern" /dev/shm/smart.* | grep -v -- '-  *0$' | cut -d. -f2- | sed -e 's/:/\t/'
