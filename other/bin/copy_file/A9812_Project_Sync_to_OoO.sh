#!/bin/bash

LOGFILE="/var/log/backup_log/$(date +%Y%m%d)_sync_A9812_PRJ_to_OOO.log"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOGFILE"
}

log_Y() {
    echo -e "\033[33m$(date '+%Y-%m-%d %H:%M:%S') - $1\033[0m" | tee -a "$LOGFILE"
}

log_G() {
    echo -e "\033[32m$(date '+%Y-%m-%d %H:%M:%S') - $1\033[0m" | tee -a "$LOGFILE"
}

prj_raid=(
	"/Project1/R623600"
	"/Project1/M2011"
	"/Project1/A9860"
	"/Project1/A9812"
	"/Project1/R3500"
)

dest="/OoO_Project"

ls -ld $dest

for p in ${prj_raid[@]}; do
	ls -ld $p
	log_Y "Starting Sync $p to $dest"
	rsync -avh $p $dest/.
done
log_G "Delete /var/log/backup/ old log"
find /var/log/backup_log/ -name "*.log" -mtime +1 -exec rm -fr {} \;
log_G "Sync Project Process Finished."
