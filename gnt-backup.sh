#!/bin/sh -xe

node=arh-hw
ganeti_export=arh-hw/ganeti/export

while true ; do

instance=$1
if [ -z "$instance" ] ; then
	ssh $node zfs list -o name,written,compressratio -t snapshot -r $ganeti_export
	exit 0
fi


gnt-instance list -o name,status,oper_vcpus,oper_ram,disk_usage,pnode,snodes $instance
gnt-backup export --noshutdown -n $node $instance || true # ignore error on swap partition
ssh $node zfs snap ${ganeti_export}@`date +%Y-%m-%d`_${instance}

shift

done
