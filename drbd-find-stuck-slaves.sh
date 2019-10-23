#!/bin/sh

cat /proc/drbd | grep cs:WFConnection | cut -d: -f1 | tr -d ' ' | sed 's/^/drbd/' > /dev/shm/drbd.WFConnection
ls -l /var/run/ganeti/instance-disks/ | grep -f /dev/shm/drbd.WFConnection
