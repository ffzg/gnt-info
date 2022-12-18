#!/bin/sh -e

instance=$1
disk=$2
test -z "$backup" && backup="backup"
test -z "$rsync_server" && rsync_server="lib15"

if [ "$1" = '-' ] ; then
	read instance disk
elif [ -z "$instance" -o -z "$disk" ] ; then
	echo "Usage: $0 instance disk"
	exit 1
fi

test -z "$instance" && exit 1

instance=`gnt-instance list --no-headers -o name $instance | head -1`

node=`gnt-instance list -o pnode --no-headers $instance`
echo "# $instance on $node" > /dev/stderr

ssh $node lvs -o name,tags,vg_name | grep $instance | tee /dev/shm/$instace.$node.lvs | grep disk${disk}_data | while read lv origin vg ; do
	disk_nr=`echo $lv | cut -d. -f2 | tr -d a-z_`
	echo "# $lv | $origin | $disk_nr" > /dev/stderr

cat <<__SHELL__ > /dev/shm/$instance.sh

	lvcreate -L10240m -s -n$lv.snap /dev/$vg/$lv > /dev/stderr

	dd if=/dev/$vg/$lv.snap bs=1M

	lvremove -f /dev/$vg/$lv.snap > /dev/stderr
__SHELL__

	scp /dev/shm/$instance.sh $node:/dev/shm/$instance.sh

	ssh $node sh -e /dev/shm/$instance.sh

done

