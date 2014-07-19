#!/bin/bash
set -ex

# Turn off ptrace and most procfs stuff
cat > /etc/rc.local <<EOF
mount -o remount,hidepid=2 /proc
echo 3 > /proc/sys/kernel/yama/ptrace_scope
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

# Disable world-write permissions for *everything*
chmod -R o-w /

