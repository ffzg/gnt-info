#!/bin/sh -xe
gnt-cluster command ipmitool sensor | egrep '(Vol|Amp|Wat)'

