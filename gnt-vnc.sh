#!/bin/sh -e

gnt-instance info $1 | grep 'console connection:' | tr -d '()' | tr ':' ' ' | awk '{ print "ssh -L "$6":"$5":"$6" "$8"\nvncviewer localhost:"$10 }'

