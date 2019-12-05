#!/bin/bash

reboot() {
	ssh unixadmin "killall -SIGINT supervisord; /home/sraierv/miniconda3/bin/supervisord"
}

shutdown() {
	ssh unixadmin "killall -SIGINT supervisord; rm -r vde*"
}

boot() {
	ssh unixadmin "/home/sraierv/miniconda3/bin/supervisord"
}

recreate_disks() {
	images="$(find _build -name  "*.cpio.gz" | sed 's#_build/##;s/-.*//' | tr '\n' ' ')"
	ssh unixadmin <<EOL
rm -rf _disks
mkdir -p _disks
cd _disks
for img in $images; do
	qemu-img create \$img 16G
done
EOL
}

recreate_data_disks() {
	ssh unixadmin <<EOL
rm -rf _data_disks
mkdir -p _data_disks
cd _data_disks
for i in \$(seq 0 9); do
	qemu-img create \$i.img 1G
done
EOL
}

upload() {
	rsync -r --progress _build unixadmin:
	rsync -r --progress supervisord.conf unixadmin:supervisord.conf
}




time upload
shutdown
recreate_disks
recreate_data_disks
boot

echo
echo "RAM disks uploaded and systems rebooted!"
