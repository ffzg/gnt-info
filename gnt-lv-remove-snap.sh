#!/bin/sh -e

if [ "$1" = "run" ] ; then

# bind ganeti hanging snapshot
dmsetup ls --tree | grep snap-1 | cut -d" " -f1 | xargs -i dmsetup remove {}

# remove snap lvs
ls /dev/mapper/*.snap | xargs -i lvremove -f {}

else

# umount all snapshots
gnt-cluster command -M mount | grep snap | awk '{ print "ssh "$1" umount "$4 }' | sed 's/: / /' | xargs -i sh -exec {}

# remove mount directories
gnt-cluster command 'rmdir /dev/shm/*.snap'

# create shell command to run on all nodes
cp $0 /dev/shm/snap-remove.sh
gnt-cluster copyfile /dev/shm/snap-remove.sh
gnt-cluster command -M sh -e /dev/shm/snap-remove.sh run

fi
