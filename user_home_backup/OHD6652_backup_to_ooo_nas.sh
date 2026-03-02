#!/bin/bash


#mount 172.16.11.214:/volume1/OoO_Backup /OoO_NAS

LOGFILE="/var/log/backup_log/Daily_backup.log"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOGFILE"
}

log_END() {
    echo -e "$(date '+%Y-%m-%d %H:%M:%S') - $1\n\n" | tee -a "$LOGFILE"
}

OoO_User=`ls -l /OHD6652/home | grep 'OoO' | awk '{print $9}'`

log "=== Backup OoO User Home Start ==="
log "=== Sleep 10s ==="
sleep 10
log "Run Script --- Backup Running ..."
if grep -qs /OoO_NAS /proc/mounts; then
        for u in ${OoO_User[@]}; do
#               ls -ld /OHD6652/home/$u
                rsync -avh --include-from=/CAD/bin/backup.include --exclude-from=/CAD/bin/backup.exclude /OHD6652/home/$u /OoO_NAS/Citrix_Backup/home/.
        done
        log "Remove old backup log file."
        find /var/log/backup_log/ -type f -name "*.log" -mtime +5 -exec rm -rf {} \;
        log "=== Sleep 10s ==="
        sleep 10
#   umount -l /snas
        log "Backup Finish!!"
else
        log "Backup Fail!!"
        exit $?
fi
log "Running Script END --- Backup Finished."
log_END "====== DONE ======"
