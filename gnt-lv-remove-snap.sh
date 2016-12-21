#!/bin/sh -xe

dmsetup ls --tree | grep snap-1 | cut -d" " -f1 | xargs -i dmsetup remove {}
ls /dev/mapper/*snap | xargs -i lvremove -f {}

