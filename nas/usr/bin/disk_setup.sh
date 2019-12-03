#!/bin/bash

# setup raid
mdadm --create --verbose --level=6 --metadata=1.2 --raid-devices=10 /dev/md/raid /dev/vd*

# setup LUKS
echo "heslo" | cryptsetup -v luksFormat /dev/md/raid
echo "heslo" | cryptsetup open /dev/md/raid data

# setup LVM
pvcreate /dev/mapper/data
vgcreate vgroup /dev/mapper/data
lvcreate -L 1G -n data_volume_1 vgroup
mkfs.ext4 /dev/vgroup/data_volume_1
lvcreate -L 1G -n data_volume_2 vgroup
mkfs.ext4 /dev/vgroup/data_volume_2
lvcreate -L 1G -n data_volume_3 vgroup
mkfs.ext4 /dev/vgroup/data_volume_3

# mount
mkdir /mnt/data_volume_1
mkdir /mnt/data_volume_2
mkdir /mnt/data_volume_3

mount /dev/vgroup/data_volume_1 /mnt/data_volume_1
mount /dev/vgroup/data_volume_2 /mnt/data_volume_2
mount /dev/vgroup/data_volume_3 /mnt/data_volume_3

# copy some data to the volumes
cp -a -x / /mnt/data_volume_1
cp -a -x / /mnt/data_volume_2
cp -a -x / /mnt/data_volume_3
