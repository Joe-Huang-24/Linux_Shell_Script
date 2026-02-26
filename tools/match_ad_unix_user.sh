#!/bin/bash

#user_list=(
#	"OoO-00"
#	"OoO-04"
#	"OoO-07"
#	"OoO-08"
#	"OoO-15"
#	"OoO-16"
#	"OoO-17"
#	"OoO-31"
#	"OoO-32"
#	"OoO-33"
#	"OoO-34"
#	"OoO-42"
#	"OoO-44"
#	"OoO-45"
#	"OoO-46"
#	"OoO-48"
#	"OoO-49"
#	"OoO-52"
#	"OoO-53"
#)

user_list=(
        "A9812-70"
	"A9812-71"
	"A9812-72"
	"A9812-73"
	"A9812-74"
	"A9812-75"
)

#LOGFILE="/var/log/xdl/citrix_service_restart.log"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}


for u in ${user_list[@]}; do
	yp_id=`id $u | awk '{print $1}'`
	yp_gid=`id $u | awk '{print $2}'`
	ad_id=`getent passwd $u@srd.rdc.com.tw | awk -F ':' '{print $3}'`
	ad_gid=`getent passwd $u@srd.rdc.com.tw | awk -F ':' '{print $4}'`
	log "Get User Name $u Information"
	log "Linux UID:    $yp_id"
	log "Linux GID:    $yp_gid"
	log "AD_Linux UID: $ad_id"
	log "AD_Linux GID: $ad_gid"
done
