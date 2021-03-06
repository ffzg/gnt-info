#!/bin/sh -xe

test -z "$1" -o -z "$2" && echo "Usage: $0 instance disk" && exit 1

instance=$1
disk=$2
test -z "$backup" && backup="backup"
test -z "$rsync_server" && rsync_server="lib15"

test "`rsync $rsync_server::$backup/$instance/$disk 2>/dev/null | wc -l`" != 1 && echo "ERROR $rsync_server::$backup/$instance/$disk backup target missing" && exit 1

rbd_image=`gnt-instance info --static $instance | grep logical_id: | cut -d\' -f4 | grep "\.rbd\.disk$disk\$"`

test -z "$rbd_image" && echo "can't find rbd_image name for $instance $disk" && exit 1

rbd snap add     $rbd_image@backup
rbd snap protect $rbd_image@backup

rbd clone        $rbd_image@backup backup-$instance-$disk

rbd_dev=`rbd map backup-$instance-$disk`

test -d /dev/shm/$rbd_image.snap || mkdir /dev/shm/$rbd_image.snap

# we must mount filesystem read-write to allow journal recovery
offset=`fdisk -l $rbd_dev -u -o Device,Start,Type | grep 'Linux$' | grep $rbd_dev | head -1 | sed 's/\*/ /' | awk '{ print \$2 * 512 }'`
test ! -z "$offset" && offset=",offset=$offset"
mount $rbd_dev /dev/shm/$rbd_image.snap -o noatime$offset


# XXX do rsync back to $rsync_server

rsync_args=""
if rsync $rsync_server::$backup/$instance/rsync.args /dev/shm/$instance-rsync.args 2>/dev/null ; then
	rsync_args="`cat /dev/shm/$instance-rsync.args`"
fi

rsync -ravHzXA --inplace --numeric-ids --delete $rsync_args \
	/dev/shm/$rbd_image.snap/ $rsync_server::$backup/$instance/$disk/ \
&& ssh -i /etc/ganeti/id_dsa-zfs-snap $rsync_server $rsync_server/$backup/$instance/$disk

# XXX backup OK



umount /dev/shm/$rbd_image.snap

rbd unmap backup-$instance-$disk
rbd rm    backup-$instance-$disk

rbd snap unprotect $rbd_image@backup
rbd snap rm        $rbd_image@backup

rmdir /dev/shm/$rbd_image.snap

