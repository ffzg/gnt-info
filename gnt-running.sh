#!/bin/sh -xe
while true ; do
gnt-job list --no-headers --running | tee /dev/stderr | awk '{ print $1 }' | xargs gnt-job watch
done
