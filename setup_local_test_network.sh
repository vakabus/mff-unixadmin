#!/bin/bash

modprobe bridge
modprobe tun
vde_switch -tap vde-backbone -daemon -mod 777 -group users -sock /tmp/vde-backbone.sock
ip a add 10.0.0.1/24 dev vde-backbone
ip link set up vde-backbone
ip route add 10.0.0.0/16 via 10.0.0.38

