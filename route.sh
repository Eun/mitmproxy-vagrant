#!/usr/bin/env bash
set -euo pipefail

# Fix DNS issues
echo "nameserver 8.8.8.8" > /etc/resolv.conf

# Allow ip forwarding
echo "Updating system settings"
sysctl -w net.ipv4.ip_forward=1
sysctl -w net.ipv6.conf.all.forwarding=1
sysctl -w net.ipv4.conf.all.send_redirects=0
ulimit -f unlimited
ulimit -t unlimited
ulimit -v unlimited
ulimit -l unlimited
ulimit -n 64000
ulimit -m unlimited
ulimit -u 64000

# Remove default gateway and setup the correct gateway for eth1
ip route del default
dhclient -v eth1

# Flush everything
echo "Flusing old rules"
iptables -t nat -F
ip6tables -t nat -F

echo "Installing new rules"
iptables -t nat -A PREROUTING -i eth1 -p tcp --dport 80 -j REDIRECT --to-port 8080
iptables -t nat -A PREROUTING -i eth1 -p tcp --dport 443 -j REDIRECT --to-port 8080
ip6tables -t nat -A PREROUTING -i eth1 -p tcp --dport 80 -j REDIRECT --to-port 8080
ip6tables -t nat -A PREROUTING -i eth1 -p tcp --dport 443 -j REDIRECT --to-port 8080


output=$(
python - <<EOF
import socket
import fcntl
import struct

def get_ip_address(ifname):
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    return socket.inet_ntoa(fcntl.ioctl(
        s.fileno(),
        0x8915,  # SIOCGIFADDR
        struct.pack('256s', ifname[:15])
    )[20:24])

print(get_ip_address('eth1'))
EOF
)

echo "hardstatus alwayslastline" > /root/.screenrc
echo "hardstatus string 'mitmproxy @ $output%=%c:%s'" >> /root/.screenrc

screen -dmS mitmproxy mitmproxy --mode transparent --showhost


echo -e "\033[0mSet your gateway to \e[7m\`$output'\033[0m"                                                                 | tee /etc/motd
echo -e "\033[0m\033[2m    examples: \e[7m\`ip route add default via $output'\033[0m"                                       | tee -a /etc/motd
echo -e "\033[0m\033[2m              \e[7m\`route add default gw $output'\033[0m"                                           | tee -a /etc/motd
echo -e "\033[0m\n"                                                                                                         | tee -a /etc/motd
echo -e "\033[0mRun \e[7m\`vagrant ssh'\033[0m and \e[7m\`sudo screen -rr'\033[0m to attach to mitmproxy."                  | tee -a /etc/motd
echo -e "\033[0m\n"                                                                                                         | tee -a /etc/motd
echo -e "\033[0m\033[2mmitmproxy was started using \e[7m\`mitmproxy --mode transparent --showhost'\033[0m\033[2m.\033[0m"   | tee -a /etc/motd
echo -e "\033[0m\033[2mTo install the certificate visit \e[7m\`mitm.it'\033[0m\033[2m in your browser.\033[0m"              | tee -a /etc/motd

