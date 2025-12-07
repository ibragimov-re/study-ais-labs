#!/bin/bash

# LAB 4 (PACKET FILTERING)
# ====================================

# Exit immediately if a command exits with a non-zero status (error)
set -e

# Define interface eth0 IP address
ETH0_IP="172.10.0.10"


# Flush existing rules
iptables -F # Flush all rules in the filter table
iptables -t nat -F # Flush all rules in the nat table
iptables -X # Delete all user-defined chains


# Allow already established and related connections
#   -A INPUT: Append rule to INPUT chain
#   -m state --state ESTABLISHED,RELATED: Match packets that are part of established connections or related to them
#   -j ACCEPT: Jump to ACCEPT target to allow the packets
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT


# Allow all loopback (lo) traffic for internal communications using localhost
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT


# ====================================
# Setup eth0 (public_net) rules (for TCP and UDP)
# ====================================

# Allow incoming TCP traffic on port 80 (HTTP) on eth0
#  -I INPUT: Insert rule at the top of INPUT chain
#  -i eth0: Match packets coming in on interface eth0
#  -p tcp --dport 80: Match protocol TCP with destination port 80
iptables -I INPUT -i eth0 -p tcp --dport 80 -j ACCEPT

# Allow incoming UDP traffic on port 53 (DNS) on eth0
iptables -I INPUT -i eth0 -p udp --dport 53 -j ACCEPT

# Default policy: DROP all other incoming traffic on eth0
#  -A INPUT: Append rule at the end of INPUT chain
#  -j DROP: Jump to DROP target to block the packets
iptables -A INPUT -i eth0 -j DROP # Default policy to DROP all incoming traffic on eth0


# ====================================
# Setup eth1 (private_net) rules (for SSH)
# ====================================

# Allow incoming TCP traffic on port 22 on eth1
# 22 is the standard port for SSH
iptables -A INPUT -i eth1 -p tcp --dport 22 -j ACCEPT


# ====================================
# Setup redirection UDP port 10000 to 20000
# ====================================

# Redirect incoming UDP traffic on port 10000 to port 20000 on eth1
#  -t nat: Specify the nat table for network address translation
#  -A PREROUTING: Append rule to PREROUTING chain
#  -j DNAT --to-destination :20000: Jump to DNAT (Destination Network Address Translation) target to change destination port to 20000
iptables -t nat -A PREROUTING -i eth1 -p udp --dport 10000 -j DNAT --to-destination $ETH0_IP:20000

# Allow forwarding of the redirected packets from eth1 to eth0 on port 20000
#  -i eth1: Match packets coming in on interface eth1
#  -o eth0: Match packets going out on interface eth0
iptables -A FORWARD -i eth1 -o eth0 -p udp --dport 20000 -j ACCEPT


echo "[OK] iptables configuration completed"