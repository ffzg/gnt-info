./gnt-backup.sh `gnt-instance list --no-headers -o name,status | grep 'running$' | awk '{ print $1 }'`

