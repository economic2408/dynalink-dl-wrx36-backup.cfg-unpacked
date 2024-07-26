#!/bin/sh

iface=`uci -q get network.vpn_client.ifname`
use_defaultroute=`uci -q get network.vpn_client.defaultroute`
netmask=`route -n | grep "^0.0.0.0" | grep "$iface" | awk '{print $3}'`
gw=`route -n | grep "^0.0.0.0" | grep "$iface" | awk '{print $2}'`

if [ "${use_defaultroute:-1}" -eq 0 ]; then
	[ -z "$iface" -o -z "$netmask" -o -z "$gw" ] && exit 0
	/sbin/route del -net 0.0.0.0 netmask $netmask gw $gw dev $iface
fi
	
