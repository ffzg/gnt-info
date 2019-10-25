#!/bin/sh

job=$1

test -z "$job" && echo "Usage: $0 job_id" && exit 1

ls /var/lib/ganeti/queue/job-* | sed 's/^.*job-//'  | awk '{ if ( $1 < 3194118 ) print "/var/lib/ganeti/queue/job-"$1 }' | xargs rm -v


