#!/bin/sh -xe

KERNEL=3.16
#KERNEL=3.10
#KERNEL=3.2

gnt-instance modify -H initrd_path=/boot/initrd.img-$KERNEL-kvmU,kernel_path=/boot/vmlinuz-$KERNEL-kvmU $1

