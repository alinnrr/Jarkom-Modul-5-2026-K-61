#!/bin/sh
# IP Dummy-Plug (Switch-Lab) & batas laju ICMP echo-request
DUMMY_IP="10.94.4.51"
PING_LIMIT="5/second"
PING_BURST="5"

# Listener port 80 dan 8080 di Tokyo3-Core
NC_BIN=$(command -v nc.traditional || command -v nc)
pkill -f "nc.*-p 80" 2>/dev/null || true
pkill -f "nc.*-p 8080" 2>/dev/null || true
while true; do printf "Tokyo3-Core HTTP 80\n" | "$NC_BIN" -l -p 80; done >/dev/null 2>&1 &
while true; do printf "Tokyo3-Core HTTP 8080\n" | "$NC_BIN" -l -p 8080; done >/dev/null 2>&1 &

# Reset rantai INPUT & set kebijakan dasar
iptables -F INPUT
iptables -P INPUT ACCEPT
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# Loopback
iptables -A INPUT -i lo -j ACCEPT

# Nomor 15: rate-limit ICMP echo-request (maksimal 5/detik) lalu buang kelebihannya
iptables -A INPUT -p icmp --icmp-type echo-request -m limit --limit "$PING_LIMIT" --limit-burst "$PING_BURST" -j ACCEPT
iptables -A INPUT -p icmp --icmp-type echo-request -j DROP

# Balasan koneksi yang sudah ada / terkait
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# Nomor 16: catat prefix SCAN-NERV: lalu tolak TCP port 22, 23, 3306 dari Dummy-Plug
iptables -A INPUT -s "$DUMMY_IP" -p tcp -m multiport --dports 22,23,3306 --syn -j LOG --log-prefix "SCAN-NERV: "
iptables -A INPUT -s "$DUMMY_IP" -p tcp -m multiport --dports 22,23,3306 -j REJECT --reject-with tcp-reset