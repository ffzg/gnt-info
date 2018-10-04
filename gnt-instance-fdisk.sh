#!/bin/sh -xe

instance=$1

gnt-instance info --static $instance > /dev/shm/$instance
node=`grep 'primary:' /dev/shm/$instance | cut -d: -f2 | tr -d ' '`
lv=`grep 'logical_id:' /dev/shm/$instance | cut -d: -f2 | tr -d ' '`
ssh $node fdisk -l /dev/$lv

