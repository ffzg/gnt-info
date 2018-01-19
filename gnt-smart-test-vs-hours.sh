#!/bin/sh -e

test -e /dev/shm/gnt-smart || sudo ./gnt-smart.sh
egrep 'Power_On_Hours' /dev/shm/gnt-smart | sed 's/: /:/' > /dev/shm/gnt-smart.2
egrep '# 1' /dev/shm/gnt-smart | sed 's/: /:/' > /dev/shm/gnt-smart.1
egrep 'Serial' /dev/shm/gnt-smart | sed 's/: /:/' > /dev/shm/gnt-smart.3
join /dev/shm/gnt-smart.1 /dev/shm/gnt-smart.2 | sed 's/ [0-9]* Power_On_Hours.*Always - / ~ /' > /dev/shm/gnt-smart.12
join /dev/shm/gnt-smart.12 /dev/shm/gnt-smart.3 | sed -e 's/ *- *~/ -\t~/' -e 's/ *~ */\t/' -e 's/Serial.*:/\t/' | tee /dev/shm/gnt-smart.out
