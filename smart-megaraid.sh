#!/bin/sh

# Usage:
# smart-megaraid.sh '^# 1'		# default without args
# SMART="-t long" smart-megaraid.sh	# execute smart command

pattern='^# 1'
test ! -z "$1" && pattern=$1

megaraid() {
	drive=$1
	nr=0
	while [ $nr -lt 8 ] ; do
		test ! -z "$SMART" && smartctl -d megaraid,$nr $SMART /dev/$drive > /dev/shm/smart.$drive.$nr-out
		smartctl -d megaraid,$nr -a /dev/$drive > /dev/shm/smart.$drive.$nr
		nr=`expr $nr + 1`
	done
}

test -r /proc/mdstat && cat /proc/mdstat

lsblk --noheadings --scsi -o name | while read drive ; do
	test ! -z "$SMART" && smartctl $SMART /dev/$drive > /dev/shm/smart.$drive-out
	smartctl -a /dev/$drive > /dev/shm/smart.$drive
	if ! grep -q '^# 1' /dev/shm/smart.$drive ; then
		megaraid $drive
	fi
done

grep "$pattern" /dev/shm/smart.* | cut -d. -f2- | sed -e 's/:/\t/'


