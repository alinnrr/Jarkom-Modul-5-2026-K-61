#!/bin/sh
echo "nameserver 8.8.8.8" > /etc/resolv.conf
date -s "2026-11-24 04:00:00" >/dev/null 2>&1 || true

if ! dpkg -s iptables netcat-traditional >/dev/null 2>&1; then
    apt-get -o Acquire::Check-Valid-Until=false update && apt-get install -y --allow-unauthenticated iptables netcat-traditional
fi

pkill -f "nc.traditional.*5000" 2>/dev/null || true
nohup nc.traditional -l -k -p 5000 > /tmp/casper.log 2>&1 &

iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X

iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# 1. Izinkan loopback
iptables -A INPUT -i lo -j ACCEPT

# 2. Izinkan balasan koneksi yang diinisiasi Casper (balasan ping, DNS, dan apt-get)
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# 3. Tolak ping masuk (ICMP echo-request)
iptables -A INPUT -p icmp --icmp-type echo-request -j DROP

# 4. Izinkan koneksi masuk ke layanan TCP 5000
iptables -A INPUT -p tcp --dport 5000 -j ACCEPT