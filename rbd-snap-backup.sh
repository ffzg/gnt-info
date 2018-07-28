#!/bin/sh -xe

instance=$1
disk=$2

test -z "$1" -o -z "$2" && echo "Usage: $0 instance disk" && exit 1

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

# execute something on mounted filesystem
read -p "wait for key" key


umount /dev/shm/$rbd_image.snap

rbd unmap backup-$instance-$disk
rbd rm    backup-$instance-$disk

rbd snap unprotect $rbd_image@backup
rbd snap rm        $rbd_image@backup

rmdir /dev/shm/$rbd_image.snap

