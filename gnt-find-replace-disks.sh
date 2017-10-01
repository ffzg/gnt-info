#!/bin/sh -e

# find instances which are running but have some lvs closed which require gnt-instance replace-disks

gnt-cluster command -M lvs -o attr,tags,name | grep originstname | grep -v 'ao' | awk '{ print $1 " " $3  }' | cut -d+ -f2 | sort -u | xargs -i gnt-instance list --no-headers -o name,status {} | grep ' running$'

