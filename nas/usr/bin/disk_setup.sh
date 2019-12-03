#!/bin/bash

mdadm --create --verbose --level=6 --metadata=1.2 --raid-devices=10 /dev/md/raid /dev/vd*
cryptsetup -v luksFormat /dev/md/raid
cryptsetup open /dev/md/raid data
pvcreate /dev/mapper/data
vgcreate vgroup /dev/mapper/data

lvcreate -L 1G -n data_volume_1 vgroup
mkfs.ext4 /dev/vgroup/data_volume_1
lvcreate -L 1G -n data_volume_2 vgroup
mkfs.ext4 /dev/vgroup/data_volume_2
lvcreate -L 1G -n data_volume_3 vgroup
mkfs.ext4 /dev/vgroup/data_volume_3

echo 1 > /sys/block/(whatever)/device/delete

