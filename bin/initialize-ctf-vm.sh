#!/bin/bash
set -ex

# Turn off ptrace and most procfs stuff
cat > /etc/rc.local <<EOF
mount -o remount,hidepid=2 /proc
echo 3 > /proc/sys/kernel/yama/ptrace_scope
chmod 700 /proc
exit
EOF
bash /etc/rc.local

# All home directories should be owned by root:$user,
# and should only be readable by that user.
cd /home
for dir in $(ls);
do
    chown -R root.$dir $dir
    chmod -R o-rwx     $dir
    chmod -R g-w       $dir
done

# Disable world-write permissions for *everything* except /tmp
# chmod -R o-w /
# chmod o+rwx  /tmp

# Nothing setuid outside of /home
for file in $(find /  ! -path /home -type f -perm +6000 2>/dev/null);
do
    chmod o-rwx $file
done

# Drop all outbound connections except root, and already-established connections
iptables -F OUTPUT
iptables -A OUTPUT -m owner --uid-owner root    -j ACCEPT
iptables -A OUTPUT -m state --state ESTABLISHED -j ACCEPT
iptables -A OUTPUT -j REJECT
