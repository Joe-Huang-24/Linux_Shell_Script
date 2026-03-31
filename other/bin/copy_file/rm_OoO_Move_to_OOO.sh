#!/bin/bash

OoO_User=`cat /mis_daily_check/tools/bin/copy_file/OoO_User.txt`

for u in ${OoO_User[@]}; do
	OoO_path="/home/$u/Move_to_OOO"
#	[ -d $OoO_path ] && echo rm -fr $OoO_path || echo "$OoO_path cat nnot exists"
	[ -d $OoO_path ] && rm -fr $OoO_path || echo "$OoO_path cat nnot exists"
done
