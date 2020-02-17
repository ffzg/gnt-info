#!/bin/sh -xe

gnt-cluster command -M lsblk --scsi -m | grep -v '^return' | tee /dev/shm/gnt-disks | grep -v cdrom

gnt-cluster command -M lsblk --scsi --output SIZE,MODEL --noheadings | grep -v '^return' | grep -v '^----*$' | tee /dev/shm/gnt-disk-size-model | cut -d: -f2- | sort | uniq -c

