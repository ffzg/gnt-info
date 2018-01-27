while true ; do echo ; grep -B 2 -A 1 sync /proc/drbd /proc/mdstat | egrep -v '(^--$|ns:)' ; sleep 3 ; done
