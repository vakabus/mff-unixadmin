#!/bin/bash

snapper -c data_config create-config /mnt/data
systemctl enable --now snapper-timeline.timer 
systemctl enable --now snapper-cleanup.timer

snapper -c data_config list
