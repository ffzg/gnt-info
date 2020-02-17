#!/bin/sh -e

test -e /tmp/s.last && rm /tmp/s.last

for col in "Device Model" "User Capacity" $*
do
	# sed and sort is required for join later
	grep "$col" /dev/shm/smart.sda.* | sed 's/:/: /' | sed \
		-e "s/$col: */ : /" \
		-e "s/[0-9]* $col .* \([0-9][0-9]*\)$/\1/" \
	| sort > /tmp/s.this

	if [ -e /tmp/s.last ] ; then
		join -a 1 /tmp/s.last /tmp/s.this > /tmp/s.new
		mv /tmp/s.new /tmp/s.last
	else
		mv /tmp/s.this /tmp/s.last
	fi
done

cat /tmp/s.last | column -t -s :
