lsb_release  -ds    > /etc/issue
uname        -a     >> /etc/issue
IP=$(/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')
echo "eth0 IP: $IP" >> /etc/issue
