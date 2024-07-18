#!/bin/sh -xe

gnt-instance list -o name,status,oper_vcpus,oper_ram,disk_usage,pnode,snodes  \
| grep -v ADMIN_down | tee /dev/stderr | numfmt --header --field 4,5 --from=iec | tee /dev/null | awk '{cpu += $3 ; memory += $4 ; total += $5}END{print "\nmemory\t" memory "\n  disk " total "\n   cpu " cpu}' | numfmt --field 2 --to=iec --padding=8
