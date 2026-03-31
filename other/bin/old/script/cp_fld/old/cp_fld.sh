#!/bin/bash

if [ -d /HD6501/Old_home ]; then
	if mount /dev/sdc1 /mnt/sdc1;then
		for i in `ls -al /mnt/sdc1/Old_home/ | grep -i 'spiker\|mitch\|albertcheng\|ricky\|jason' | awk -F ' ' '{print $9}'`;do
#			echo "$i"
	        	rsync -avh /mnt/sdc1/Old_home/$i /HD6501/Old_home >> /backup_sh/cp_fld/log/$(date +%Y%m%d)_user_CP.log
		done
	        echo -e "CP Folder Success!!" >> /backup_sh/cp_fld/log/$(date +%Y%m%d)_user_CP.log
	else
		echo "Con not exist HD6501/Old_home" >> /backup_sh/cp_fld/log/$(date +%Y%m%d)_user_CP.log
	fi
else
	echo "/HD6501/Old_home could not access"
fi
