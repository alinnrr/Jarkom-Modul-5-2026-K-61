#!/bin/sh
IF_GENDO="eth0"
SUBNET_TERMINAL="10.94.4.64/29"
ARMISAEL_IP="10.94.4.91"

# Konfigurasi IP interface & routing Shigeru
ip addr flush dev eth0; ip addr add 10.94.4.114/30 dev eth0; ip link set eth0 up
ip addr flush dev eth1; ip addr add 10.94.4.89/29 dev eth1; ip link set eth1 up
ip addr flush dev eth2; ip addr add 10.94.4.145/30 dev eth2; ip link set eth2 up

sysctl -w net.ipv4.ip_forward=1 >/dev/null

ip route replace default via 10.94.4.113
ip route replace 10.94.4.56/29 via 10.94.4.146

# Isolasi Armisael (10.94.4.91) di rantai INPUT Shigeru
iptables -D INPUT -s "$ARMISAEL_IP" -j DROP 2>/dev/null || true
iptables -I INPUT 1 -s "$ARMISAEL_IP" -j DROP

# Aturan FORWARD zona Monolith & Radar + isolasi Armisael
iptables -F FORWARD
iptables -P FORWARD ACCEPT
iptables -A FORWARD -s "$ARMISAEL_IP" -j DROP
iptables -A FORWARD -d "$ARMISAEL_IP" -j DROP
iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -i "$IF_GENDO" -s "$SUBNET_TERMINAL" -p icmp --icmp-type echo-request -j ACCEPT
iptables -A FORWARD -i "$IF_GENDO" -j DROP