#!/bin/sh -xe
sudo cp gnt-monitor /etc/ganeti/
sudo gnt-cluster copyfile /etc/ganeti/gnt-monitor
sudo cp systemd/gnt-monitor.service /etc/systemd/system/
sudo gnt-cluster copyfile /etc/systemd/system/gnt-monitor.service
sudo gnt-cluster command systemctl daemon-reload
sudo gnt-cluster command systemctl enable gnt-monitor
sudo gnt-cluster command killall gnt-monitor
sudo gnt-cluster command systemctl start gnt-monitor
sudo gnt-cluster command systemctl status gnt-monitor
