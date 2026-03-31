#!/bin/bash

#OoO_User_A9812=`cat /mis_daily_check/tools/bin/copy_file/OoO_User_A9812.txt`
#OoO_User=`cat /mis_daily_check/tools/bin/copy_file/OoO_User.txt`
user_number=`cat /mis_daily_check/tools/bin/copy_file/user_number.txt`

#for a in ${OoO_User_A9812[@]}; do
#	for o in ${OoO_User[@]}; do
#		OoO_path="/home/$a/Move_to_OOO"
#		OoO_home_path="/home/$o"
#		[ -d $OoO_path ] && rsync -avh $OoO_path $OoO_home_path/. || log "$OoO_path cat nnot exists"
#	done
#done

LOGFILE="/var/log/backup_log/$(date +%Y%m%d)_sync_Move_to_OOO.log"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOGFILE"
}

log_Y() {
    echo -e "\033[33m$(date '+%Y-%m-%d %H:%M:%S') - $1\033[0m" | tee -a "$LOGFILE"
}

log_G() {
    echo -e "\033[32m$(date '+%Y-%m-%d %H:%M:%S') - $1\033[0m" | tee -a "$LOGFILE"
}

[ -d /home/DPU-04/Move_to_OOO ] && log "/home/DPU-04/Move_to_OOO exist" || log "/home/DPU-04/Move_to_OOO dose not exist"
[ -d /home/OoO-04/Move_to_OOO ] && log "/home/OoO-04/Move_to_OOO exist" || log "/home/OoO-04/Move_to_OOO dose not exist"
log_Y "Starting Sync /home/DPU-04/Move_to_OOO to /home/OoO-04"
[ -d /home/DPU-04/Move_to_OOO ] && rsync -avh /home/DPU-04/Move_to_OOO /home/OoO-04/. && chown -R OoO-04:OoO /home/OoO-04/Move_to_OOO
log_G "Checking /home/OoO-04/Move_to_OOO Permission"
[ -d /home/OoO-04/Move_to_OOO ] && ls -ld /home/OoO-04/Move_to_OOO

for n in ${user_number[@]}; do
	OoO_user_home="/home/OoO-$n"
	A9812_user_home="/home/A9812-$n"
	[ -d $A9812_user_home/Move_to_OOO ] && log "$A9812_user_home/Move_to_OOO exist" || log "$A9812_user_home/Move_to_OOO dose not exist"
	[ -d $OoO_user_home/Move_to_OOO ] && log "$OoO_user_home/Move_to_OOO exist" || log "$OoO_user_home/Move_to_OOO dose not exist"
	log_Y "Starting Sync $A9812_user_home/Move_to_OOO to $OoO_user_home"
	[ -d $A9812_user_home/Move_to_OOO ] && rsync -avh $A9812_user_home/Move_to_OOO  $OoO_user_home/. && chown -R OoO-$n:OoO $OoO_user_home/Move_to_OOO
	log_G "Check $OoO_user_home/Move_to_OOO Permission"
	[ -d $OoO_user_home/Move_to_OOO ] && ls -ld $OoO_user_home/Move_to_OOO
done
log_G "Delete /var/log/backup/ old log"
find /var/log/backup_log/ -name "*.log" -mtime +1 -exec rm -fr {} \;
log "Sync /home/A9812-xx/Move_to_OOO to /home/OoO-xx Finished."
