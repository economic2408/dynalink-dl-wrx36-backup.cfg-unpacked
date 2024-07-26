#!/bin/sh
cp /tmp/resolv.conf.auto /tmp/resolv.conf.auto.hold
cp /tmp/resolv.conf /tmp/resolv.conf.hold
conffile=/tmp/resolv.conf
resolvfile=/tmp/resolv.conf.auto

for optionname in `set | grep "^foreign_option_" | sed "s/^\(.*\)=.*$/\1/g"`
do
        option=`eval "echo \\$$optionname"`
        if echo $option | grep "dhcp-option WINS "; then echo $option | sed "s/ WINS /=44,/" >> $conffile; fi
        if echo $option | grep "dhcp-option DNS"; then echo $option | sed "s/dhcp-option DNS/nameserver/" >> $resolvfile; fi
        if echo $option | grep "dhcp-option DOMAIN"; then echo $option | sed "s/dhcp-option DOMAIN/search/" >> $conffile; fi
done
#echo $foreign_option_1 | sed -e 's/dhcp-option DOMAIN/domain/g' -e 's/dhcp-option DNS/nameserver/g' > /tmp/resolv.conf.auto
#echo $foreign_option_2 | sed -e 's/dhcp-option DOMAIN/domain/g' -e 's/dhcp-option DNS/nameserver/g' >> /tmp/resolv.conf.auto
#echo $foreign_option_3 | sed -e 's/dhcp-option DOMAIN/domain/g' -e 's/dhcp-option DNS/nameserver/g' >> /tmp/resolv.conf.auto
