#!/bin/bash

# assemble the array
mdadm --detail --scan | sed 's/INACTIVE-//' >> /etc/mdadm.conf
mdadm --assemble --scan

# print out information about the array
cat /proc/mdstat

# try to add all disks, if some is not part of the array, it will get added and replace something missing
mdadm --add /dev/md127 /dev/vda
mdadm --add /dev/md127 /dev/vdb
mdadm --add /dev/md127 /dev/vdc
mdadm --add /dev/md127 /dev/vdd
mdadm --add /dev/md127 /dev/vde
mdadm --add /dev/md127 /dev/vdf
mdadm --add /dev/md127 /dev/vdg
mdadm --add /dev/md127 /dev/vdh
mdadm --add /dev/md127 /dev/vdi
mdadm --add /dev/md127 /dev/vdj

# print out the information again
echo "waiting 20 sec for possible recovery"
sleep 20
cat /proc/mdstat

# decrypt data
echo "heslo" | cryptsetup open /dev/md/raid data

# mount
mkdir -p /mnt/data_volume_1
mkdir -p /mnt/data_volume_2
mkdir -p /mnt/data_volume_3

mount /dev/vgroup/data_volume_1 /mnt/data_volume_1
mount /dev/vgroup/data_volume_2 /mnt/data_volume_2
mount /dev/vgroup/data_volume_3 /mnt/data_volume_3
