#!/bin/sh
echo "nameserver 8.8.8.8" > /etc/resolv.conf
if ! command -v nc.traditional >/dev/null 2>&1; then
  apt-get -o Acquire::Check-Valid-Until=false update && apt-get install -y --allow-unauthenticated iptables netcat-traditional
fi
NC_BIN=$(command -v nc.traditional || command -v nc)
pkill -f "nc.*-p 500[01]" 2>/dev/null || true
nohup "$NC_BIN" -l -k -p 5000 >/tmp/balthasar-5000.log 2>&1 </dev/null &
nohup "$NC_BIN" -l -k -p 5001 >/tmp/balthasar-5001.log 2>&1 </dev/null &
iptables -F; iptables -X; iptables -t nat -F; iptables -t nat -X
iptables -P INPUT ACCEPT; iptables -P FORWARD DROP; iptables -P OUTPUT ACCEPT
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
for ip in 10.94.4.66 10.94.4.74 10.94.4.75 10.94.4.76 10.94.4.77 10.94.4.78 10.94.4.50; do
  iptables -A INPUT -p tcp -s "$ip" -m multiport --dports 5000,5001 -j ACCEPT
done
iptables -A INPUT -p tcp -m multiport --dports 5000,5001 -j REJECT --reject-with tcp-reset