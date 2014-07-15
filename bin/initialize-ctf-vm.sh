#!/bin/bash
set -ex

cat > /etc/rc.local <<EOF
mount -o remount,hidepid=2 /proc
EOF
source /etc/rc.local

cat > /etc/sysctl.d/10-ptrace.conf <<EOF
kernel.yama.ptrace_scope = 3
EOF
sysctl -p /etc/sysctl.d/10-ptrace.conf

cd /home
for dir in $(ls);
do
    chown -R root.$dir $dir
    chmod -R o-rwx     $dir
    chmod -R g-w       $dir
done
chmod o-rwx /tmp
