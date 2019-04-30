#!/bin/sh -xe

instance=$1
test -z "$instance" && echo "Usage:$0 instance [0|intefrace]" && exit 1
interface=$2
test -z "$interface" && interface=0

on_node=`gnt-instance list --no-header -o pnode $instance`
mac=`gnt-instance info --static $instance | grep MAC: | awk -v nr=$interface 'BEGIN { line=0 } { if ( line == nr ) { print $2 } line = line + 1 }'`
tap=`ssh $on_node cat /var/run/ganeti/kvm-hypervisor/nic/$instance/$interface || exit 1`
ssh $on_node "tcpdump -i $tap -v ether host $mac"
