#!/bin/sh
source /koolshare/scripts/base.sh

case $2 in
1)
	sync
	echo 1 > /proc/sys/vm/drop_caches
	http_response "$1"
	;;
esac
