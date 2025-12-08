#!/bin/bash
set -xeuo pipefail
# https://access.redhat.com/solutions/7013886
firewall-cmd --new-policy out --permanent
firewall-cmd --set-target REJECT --policy out --permanent
firewall-cmd --policy out --add-egress-zone ANY --permanent
firewall-cmd --policy out --add-ingress-zone HOST --permanent
# allow non-recursive outgoing DNS connection
firewall-cmd --policy=out \
       	--add-rich-rule='rule family="ipv4" destination address="192.168.122.1" service name="dns" accept' --permanent
# if you are running DHCPv4 client you should allow also this rule for Renewal (non-broadcast IP):
firewall-cmd --policy=out \
       	--add-rich-rule='rule family="ipv4" destination address="192.168.122.1" service name="dhcp" accept' --permanent
# IPv6 output
firewall-cmd --policy=out \
	--add-rich-rule='rule family="ipv6" destination address="ff02::/64" icmp-type name="mld2-listener-report" accept' --permanent
firewall-cmd --policy=out \
	--add-rich-rule='rule family="ipv6" destination address="ff02::/64" icmp-type name="router-solicitation" accept' --permanent
firewall-cmd --policy=out \
	--add-rich-rule='rule family="ipv6" destination address="ff02::/64" icmp-type name="neighbour-solicitation" accept' --permanent

# beware - this will apply pending changes
firewall-cmd --reload
firewall-cmd --info-policy=out
exit 0
