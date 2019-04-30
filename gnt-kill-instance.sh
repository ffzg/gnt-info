#!/bin/sh -xe

instance=$1
test -z "$instance" && echo "Usage:$0 instance [0|intefrace]" && exit 1

on_node=`gnt-instance list --no-header -o pnode $instance`
pid=`ssh $on_node cat /var/run/ganeti/kvm-hypervisor/pid/$instance || exit 1`
ssh $on_node "kill -9 $pid"
