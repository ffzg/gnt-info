#!/bin/sh -xe

gnt-cluster command -M lvs -o vg_name,name,size,tags | grep -v '^return' | tee /dev/shm/gnt-lvs
