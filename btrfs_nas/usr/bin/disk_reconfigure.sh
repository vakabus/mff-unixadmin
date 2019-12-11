#!/bin/bash

btrfs balance start -dconvert=raid10 -mconvert=dup /mnt/data
