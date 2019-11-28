#!/bin/bash

if echo "$PWD" | grep "_tools" >/dev/null; then
    cd "$(echo "$PWD" | sed 's/_tools$//g')"
fi

vm=$1
if test -z "$vm"; then
	echo "Name of the server was not provided!"
	exit 1
fi

# actual installation:
if test ! -e "$vm/usr/bin/migrate_to_disk.sh"; then
    echo "DISK Migrator not found! Installing..."
    mkdir -p "$vm/usr/bin"
    mkdir -p "$vm/etc/systemd/system/multi-user.target.wants"
    cp _tools/migrate_to_disk.sh $vm/usr/bin/migrate_to_disk.sh
    chmod +x $vm/usr/bin/migrate_to_disk.sh
    cp _tools/disk_installer.service $vm/etc/systemd/system/
    ln -s /etc/systemd/system/disk_installer.service $vm/etc/systemd/system/multi-user.target.wants/disk_installer.service
fi
