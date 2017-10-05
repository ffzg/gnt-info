#!/bin/sh -e

instance=$1
disk=$2
test -z "$backup" && backup="backup"

if [ "$1" = '-' ] ; then
	read instance disk
elif [ -z "$instance" -o -z "$disk" ] ; then
	echo "Usage: $0 instance disk"
	exit 1
fi

test -z "$instance" && exit 1

instance=`gnt-instance list --no-headers -o name $instance | head -1`

node=`gnt-instance list -o pnode --no-headers $instance`
echo "# $instance on $node"

vg=`gnt-cluster info | grep 'lvm volume group:' | cut -d: -f2 | tr -d ' '`

ssh $node lvs -o name,tags | grep $instance | tee /dev/shm/$instace.$node.lvs | grep disk${disk}_data | while read lv origin ; do
	disk_nr=`echo $lv | cut -d. -f2 | tr -d a-z_`
	echo "# $lv | $origin | $disk_nr"

cat <<__SHELL__ > /dev/shm/$instance.sh

	lvcreate -L20480m -s -n$lv.snap /dev/$vg/$lv

	mkdir /dev/shm/$lv.snap

	# we must mount filesystem read-write to allow journal recovery
	offset=\`fdisk -l /dev/$vg/$lv.snap -u | grep Linux$ | grep /dev/$vg/$lv.snap | head -1 | sed 's/\*/ /' | awk '{ print \$2 * 512 }'\`
	test ! -z "\$offset" && offset=",offset=\$offset"
	mount /dev/$vg/$lv.snap /dev/shm/$lv.snap -o noatime\$offset

	rsync -ravHzXA --inplace --numeric-ids --delete /dev/shm/$lv.snap/ lib15::$backup/$instance/$disk_nr/

	umount /dev/shm/$lv.snap

	lvremove -f /dev/$vg/$lv.snap

	rmdir /dev/shm/$lv.snap
	rm -v /dev/shm/$instance.sh
__SHELL__

	scp /dev/shm/$instance.sh $node:/dev/shm/$instance.sh

	ssh $node sh -xe /dev/shm/$instance.sh

	# execute zfs snap on lib15 via ssh command="" wrapper
	ssh -i /root/.ssh/id_dsa-zfs lib15 lib15/$backup/$instance/$disk_nr
done


