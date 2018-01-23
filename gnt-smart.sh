#!/bin/sh -e

if [ "$1" = "clean" ] ; then
	gnt-cluster command -M rm -v '/dev/shm/*smart*'
fi

cp /srv/gnt-info/smart-megaraid.sh /tmp/
gnt-cluster copyfile /tmp/smart-megaraid.sh
gnt-cluster command -M /tmp/smart-megaraid.sh $* | tee /dev/shm/gnt-smart
