#!/bin/sh -e

gnt-cluster command -M ls -l /var/run/ganeti/instance-disks/ | awk '{ print $1 $12 " " $10 }' | tr ':' ' ' > /dev/shm/node.drbd.instance.disk

gnt-cluster command -M cat /proc/drbd | grep cs: | grep -v Connected | tee /dev/shm/drbd.check | \
	sed 's/: / /g' | \
	while read node drbd status ; do
		echo "$node $drbd [$status]"
		grep "$node.*drbd$drbd " /dev/shm/node.drbd.instance.disk || echo "ERROR: can't find $node $drbd"
	done

