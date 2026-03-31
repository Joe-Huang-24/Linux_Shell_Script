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

# old workstation data source
source_path="/mnt/sdb1"
old_data="old_data"

# old ws copy data to citrix path
dest_path='/home/A9812-09/old_ws/Project/ADD'

for i in ${add_projs[@]}; do
	[ -d "$dest_path/$i" ] && echo "[MSG] - $dest_path/$i is defined" || echo "[ERROR] - PATH $dest_path/$i not defined"
	#ls -ld $dest_path/$i
	echo
done
