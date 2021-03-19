#!/bin/sh -xe

# insert bootable partition table at beginning of lv

test -z "$1" || test ! -e "$1" && echo "Usage: $0 /path/to/lv" && exit 1

lvs --noheadings -o vg_name,name,lv_size $1 | tee /dev/stderr | while read vg_name name lv_size ; do
	lvcreate -s -L $lv_size -n ${name}.snap /dev/$vg_name/$name

	# create partition
	echo '2048,+,L,*' | sfdisk --no-reread /dev/$vg_name/$name

	# FIXME label?
	mkfs.ext4 -F -E offset=$(( 2048 * 512 )) /dev/$vg_name/$name

	mkdir /tmp/$name
	mount /dev/$vg_name/$name /tmp/$name -o offset=$(( 2048 * 512 ))


	mkdir /tmp/${name}.snap
	mount /dev/$vg_name/${name}.snap /tmp/${name}.snap

	rsync -raHX --numeric-ids --sparse /tmp/${name}.snap/ /tmp/$name/

	umount /tmp/${name}.snap
	umount /tmp/$name

	rmdir /tmp/${name}.snap
	rmdir /tmp/${name}

	lvremove -y /dev/$vg_name/${name}.snap
done
