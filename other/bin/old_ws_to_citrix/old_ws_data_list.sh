#!/bin/bash

add_projs=(
        "65LLDDR3"
        "A9123"
        "A9160"
        "A9510"
        "A951X"
        "C6033"
        "C6036"
        "R3308"
        "R3600"
        "A9110"
        "A9133"
        "A9500"
        "A9511"
        "A9610"
        "C6035"
        "R3306"
        "R3500"
        "R3600_MP"
)


dest_path="/mnt/sdb1"
old_data="old_data"

for i in ${add_projs[@]}; do
	[ -d "$dest_path/old_add/$i" ] && echo "[MSG] - PATH $dest_path/old_add/$i is defined" || echo "[ERROR] - PATH $dest_path/old_add/$i not defined"
done
