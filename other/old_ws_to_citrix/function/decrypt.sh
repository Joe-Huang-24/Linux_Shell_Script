#!/bin/bash

nText=crypt
nnText=nc
cryptfile=`ls -l * | awk '{print $9}'`


for i in ${cryptfile[@]}; do
	if ls -l *.crypt; then
		fh=${i%.$nText}
		mv -f $i ${i%.$nText}.$nnText
		newf=$fn.$nnText
		mcrypt -V -d -a enigma --no-openpgp --keymode scrypt -k id0ntknow --bare ${i%.$nText}.$nnText
	else
		echo "None mcrypt nc file"
	fi
	./unpack_all.sh
done
