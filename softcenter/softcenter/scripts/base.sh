#!/bin/sh

export KSROOT=/koolshare
export PERP_BASE=$KSROOT/perp
export PATH=$KSROOT/bin:$KSROOT/scripts:$PATH

alias echo_date='echo °æ$(TZ=UTC-8 date -R +%YƒÍ%m‘¬%d»’\ %X)°ø:'

ACTION=$1
ID=$1
export LANIP=127.0.0.1

_LOG(){
	# for debug
	# echo [$(date)]-$1 | tee -a /data/ks_softcenter_log.txt
	logger $1
}

http_response()  {
    ARG0="$@"
    curl -X POST -d "$ARG0" http://$LANIP/_resp/$ID
}
