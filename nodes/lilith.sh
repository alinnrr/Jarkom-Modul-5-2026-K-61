#!/bin/sh
ip link set eth0 up
ip route replace default via 10.94.4.81 dev eth0