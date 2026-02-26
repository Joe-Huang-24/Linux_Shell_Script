#!/bin/bash

# chk_f_list=$(ls -al /backup_sh/snas2/old_ws_Backup/home | grep -i 'spiker\|mitch\|albertcheng\|ricky\|jason')

# mount 192.168.1.9:/volume1/RD_HOME /backup_sh/snas2
if mount /dev/sdc1 /mnt/sdc1 ; then
	if mount 192.168.1.9:/volume1/RD_HOME /backup_sh/snas2; then
		for i in `ls -al /backup_sh/snas2/old_ws_Backup/home | grep -i 'spiker\|mitch\|albertcheng\|ricky\|jason' | awk -F ' ' '{print $9}'`;do
			rsync -av /backup_sh/snas2/old_ws_Backup/home/$i /mnt/sdc1/Old_home >> /backup_sh/log/$(date +%Y%m%d)_CP.log
#			echo "/backup_sh/snas2/old_ws_Backup/home/$i /mnt/sdc1/Old_home"
		done
		echo "Copy File Successed" >> /backup_sh/log/$(date +%Y%m%d)_CP.log
		umount -l /backup_sh/snas2
	else
		echo "Copy File Failed"
	fi
	umount -l /mnt/sdc1
else
	echo "/dev/sdc1 Could not access"
fi
