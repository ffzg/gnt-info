#!/bin/sh -xe

instance=$1
node=arh-hw
ganeti_export=arh-hw/ganeti/export

if [ -z "$instance" ] ; then
	ssh $node zfs list -t all -r $ganeti_export
	exit 0
fi

gnt-backup export --noshutdown -n $node $instance || true # ignore error on swap partition
ssh $node zfs snap ${ganeti_export}@`date +%Y-%m-%d`_${instance}


