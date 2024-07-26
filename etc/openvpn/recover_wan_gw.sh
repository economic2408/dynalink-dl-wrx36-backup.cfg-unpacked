#!/bin/sh

. /usr/share/libubox/jshn.sh

prog=`basename $0`
# RTD-632
[ "`uci -q get network.wan.proto`" == "pppoe" ] && {
	wandev="pe-wan"
} || {
	wandev=`uci -q get network.wan.ifname`
}
type=
target=
mask=
nexthop=
source=
recovered=0

output=$(ubus call network.interface.wan status 2>/dev/null)
json_load "$output"
json_get_type type route
if [ "$type" = "array" ]; then
	json_select route
	i=1
    while true;
	do
		json_get_type type $i
		[ "$type" != "object" ] && break
		json_select $i
		json_get_var target target
		json_get_var mask mask
		json_get_var nexthop nexthop
		json_get_var source source

		if [ "$target" = "0.0.0.0" ]; then
			echo "$prog: recover default route under wan interface" >/dev/console
			source=`echo $source|sed 's/\/.*//'`
			ip ro add default dev $wandev via $nexthop src $source
			recovered=1
			break
		fi

		json_select ..
		i=`expr $i + 1`
	done
	[ $recovered -eq 0 ] && echo "$prog: no default route under wan interface" >/dev/console
else
	echo "$prog: no route under wan interface" >/dev/console
fi

