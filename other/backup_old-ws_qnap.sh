#!/bin/bash
#mount 192.168.1.9:/volume1/RD_HOME /snas2
#sleep 10m
rsync -avh /sun/Project1 /qnap/old_ws_Backup
rsync -avh /sun/Project /qnap/old_ws_Backup
rsync -avh /sun/CAD /qnap/old_ws_Backup
rsync -avh /sun/CAD.h /qnap/old_ws_Backup
rsync -avh /sun/PRLib /qnap/old_ws_Backup
sleep 10m
#umount -l /sun/*
#umount -l /BM1AD-1
find /var/log/backup_log/ -type f -name "*.log" -mtime +7 -exec rm -rf {} \;
# echo "Backup is Finish!!"
echo "Backup Finished at $(date +%Y-%m-%d) !!"
