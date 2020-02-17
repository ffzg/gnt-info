#!/bin/sh -e

gnt-cluster command -M lsblk --scsi -m | grep -v '^return' | tee /dev/shm/gnt-disks | grep -v cdrom

echo "# from lsblk"
gnt-cluster command -M lsblk --scsi --output SIZE,MODEL --noheadings --bytes | grep -v '^return' | grep -v '^----*$' | tee /dev/shm/gnt-disk-size-model | cut -d: -f2- | sort | uniq -c | sort -k2 -n | tee /dev/shm/gnt-disks-models

echo "# from smart"
cat /dev/shm/gnt-smart-query | cut -d: -f3,4 | sort | uniq -c
