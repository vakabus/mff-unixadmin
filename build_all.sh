#!/bin/bash

if test "$(id -u)" != "0"; then
	echo "Must be run as root"
	exit 1
fi

rm -rf _build/
./build.sh router
./build.sh dns_10.0.38.2
