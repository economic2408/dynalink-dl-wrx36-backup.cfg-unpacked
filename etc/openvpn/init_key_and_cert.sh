#!/bin/sh
EASY_RSA_KEY_DIR=/etc/easy-rsa/keys
OVPN_SER_DIR=/etc/openvpn/server

init=0

if [ "$1" = "force" ]; then
	init=1
else
	if [ ! -d ${OVPN_SER_DIR} ]; then
		init=1
	fi
fi

if [ $init -eq 0 ]; then
	# PURTDA-351
	# AK9 Casper, add for reset to default case
	if [ ! -f ${OVPN_SER_DIR}/static.key ]; then
		openvpn --genkey --secret ${OVPN_SER_DIR}/static.key
	fi

	exit 0
fi

clean-all
pkitool --initca
pkitool --server server
pkitool client
build-dh
openvpn --genkey --secret /etc/easy-rsa/keys/static.key

rm -rf ${OVPN_SER_DIR}
mkdir -p ${OVPN_SER_DIR}

cp ${EASY_RSA_KEY_DIR}/ca.* ${EASY_RSA_KEY_DIR}/server.* ${EASY_RSA_KEY_DIR}/client.* ${OVPN_SER_DIR}/
cp ${EASY_RSA_KEY_DIR}/dh*.pem ${OVPN_SER_DIR}/dh.pem
cp ${EASY_RSA_KEY_DIR}/static.key ${OVPN_SER_DIR}/

if [ "$1" = "force" ]; then
	/etc/init.d/openvpn restart
fi

