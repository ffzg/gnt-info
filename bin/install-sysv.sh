#!/bin/sh -xe
sudo cp -v gnt-monitor /etc/ganeti/
sudo gnt-cluster copyfile /etc/ganeti/gnt-monitor

test -e /etc/default/gnt-monitor || cp -v default/gnt-monitor /etc/default/ && echo "# modify config here"
sudo gnt-cluster copyfile /etc/default/gnt-monitor

sudo cp init.d/gnt-monitor /etc/init.d/gnt-monitor
sudo gnt-cluster copyfile /etc/init.d/gnt-monitor

#sudo gnt-cluster command apt-get install psmisc
#sudo gnt-cluster command killall -r gnt-monitor

sudo gnt-cluster command service gnt-monitor restart
sudo gnt-cluster command 'ps ax | grep gnt-monitor'
