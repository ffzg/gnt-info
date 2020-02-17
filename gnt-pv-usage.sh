gnt-cluster command -M pvs --units t --noheadings | grep -v '^return' | awk '{ print $0 " " $6 - $7 }'

