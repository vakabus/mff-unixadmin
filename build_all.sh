#!/bin/bash

VMS="router dns_10.0.38.2 ns1 ns2 mx1 mx2 jump"

if test "$(id -u)" != "0"; then
	echo "Must be run as root"
	exit 1
fi

chown root:root _build
chmod 0700 _build

# build vms
for vm in $VMS; do
	last_mod_time_files=$(find $vm/ -exec stat -c %Y {} \; | sort -n | tail -n 1)
	last_mod_time_build=$(stat -c %Y _build/$vm-rootfs.cpio.gz 2>/dev/null || echo 0)
	
	if test "$last_mod_time_files" -le "$last_mod_time_build"; then
		echo "Skipping build of $vm"
	else
		echo "Building $vm"
		./build.sh "$vm"
	fi
done

chown vasek:vasek _build
chmod 0755 _build
