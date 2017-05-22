while true ; do grep -B 2 -A 1 sync /proc/drbd /proc/mdstat ; sleep 3 ; done
