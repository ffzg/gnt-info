#!/bin/sh -xe

cp smart-query.sh /tmp/smart-query.sh
gnt-cluster copyfile /tmp/smart-query.sh
gnt-cluster command /tmp/smart-query.sh $*
