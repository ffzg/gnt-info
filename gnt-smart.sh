#!/bin/sh -e

ls /dev/sd? | xargs -i sh -ec 'echo -n "{}\t" ; smartctl -l selftest {} | grep "^# 1"'
