#!/bin/sh -e

dir=/dev/shm/instance
test -e $dir || mkdir $dir

gnt-instance list -o name,disk_template | grep ' rbd$' | cut -d' ' -f1 | while read instance ; do
	if [ ! -e $dir/$instance ] ; then
		gnt-instance info $instance | tee > $dir/$instance
	fi
done

grep --with-filename logical_id /dev/shm/instance/* | sed "s/^.*\///; s/:.*, '/ /; s/'.*$//;" | tee /dev/shm/instance-rbd | while read instance disk ; do
	echo "$instance $disk"
	rbd snap ls $disk | grep -v SNAPID | awk -v instance=$instance -v disk=$disk '{ print instance,disk"@"$2,"#"$1,$3,$4 }'
done

