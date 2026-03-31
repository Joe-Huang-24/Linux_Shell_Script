#!/bin/bash

srv_lst=(
	"SR650-1"
        "SR650-2"
        "SR650-3"
        "SR650-4"
        "SR650-5"
        "SR650-6"
        "SR665-1"
        "P920-1"
        "P920-2"
        "P920-3"
)

for h in ${srv_lst[@]}; do
#	ping -c 1 $h
	ssh $h || echo "ssh refused!"
done
