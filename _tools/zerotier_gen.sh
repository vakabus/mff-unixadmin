#!/bin/bash

if echo "$PWD" | grep "_tools" >/dev/null; then
    cd "$(echo "$PWD" | sed 's/_tools$//g')"
fi

vm=$1
if test -z "$vm"; then
	echo "Name of the server was not provided!"
	exit 1
fi

# zerotier config
if test ! -d "$vm/var/lib/zerotier-one"; then
    echo "zerotier id not found! Generating new and patching configuration directories!"
    mkdir -p "$vm/var/lib/zerotier-one"
    mkdir -p "$vm/etc/systemd/system/multi-user.target.wants"
    zerotier-idtool generate "$vm/var/lib/zerotier-one/identity.secret" "$vm/var/lib/zerotier-one/identity.public"
    ln -s /usr/lib/systemd/system/zerotier-one.service $vm/etc/systemd/system/multi-user.target.wants/
    cp _tools/zerotier_join.service $vm/etc/systemd/system/
    ln -s /etc/systemd/system/zerotier_join.service $vm/etc/systemd/system/multi-user.target.wants/zerotier_join.service
fi
