#!/bin/bash
set -ex

cat > /etc/rc.local <<EOF
mount -o remount,hidepid=2 /proc
echo 3 > /proc/sys/kernel/yama/ptrace_scope
exit
EOF
bash /etc/rc.local

cd /home
for dir in $(ls);
do
    chown -R root.$dir $dir
    chmod -R o-rwx     $dir
    chmod -R g-w       $dir
done

for dir in $(find / -type d \( -perm -o+w \) 2>/dev/null);
do
    chmod o-w $dir
done
