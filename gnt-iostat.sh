#!/bin/sh -xe

#ls -al /var/run/ganeti/instance-disks/* | sed -e 's/^.*instance-disks\/\(.*\):\([0-9]*\).*dev\/\(.*\)/s\/^\3 *\/\1:\2\t\//' > /dev/shm/gnt-iostat.sed
ls -al /var/run/ganeti/instance-disks/* | sed -e 's/^.*instance-disks\///' -e  's/ -> \/dev\// /' | awk '{ printf "s/^%s */%-20s/\n", $2, $1 }' > /dev/shm/gnt-iostat.sed

iostat 3 | egrep --line-buffered -v '^(dm-|sd|md|bcache|.*0.00 *0.00 *0.00 *0 *0)' | sed --unbuffered -f /dev/shm/gnt-iostat.sed

