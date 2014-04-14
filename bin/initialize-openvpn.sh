#!/bin/bash
if [ $UID != 0 ];
then
    echo Run as root
else
    # Install and configure OpenVPN
    apt-get install openvpn easy-rsa

    cd /etc/openvpn
    cp -r /usr/share/easy-rsa .
    cd easy-rsa

    # Generate keys
    source vars
    ./clean-all
    ./build-ca         --batch
    ./build-dh         --batch
    KEY_NAME="server" ./build-key-server --batch server
    KEY_NAME="client" ./build-key --batch client

    # Install keys
    cd /etc/openvpn
    cp easy-rsa/keys/{server.crt,server.key,ca.crt,dh1024.pem} .
    gzip -d > server.conf < /usr/share/doc/openvpn/examples/sample-config-files/server.conf.gz
    echo push redirect-gateway def1 bypass-dhcp >> server.conf

    # Start the service
    service openvpn restart

    # Check on tun0
    ifconfig tun0
fi

