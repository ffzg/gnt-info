#!/bin/sh -xe

instance=$1

test -z "$instance" && echo "Usage: $0 instance" && exit 1

node=`gnt-instance list --no-headers -o pnode $instance`

ssh $node /srv/gnt-info/drbd-watch.sh
