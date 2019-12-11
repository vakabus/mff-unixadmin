#!/bin/bash

# format
mkfs.btrfs -f -d raid5 -m raid1 /dev/vd*

mkdir /mnt/data

mount -o autodefrag,compress=lzo /dev/vda /mnt/data

# copy some data to the volume
cp -a -x / /mnt/data
