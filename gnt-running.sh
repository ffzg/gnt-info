gnt-job list | grep running | awk '{ print $1 }' | xargs gnt-job watch
