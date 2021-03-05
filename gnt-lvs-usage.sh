#!/bin/sh -e

gnt-cluster command -M lvs -o vg_name,name,size,tags --unit g --noheadings | grep -v '^return' | grep -v '^--*$' | tee /dev/shm/gnt-lvs.clean

echo "# total by inacnes (with replicas):"
cat /dev/shm/gnt-lvs.clean | awk -F ' ' '{a[$5] += $4} END{for (i in a) print i, a[i]}' | tee /dev/shm/lvs.instance.replicas

echo "# total by inacnes (without replicas):"
cat /dev/shm/gnt-lvs.clean | awk -F ' ' '{a[$5]  = $4} END{for (i in a) print i, a[i]}' | tee /dev/shm/lvs,instancs.data

echo "# total by nodes:"
cat /dev/shm/gnt-lvs.clean | awk -F ' ' '{a[$1] += $4} END{for (i in a) print i, a[i]}' | tee /dev/shm/lvs.nodes

