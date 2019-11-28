#!/bin/bash

if test ! -e /dev/vda; then
	echo "There is no disk to install the system on..."
	exit 1
fi

mkfs.ext4 /dev/vda
mount /dev/vda /mnt

cd -a -x / /mnt

systemctl switch-root /mnt
