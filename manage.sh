#!/bin/bash

reboot() {
	ssh unixadmin "killall -SIGINT supervisord; /home/sraierv/miniconda3/bin/supervisord"
}

upload() {
	scp -r _build unixadmin:_build
	scp supervisord.conf unixadmin:supervisord.conf
}



upload
reboot
