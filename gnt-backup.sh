#!/bin/sh -xe

node=`hostname -s`
zfs_nfs=lib10
ganeti_export=lib10/arh-hw/ganeti/export

while true ; do

if [ -z "$1" ] ; then
	ssh root@$zfs_nfs zfs list -o name,written,compressratio -t snapshot -r $ganeti_export
	exit 0
fi

mount | grep /var/lib/ganeti/export || mount $zfs_nfs:/var/lib/ganeti/export /var/lib/ganeti/export/

instance=$1

gnt-instance list -o name,status,oper_vcpus,oper_ram,disk_usage,pnode,snodes $instance
gnt-backup export --noshutdown -n $node $instance || true # ignore error on swap partition
ssh root@$zfs_nfs zfs snap ${ganeti_export}@`date +%Y-%m-%d`_${instance}

shift

done

umount /var/lib/ganeti/export/
