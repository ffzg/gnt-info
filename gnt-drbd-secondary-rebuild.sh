#!/bin/sh -xe

test -z "$1" && echo "Usage: $0 node" && exit 1
node=$1

gnt-node list-drbd --no-headers $node | grep secondary | awk '{ print $3 }' | sort -u | while read instance ; do
	echo "## $instance";
	gnt-instance stop $instance
	gnt-instance modify -t plain $instance
	gnt-instance modify -t drbd -n $node --no-wait-for-sync $instance
	gnt-instance start $instance
done

