#!/bin/sh -e
while true ; do
  JOBID=`gnt-job list --no-headers --running | tee /dev/stderr | tail -1 | awk '{ print $1; exit }'`
  if [ -n "$JOBID" ]
  then
	gnt-job watch $JOBID || true # don't exit on failed jobs
  else
	sleep 5
  fi
done
