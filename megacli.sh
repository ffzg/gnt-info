#!/bin/sh

if [ "$1" = "install" ] ; then

	cat >/dev/apt/sources.list.d/hwraid.list << __SOURCES__
# wget -O - https://hwraid.le-vert.net/debian/hwraid.le-vert.net.gpg.key | sudo apt-key add -
deb http://hwraid.le-vert.net/debian stretch main
__SOURCES__
	wget -O - https://hwraid.le-vert.net/debian/hwraid.le-vert.net.gpg.key | sudo apt-key add -
	apt-get update
	apt-get install megacli

elif [ ! -z "$1" ] ; then
	megacli -$* -aALL | tee /dev/shm/megacli.$1
	exit 0
fi

megacli -AdpAllInfo -aALL | tee /dev/shm/megacli.AdpAllInfo

megacli -LdPdInfo -aALL | tee /dev/shm/megacli.AdpAllInfo

megacli -AdpAlILog -aALL | tee /dev/shm/megacli.AdpAlILog | egrep -v '(Sense|IllegalReq|Rdm|Unknown DCDB Opcode)'

