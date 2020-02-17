#!/bin/sh -xe

gnt-cluster command -M lvs -o vg_name,name,size,tags --unit g | grep -v '^return' | tee /dev/shm/gnt-lvs
