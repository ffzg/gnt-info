#!/bin/sh -xe
gnt-job list --no-headers --running | awk '{ print $1 }' | xargs gnt-job watch
