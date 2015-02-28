#!/bin/sh -xe

gnt-instance modify -H initrd_path=/boot/initrd.img-3.10-kvmU,kernel_path=/boot/vmlinuz-3.10-kvmU $1

