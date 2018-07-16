while true ; do echo ; grep -B 2 -A 1 sync /proc/drbd /proc/mdstat | egrep -v '(^--$|ns:)' ; egrep '(WFConnection|Unknown)' /proc/drbd ; sleep 3 ; done
