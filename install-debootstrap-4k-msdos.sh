#!/bin/sh -xe

if [ ! -e /etc/ganeti/os/debootstrap/common.sh ] ; then
	mkdir -pv /etc/ganeti/os/debootstrap
	cp -pv /usr/share/ganeti/os/debootstrap/common.sh /etc/ganeti/os/debootstrap/
	ln -sfv /etc/ganeti/os/debootstrap/common.sh /usr/share/ganeti/os/debootstrap/common.sh
	read -p "Overwrite file and copied to /etc/, press enter to patch" wait_for_enter
	cd /etc/ganeti/os/debootstrap/
	cat /srv/gnt-info/doc/deboostrap-4k-msdos.diff | sed 's/common.sh.in/common.sh/' | patch -p1
fi
