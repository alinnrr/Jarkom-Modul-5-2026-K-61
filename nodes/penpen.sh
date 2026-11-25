#!/bin/sh
# Jadwal dalam UTC (WIB - 7 jam)
PILOT_START="01:00"
PILOT_STOP="09:00"
PILOT_DAYS="Mon,Tue,Wed,Thu,Fri"
STAF_START="10:00"
STAF_STOP="16:00"

# Listener port 80
NC_BIN=$(command -v nc.traditional || command -v nc)
pkill -f "nc.*-p 80" 2>/dev/null || true
while true; do printf "Welcome to Pen-Pen\n" | "$NC_BIN" -l -p 80; done >/dev/null 2>&1 &

# Reset & kebijakan dasar firewall
iptables -F
iptables -X
iptables -P INPUT ACCEPT
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# Terduga Dummy System (Spy: 10.94.4.102) -> selalu ditolak
iptables -A INPUT -s 10.94.4.102 -p icmp --icmp-type echo-request -j DROP
iptables -A INPUT -s 10.94.4.102 -p tcp --dport 80 -j REJECT --reject-with tcp-reset

# Pilot (08.00-16.00 WIB = 01.00-09.00 UTC, Senin-Jumat)
for net in 10.94.4.72/29 10.94.3.128/26; do
  iptables -A INPUT -s "$net" -p icmp --icmp-type echo-request -m time --timestart "$PILOT_START" --timestop "$PILOT_STOP" --weekdays "$PILOT_DAYS" -j ACCEPT
  iptables -A INPUT -s "$net" -p tcp --dport 80 -m time --timestart "$PILOT_START" --timestop "$PILOT_STOP" --weekdays "$PILOT_DAYS" -j ACCEPT
  iptables -A INPUT -s "$net" -p icmp --icmp-type echo-request -j DROP
  iptables -A INPUT -s "$net" -p tcp --dport 80 -j REJECT --reject-with tcp-reset
done

# Staf Geofront (17.00-23.00 WIB = 10.00-16.00 UTC, setiap hari)
for net in 10.94.4.80/29 10.94.0.0/23 10.94.2.0/24 10.94.3.0/25 10.94.3.192/27 10.94.3.224/27 10.94.4.0/27 10.94.4.32/28 10.94.4.48/29 10.94.4.56/29 10.94.4.88/29; do
  iptables -A INPUT -s "$net" -p icmp --icmp-type echo-request -m time --timestart "$STAF_START" --timestop "$STAF_STOP" -j ACCEPT
  iptables -A INPUT -s "$net" -p tcp --dport 80 -m time --timestart "$STAF_START" --timestop "$STAF_STOP" -j ACCEPT
  iptables -A INPUT -s "$net" -p icmp --icmp-type echo-request -j DROP
  iptables -A INPUT -s "$net" -p tcp --dport 80 -j REJECT --reject-with tcp-reset
done