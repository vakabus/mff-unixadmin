#!/bin/bash

cd /mnt/data/.snapshot

if test -z "$1";
    echo "No target host specified"
    exit 1
fi

i=0
for f in $(ls | sort -nr); do 
    echo "btrfs send $f | ssh $1 'btrfs receive'"
    i=$((i+1))
    if test "$i" -gt 10; then
        break
    fi
done
