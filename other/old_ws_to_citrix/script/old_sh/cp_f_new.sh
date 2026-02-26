#!/bin/bash

file_List=`cat /backup_sh/List_new`
file_Logic3=`cat /backup_sh/List_Logic3`

if [ "$1" == "Logic2" ] ;then
	mount /dev/sdc1 /mnt/sdc1
	mount 192.168.1.9:/volume1/RD_HOME /backup_sh/snas2
	if mount | grep /mnt/sdc1 && mount | grep /backup_sh/snas2; then
		echo "/mnt/sdc1 && /backup_sh/snas2 is mounted"
	else
		echo "Could not access /mnt/sdc1 && /backup_sh/snas2 and Trying remount"
		mount /dev/sdc1 /mnt/sdc1
		mount 192.168.1.9:/volume1/RD_HOME /backup_sh/snas2
	fi
	for i in ${file_List[@]};do
		rsync -av /backup_sh/snas2/old_ws_Backup/$i /mnt/sdc1/Old_Project/Logic2 >> /backup_sh/log/$(date +%Y%m%d)_CP_Logic2.log
		echo "$i"
	done
	cp -r /mnt/sdc1/Old_home/mitch/Project/R1100 /mnt/sdc1/Old_Project/Logic2
	cp -r /mnt/sdc1/Old_home/mitch/Project/r186 /mnt/sdc1/Old_Project/Logic2
	cp -r /mnt/sdc1/Old_home/mitch/Project/R8822 /mnt/sdc1/Old_Project/Logic2
	echo -e "\e[33mCopy File Success!!\e[0m"
	umount -l /backup_sh/snas2
	umount -l /mnt/sdc1
else
	case ${1} in
		"Logic3")
			mount /dev/sdc1 /mnt/sdc1 && mount 192.168.1.9:/volume1/RD_HOME /backup_sh/snas2
			if mount | grep /mnt/sdc1 && mount | grep /backup_sh/snas2; then
				echo "/mnt/sdc1 && /backup_sh/snas2 is mounted"
			else
				echo "Could not access /mnt/sdc1 && /backup_sh/snas2 and Trying remount"
				mount /dev/sdc1 /mnt/sdc1
				mount 192.168.1.9:/volume1/RD_HOME /backup_sh/snas2
			fi
			for i in ${file_Logic3[@]};do
				rsync -av /backup_sh/snas2/old_ws_Backup/$i /mnt/sdc1/Old_Project1/Logic3 >> /backup_sh/log/$(date +%Y%m%d)_CP_Logic3.log
				echo "$i"
			done
			echo -e "\e[33mCopy File Success!!\e[0m"
			umount -l /backup_sh/snas2
			umount -l /mnt/sdc1
	esac
fi

