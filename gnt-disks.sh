#!/bin/sh -xe

gnt-cluster command -M lsblk --scsi -m | grep -v '^return' | tee /dev/shm/gnt-disks | grep -v cdrom
