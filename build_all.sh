#!/bin/bash

VMS="router dns_10.0.38.2 ns1 ns2 mx1"

if test "$(id -u)" != "0"; then
	echo "Must be run as root"
	exit 1
fi

#rm -rf _build/

# build vms
for vm in $VMS; do
	last_mod_time_files=$(find $vm/ -type f -exec stat -c %Y {} \; | sort -n | tail -n 1)
	last_mod_time_build=$(stat -c %Y _build/$vm-rootfs.cpio.gz 2>/dev/null || echo 0)
	
	if test "$last_mod_time_files" -le "$last_mod_time_build"; then
		echo "Skipping build of $vm"
	else
		echo "Building $vm"
		./build.sh "$vm"
	fi
done
