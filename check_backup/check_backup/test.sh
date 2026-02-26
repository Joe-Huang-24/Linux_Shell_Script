#!/bin/bash

SCRIPT_DIR=$(dirname "${BASH_SOURCE[0]}")
USER_LIST_SCRIPT=`/mis_daily_check/check_backup/show_userlist | awk '{print $3}'`

for i in ${USER_LIST_SCRIPT[@]}; do
	getent passwd $i
done
