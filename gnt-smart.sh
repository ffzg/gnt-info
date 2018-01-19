#!/bin/sh -e

cp /srv/gnt-info/smart-megaraid.sh /tmp/
gnt-cluster copyfile /tmp/smart-megaraid.sh
gnt-cluster command -M /tmp/smart-megaraid.sh $* | tee /dev/shm/gnt-smart
