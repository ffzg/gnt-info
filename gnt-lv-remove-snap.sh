#!/bin/sh -e

if [ "$1" = "run" ] ; then

dmsetup ls --tree | grep snap-1 | cut -d" " -f1 | xargs -i dmsetup remove {}
ls /dev/mapper/*snap | xargs -i lvremove -f {}

else

cp $0 /dev/shm/snap-remove.sh
gnt-cluster copyfile /dev/shm/snap-remove.sh
gnt-cluster command -M sh -e /dev/shm/snap-remove.sh run

fi
