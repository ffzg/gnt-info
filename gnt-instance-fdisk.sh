#!/bin/sh -xe

instance=$1

node=`gnt-instance list --no-headers -o pnode $instance`
ssh $node fdisk -l /var/run/ganeti/instance-disks/$instance:0


exit 0

gnt-instance info --static $instance > /dev/shm/$instance
node=`grep 'primary:' /dev/shm/$instance | cut -d: -f2 | tr -d ' '`
lv=`grep 'logical_id:' /dev/shm/$instance | head -1 | cut -d: -f2 | tr -d ' '`
ssh $node fdisk -l /dev/$lv


