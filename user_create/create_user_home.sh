#!/bin/bash

user_name=(
	"OoO-04"
	"OoO-08"
	"OoO-15"
	"OoO-16"
	"OoO-17"
	"OoO-31"
	"OoO-32"
	"OoO-33"
	"OoO-34"
#	"OoO-42"
#	"OoO-44"
#	"OoO-45"
#	"OoO-46"
#	"OoO-48"
#	"OoO-49"
#	"OoO-52"
#	"OoO-53"
)

file_path="/OHD6651/home"

for u in ${user_name[@]}; do
        if getent passwd $u; then
                echo "[MSG] - User $u is Defined"
                echo -e "Session -1: Create User home: $u"
                mkdir $file_path/$u
                sleep 1
                echo -e "Session -2: Config ACL"
                setfacl -R -m o::--- $file_path/$u
                sleep 1
                echo -e "Set User Permission"
                setfacl -R -m m:rwx $file_path/$u
                sleep 1
                setfacl -R -m u:$u:rwx $file_path/$u
                sleep 1
                setfacl -R -m d:u:$u:rwx $file_path/$u
                sleep 1
                echo -e "END"

        else
                echo "[MSG] - User $u is not Defined"
        fi
done

echo -e "\nexport path"
exportfs -arv
sleep 5
echo -e "\nRestart NFS Server Service"
systemctl restart nfs-server
echo "Script END"
