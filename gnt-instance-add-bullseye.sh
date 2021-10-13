#!/bin/sh -xe
mem=2G
disk=10G
cpu=2
instance=$1

test -z "$instance" && echo "Usage: $0 instance-name" && exit 1

gnt-instance add -B maxmem=$mem,vcpus=$cpu -t drbd -n r1u32:r1u28 -o debootstrap+bullseye -s $disk --no-name-check --no-ip-check --no-start $instance
gnt-instance modify -H initrd_path=,kernel_path= $instance
gnt-instance start $instance

