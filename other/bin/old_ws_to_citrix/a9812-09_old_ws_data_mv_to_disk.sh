#!/bin/bash

add_projs=("65LLDDR3" "A9133" "A9510" "A951X" "R3600" "A9123" "A9160" "A9511" "R3500")

# old workstation data source
source_path="/mnt/sdb1"
old_data="old_data"

# old ws copy data to citrix path
dest_path='/home/A9812-09/old_ws/Project/ADD'

for i in ${add_projs[@]}; do
	[ -d "$dest_path/$i" ] && echo "[MSG] - $dest_path/$i is defined" || echo "[ERROR] - PATH $dest_path/$i not defined" ; exit 0
	[ ! -d "$source_path/$old_data" ] && mkdir $source_path/$old_data/$(date +%m%d)
	[ -d "$source_path/$old_data/$(date +%m%d)" ] && mv $dest_path/$i $source_path/$old_data/$(date +%m%d)
	[ -d "$source_path/$old_data/$i" ] && echo "[MSG] - $source_path/$old_data/$(date +%m%d)/$i is defined - $dest_path/$i move to $source_path/$old_data/$(date +%m%d) Success!"
	echo
done
