#!/bin/sh
ip addr flush dev eth0; ip addr add 10.94.4.162/30 dev eth0; ip link set eth0 up
ip addr flush dev eth1; ip addr add 10.94.4.33/28 dev eth1; ip link set eth1 up
sysctl -w net.ipv4.ip_forward=1
ip route replace default via 10.94.4.161
