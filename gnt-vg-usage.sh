#!/bin/sh -xe

gnt-cluster command -M vgs --units g | grep -v '^return' | awk '{ if ( $7 - $8 != 0 ) print $0 " " $7 - $8 ; else print $0 ; }' | tee /dev/shm/gnt-vgs-usage

