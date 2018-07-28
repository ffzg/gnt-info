#!/bin/sh -xe

rbd ls | grep '^backup' | while read image ; do
	parent=`rbd info $image | tee /dev/shm/rbd.info.$image | grep parent: | cut -d: -f2`
	rbd unmap $image
	rbd rm    $image
	rbd snap unprotect $parent
	rbd snap rm        $parent
done

