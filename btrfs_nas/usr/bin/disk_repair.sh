#!/bin/bash

mount -t btrfs -o ro,degraded /dev/vda /mnt/data

btrfs fi show

btrfs replace start <devid> /dev/vd<letter> /mnt/data

mount -t btrfs -o rw,remount /dev/vda /mnt/data
