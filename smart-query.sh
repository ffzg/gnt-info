#!/bin/sh

rm /tmp/s.last

for col in "Device Model" "User Capacity"
do
	# sed and sort is required for join later
	grep "$col" /dev/shm/smart.sda.* | sed 's/:/: /' | sed "s/$col: */ : /" | sort | tee /tmp/s.this

	if [ -e /tmp/s.last ] ; then
		join -a 1 /tmp/s.last /tmp/s.this | tee /tmp/s.new
	else
		mv /tmp/s.this /tmp/s.last
	fi
done

cat /tmp/s.new | column -t -s :
