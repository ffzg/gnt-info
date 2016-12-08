#!/bin/sh -xe
sudo cp gnt-monitor /etc/ganeti/
sudo gnt-cluster copyfile /etc/default/gnt-monitor

sudo cp init.d/gnt-monitor /etc/init.d/gnt-monitor
sudo gnt-cluster copyfile /etc/init.d/gnt-monitor

#sudo gnt-cluster command apt-get install psmisc
sudo gnt-cluster command killall gnt-monitor

sudo gnt-cluster command service gnt-monitor restart
sudo gnt-cluster command service gnt-monitor status
