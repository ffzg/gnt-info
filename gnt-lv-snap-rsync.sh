#!/bin/sh -e

instance=$1
disk=$2

if [ -z "$instance" -o -z "$disk" ] ; then
	echo "Usage: $0 instance disk"
	exit 1
fi

instance=`gnt-instance list --no-headers -o name $instance`

node=`gnt-instance list -o pnode --no-headers $instance`
echo "# $instance on $node"

ssh $node lvs -o name,tags | grep $instance | tee /dev/shm/$instace.$node.lvs | grep disk${disk}_data | while read lv origin ; do
	disk_nr=`echo $lv | cut -d. -f2 | tr -d a-z_`
	echo "# $lv | $origin | $disk_nr"

cat <<__SHELL__ | tee /dev/shm/$instance.sh
	lvcreate -L20480m -s -n$lv.snap /dev/ffzgvg/$lv
	mkdir /dev/shm/$lv.snap
	mount /dev/ffzgvg/$lv.snap /dev/shm/$lv.snap -o ro
	rsync -ravHz --numeric-ids --sparse --delete /dev/shm/$lv.snap/ lib15::backup/$instance/$disk_nr/
	umount /dev/shm/$lv.snap
	lvremove -f /dev/ffzgvg/$lv.snap
__SHELL__

	scp /dev/shm/$instance.sh $node:/dev/shm/$instance.sh

	ssh $node sh -xe /dev/shm/$instance.sh

	date=`date +%Y-%m-%d`
	ssh lib15 zfs snap lib15/backup/$instance/$disk_nr@$date
done


