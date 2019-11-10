#!/bin/bash

VMS="router dns_10.0.38.2 ns1 ns2"

if test "$(id -u)" != "0"; then
	echo "Must be run as root"
	exit 1
fi

rm -rf _build/

# build vms
for vm in $VMS; do
	./build.sh "$vm"
done
