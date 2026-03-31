#!/bin/bash

OoO_User_A9812=`cat /mis_daily_check/tools/bin/copy_file/OoO_User_A9812.txt`

for u in ${OoO_User_A9812[@]}; do
	OoO_path="/home/$u/Move_to_OOO"
	[ -d $OoO_path ] && echo "$OoO_path exists" || echo "$OoO_path cat nnot exists"
done
