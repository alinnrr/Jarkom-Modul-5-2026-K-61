#!/bin/sh
# --- SOAL 2: Konfigurasi IP Interface & Forwarding ---
ip addr flush dev eth1; ip addr add 10.94.4.105/30 dev eth1; ip link set eth1 up
ip addr flush dev eth2; ip addr add 10.94.4.133/30 dev eth2; ip link set eth2 up
ip addr flush dev eth3; ip addr add 10.94.4.129/30 dev eth3; ip link set eth3 up
ip addr flush dev eth4; ip addr add 10.94.4.125/30 dev eth4; ip link set eth4 up
ip addr flush dev eth5; ip addr add 10.94.4.121/30 dev eth5; ip link set eth5 up
ip addr flush dev eth6; ip addr add 10.94.4.117/30 dev eth6; ip link set eth6 up
ip addr flush dev eth7; ip addr add 10.94.4.113/30 dev eth7; ip link set eth7 up
ip addr flush dev eth8; ip addr add 10.94.4.109/30 dev eth8; ip link set eth8 up

# DHCP dari NAT1
udhcpc -i eth0 -n -q 2>/dev/null || dhclient eth0 2>/dev/null || true

# Aktifkan IP Forwarding
sysctl -w net.ipv4.ip_forward=1

# --- SOAL 3: Static Routing & CIDR Summarization ---
# Cabang Yui
ip route replace 10.94.0.0/23 via 10.94.4.134
ip route replace 10.94.3.0/25 via 10.94.4.134
ip route replace 10.94.4.0/27 via 10.94.4.134
ip route replace 10.94.4.32/28 via 10.94.4.134
ip route replace 10.94.4.160/30 via 10.94.4.134
ip route replace 10.94.4.164/30 via 10.94.4.134
ip route replace 10.94.4.168/30 via 10.94.4.134

# Cabang Hikari
ip route replace 10.94.2.0/24 via 10.94.4.130
ip route replace 10.94.3.224/27 via 10.94.4.130
ip route replace 10.94.4.156/30 via 10.94.4.130

# Cabang Asuka
ip route replace 10.94.3.128/26 via 10.94.4.126
ip route replace 10.94.4.48/29 via 10.94.4.126
ip route replace 10.94.4.96/30 via 10.94.4.126
ip route replace 10.94.4.148/30 via 10.94.4.126
ip route replace 10.94.4.152/30 via 10.94.4.126

# Cabang Kaji
ip route replace 10.94.4.100/30 via 10.94.4.122

# Cabang Misato
ip route replace 10.94.4.72/29 via 10.94.4.118

# Cabang Shigeru
ip route replace 10.94.4.56/29 via 10.94.4.114
ip route replace 10.94.4.88/29 via 10.94.4.114
ip route replace 10.94.4.144/30 via 10.94.4.114

# Cabang Fuyutsuki (Summarization link .136/30 + .140/30 = 10.94.4.136/29)
ip route replace 10.94.3.192/27 via 10.94.4.110
ip route replace 10.94.4.64/29 via 10.94.4.110
ip route replace 10.94.4.80/29 via 10.94.4.110
ip route replace 10.94.4.136/29 via 10.94.4.110

# --- SOAL 4 & 5: NAT Masquerade & Firewall Gendo ---
iptables -F
iptables -t nat -F
iptables -X

iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# Loopback & DHCP dari NAT1
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -i eth0 -p udp --sport 67 --dport 68 -j ACCEPT

# (a) Balasan koneksi yang sudah ada
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# (d) Traffic dari internal menuju Gendo sendiri
iptables -A INPUT -s 10.94.0.0/21 -j ACCEPT

# (b) Traffic dari internal ke Internet (NAT1)
iptables -A FORWARD -s 10.94.0.0/21 -o eth0 -j ACCEPT

# (c) Traffic antar-LAN internal
iptables -A FORWARD -s 10.94.0.0/21 -d 10.94.0.0/21 -j ACCEPT

# NAT Masquerade hanya untuk prefix internal keluar lewat eth0
iptables -t nat -A POSTROUTING -s 10.94.0.0/21 -o eth0 -j MASQUERADE
