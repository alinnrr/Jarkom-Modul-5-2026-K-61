#!/bin/sh
ip addr flush dev eth0; ip addr add 10.94.4.114/30 dev eth0; ip link set eth0 up
ip addr flush dev eth1; ip addr add 10.94.4.89/29 dev eth1; ip link set eth1 up
ip addr flush dev eth2; ip addr add 10.94.4.145/30 dev eth2; ip link set eth2 up
sysctl -w net.ipv4.ip_forward=1
ip route replace default via 10.94.4.113
ip route replace 10.94.4.56/29 via 10.94.4.146
