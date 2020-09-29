#!/bin/sh

job=$1

test -z "$job" && echo "Usage: $0 job_id" && exit 1

ls /var/lib/ganeti/queue/job-* | sed 's/^.*job-//'  | awk -vjob=$job '{ if ( $1 < job ) print "/var/lib/ganeti/queue/job-"$1 }' | xargs echo rm -v


