#!/bin/sh -e

instance=$1

test -z "$instance" && echo "Usage: $0 instance" && exit 1

while ! connection=`gnt-instance info $instance | tee /dev/shm/$instance | grep 'console connection:'` ; do
	echo "# [$connection]"
	read -p "$instance VNC disabled, enable? [YES, abort with CTRL+C now] " no_abort
	gnt-instance modify -H vnc_bind_address=127.0.0.1 $instance
	#gnt-instance reboot $instance
done

echo $connection | tr -d '()' | tr ':' ' ' | awk '{ print "ssh -L "$6":"$5":"$6" "$8"\nvncviewer localhost:"$10 }' | sed "s/\.gnt\.ffzg\.hr/.net.ffzg.hr/"

