#!/bin/sh -xe

gnt-cluster command -M pvs --units t | grep -v '^return' | awk '{ if ( $6 - $7 != 0 ) print $0 " " $6 - $7 ; else print $0 ; }' | tee /dev/shm/gnt-pv-usage

