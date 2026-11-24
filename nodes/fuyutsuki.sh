#!/bin/sh
ip addr flush dev eth0; ip addr add 10.94.4.110/30 dev eth0; ip link set eth0 up
ip addr flush dev eth1; ip addr add 10.94.4.65/29 dev eth1; ip link set eth1 up
ip addr flush dev eth2; ip addr add 10.94.4.137/30 dev eth2; ip link set eth2 up
ip addr flush dev eth3; ip addr add 10.94.4.141/30 dev eth3; ip link set eth3 up
sysctl -w net.ipv4.ip_forward=1
ip route replace default via 10.94.4.109
ip route replace 10.94.3.192/27 via 10.94.4.138
ip route replace 10.94.4.80/29 via 10.94.4.142
