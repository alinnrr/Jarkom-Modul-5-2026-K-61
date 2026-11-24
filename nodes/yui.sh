#!/bin/sh
ip addr flush dev eth0; ip addr add 10.94.4.134/30 dev eth0; ip link set eth0 up
ip addr flush dev eth1; ip addr add 10.94.3.1/25 dev eth1; ip link set eth1 up
ip addr flush dev eth2; ip addr add 10.94.4.161/30 dev eth2; ip link set eth2 up
ip addr flush dev eth3; ip addr add 10.94.4.165/30 dev eth3; ip link set eth3 up
ip addr flush dev eth4; ip addr add 10.94.4.169/30 dev eth4; ip link set eth4 up
sysctl -w net.ipv4.ip_forward=1
ip route replace default via 10.94.4.133
ip route replace 10.94.4.32/28 via 10.94.4.162
ip route replace 10.94.0.0/23 via 10.94.4.166
ip route replace 10.94.4.0/27 via 10.94.4.170
