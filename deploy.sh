#!/bin/bash

reboot() {
	ssh unixadmin "killall -SIGINT supervisord; /home/sraierv/miniconda3/bin/supervisord"
}

upload() {
	rsync -r --progress _build unixadmin:
	rsync -r --progress supervisord.conf unixadmin:supervisord.conf
}



time upload
reboot

echo
echo "RAM disks uploaded and systems rebooted!"
