#!/bin/sh -xe

test -z "$KERNEL" || KERNEL=4.9
#KERNEL=3.10
#KERNEL=3.2

ver=$( ls /boot/config*-4.9* | sort --field-separator="-" --key=5 --reverse | head -1 | cut -d- -f2- )

tar cfvpz /tmp/$ver.tar.gz /lib/modules/$ver
ls -al /tmp/$ver.tar.gz

#gnt-instance modify -H initrd_path=/boot/initrd.img-$ver,kernel_path=/boot/vmlinuz-$ver $1
#gnt-instance modify -H kernel_args="ro net.ifnames=0 biosdevname=0" influx # keep old eth0 names
gnt-instance modify -H initrd_path=/boot/initrd.img-$ver,kernel_path=/boot/vmlinuz-$ver,kernel_args="ro net.ifnames=0 biosdevname=0" $1


