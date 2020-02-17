#!/bin/sh -xe

gnt-cluster command -M vgs --units g --noheadings | grep -v '^return' | awk '{ print $0 " " $7 - $8 }' | tee /dev/shm/gnt-vgs-usage

