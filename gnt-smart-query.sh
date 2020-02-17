#!/bin/sh -xe

cp smart-query.sh /tmp/smart-query.sh
gnt-cluster copyfile /tmp/smart-query.sh

# in column names, replace space with dot, eg:
# Serial Number -> Serial.Number

gnt-cluster command -M \
	/tmp/smart-query.sh Power_On_Hours Reallocated_Sector_Ct Serial.Number $@ \
| grep -v '^return' | grep -v '^--*$' \
| tee /dev/shm/gnt-smart-query | column -t -s :

