#!/bin/bash

if test ! -e /dev/vda; then
	echo "There is no disk to install the system on..."
	exit 1
fi

if mount | grep "/dev/vda" >/dev/null; then
	echo "Already running on disk"
	exit 0
fi

mkfs.ext4 -F /dev/vda
mount /dev/vda /mnt

cp -a -x / /mnt

systemctl switch-root /mnt /init
