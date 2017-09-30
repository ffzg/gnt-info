#!/bin/sh -xe
gnt-cluster command -M ipmitool sensor | egrep '(Vol|Amp|Wat)'

