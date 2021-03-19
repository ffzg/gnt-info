#!/bin/sh -e

instance=$1
disk=$2
target_vg=ssd

# to specify target vg use VG enviroment varible like:
# VG=oscarvg ./gnt-lv2ssd.sh dataverse 0

if [ "$1" = '-' ] ; then
	read instance disk
elif [ -z "$instance" -o -z "$disk" ] ; then
	echo "Usage: $0 instance disk"
	exit 1
fi

test -z "$instance" && exit 1

test ! -z "$VG" && target_vg=$VG

instance=`gnt-instance list --no-headers -o name $instance | head -1`

node=`gnt-instance list -o pnode --no-headers $instance`
echo "# $instance on $node"

found_lvm=0

ssh $node lvs -o name,tags,vg_name,size | grep $instance | tee /dev/shm/$instace.$node.lvs | grep disk${disk}_data | while read lv origin vg size ; do
	found_lvm=1

	disk_nr=`echo $lv | cut -d. -f2 | tr -d a-z_`
	echo "# $lv | $origin | $disk_nr"

cat <<__SHELL__ > /dev/shm/$instance.sh

	lvcreate -L20480m -s -n$lv.snap /dev/$vg/$lv

	lvcreate -L$size -n$instance.$disk_nr $target_vg
	
	ionice dd if=/dev/$vg/$lv.snap of=/dev/$target_vg/$instance.$disk_nr bs=1M status=progress

	lvremove -f /dev/$vg/$lv.snap

	#rm -v /dev/shm/$instance.sh
__SHELL__

	scp /dev/shm/$instance.sh $node:/dev/shm/$instance.sh

	ssh $node sh -xe /dev/shm/$instance.sh


	echo "TEST: kvm -m 1024 -drive file=/dev/$target_vg/$instance.$disk_nr,format=raw,if=virtio -nographic -net nic -net user"
	echo "after login: ifdown eth0 ; dhclient eth0"
done

