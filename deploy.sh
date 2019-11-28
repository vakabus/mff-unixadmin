#!/bin/bash

reboot() {
	ssh unixadmin "killall -SIGINT supervisord; /home/sraierv/miniconda3/bin/supervisord"
}

shutdown() {
	ssh unixadmin "killall -SIGINT supervisord"
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
	qemu-img create \$img 8G
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
boot

echo
echo "RAM disks uploaded and systems rebooted!"
