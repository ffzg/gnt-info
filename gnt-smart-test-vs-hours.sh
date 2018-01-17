#!/bin/sh -xe

#sudo ./gnt-smart.sh > /tmp/smart
egrep 'Power_On_Hours' /tmp/smart | sed 's/: /:/' > /tmp/smart.2
egrep '# 1' /tmp/smart | sed 's/: /:/' > /tmp/smart.1
join /tmp/smart.1 /tmp/smart.2 | sed 's/ - .*Always - / ~ /'
