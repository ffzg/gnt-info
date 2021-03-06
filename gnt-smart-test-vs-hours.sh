#!/bin/sh -e

test -e /dev/shm/gnt-smart || sudo ./gnt-smart.sh
egrep '# 1' /dev/shm/gnt-smart | sed 's/: /:/' | sort > /dev/shm/gnt-smart.1
egrep 'Power_On_Hours' /dev/shm/gnt-smart | sed 's/: /:/' | sort > /dev/shm/gnt-smart.2
egrep 'Serial' /dev/shm/gnt-smart | sed 's/: /:/' | sort > /dev/shm/gnt-smart.3
join -a 2 /dev/shm/gnt-smart.1 /dev/shm/gnt-smart.2 | sed 's/ [0-9]* Power_On_Hours.*Always - / ~ /' | sort > /dev/shm/gnt-smart.12
join -a 1 /dev/shm/gnt-smart.12 /dev/shm/gnt-smart.3 | sed -e 's/ *- *~/ -\t~/' -e 's/ *~ */\t/' -e 's/Serial.*:/\t/' > /dev/shm/gnt-smart.123
egrep 'Load' /dev/shm/gnt-smart | sed 's/: /:/' | awk '{ print $1 " " $11 }' | sort > /dev/shm/gnt-smart.4
join -a 1 /dev/shm/gnt-smart.123 /dev/shm/gnt-smart.4 | sort | tee /dev/shm/gnt-smart.1234
