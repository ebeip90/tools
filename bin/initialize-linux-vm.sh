#!/bin/sh

#
# Setup script for Ubuntu and Debian VMs.
# TinyURL: This script is available at curl -L http://goo.gl/3e2B0 | bash
#

# 
# Default mirrors are sloooooooow
#
sudo sed -i.backup 's/us.archive.ubuntu.com/mirror.anl.gov/g' /etc/apt/sources.list

#
# Binaries and prerequisites
#
sudo apt-get -qq update
sudo apt-get -y -qq dist-upgrade

while read -r package;
do sudo apt-get install -qq --yes $package
done << EOF
ack-grep
binutils
build-essential
curl
dissy
emacs
fortune
git-core
libbz2-dev
libexpat1-dev
libgdb-dev
libgdbm-dev
libgmp-dev
libncurses5-dev
libncursesw5-dev
libpcap-dev
libpng-dev
libpq-dev
libreadline6-dev
libsqlite3-dev
libssl-dev
libxml2
libxml2-dev
libxslt1-dev
linux-headers-$(uname -r)
nasm
open-vm-tools
openssh-blacklist
openssh-blacklist-extra
openssh-server
patch
qemu-system-arm
realpath
shellnoob
silversearcher-ag
ssh
subversion
tk-dev
tree
vim
yodl
zlib1g-dev
zsh
EOF
sudo apt-get --yes --silent autoremove


#
# Configure SSH
#
sudo sh -c "cat >> /etc/ssh/sshd_config <<EOF
UsePAM no
PubkeyAuthentication yes
PermitRootLogin no
PasswordAuthentication no
EOF"
sudo service ssh restart

#
# Put the IP address on the login screen
#
sudo sh -c "cat >/etc/network/if-up.d/issue <<EOF
rm /etc/issue
lsb_release -ds >> /etc/issue
ifconfig eth0 \
    | grep 'inet addr' \
    | grep -v '127.0.0.1'  \
    | awk '{ print \$2 }' \
    | awk -F: '{ print \"ip address \" \$2 }' \
    >> /etc/issue
echo '\\\\n \\l' >> /etc/issue
EOF"
sudo chmod 755 /etc/network/if-up.d/issue


#
# Set up home directory repo
#
# This should set up pyenv and a bunch of other things
#
cd ~
git init
git remote add origin https://github.com/zachriggle/tools.git
git pull --quiet -f origin master
git reset --hard
git submodule --quiet update --init --recursive

#
# Force pyenv for this script
#
PYENV_ROOT="$HOME/.pyenv"
PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

#
# Install a local version of Python.
#
pyenv install 2.7.6
pyenv local 2.7.6


#
# Python things
#
pip install ipython
pip install numpy
pip install matplotlib
pip install gmpy
pip install sympy
pip install pygments

#
# Ruby things
#
git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
PATH="$PATH:$HOME/.rbenv/shims:$HOME/.rbenv/bin"
rbenv install ruby-1.9.3-p484
gem install bundler


#
# Install pwntools
#
cd ~/pwntools
sudo ./install.sh


#
# Set up metasploit
#
cd ~
git clone https://github.com/rapid7/metasploit-framework.git
cd metasploit-framework
git checkout release
gem install bundler
bundle install

#
# Set up binwalk
#
cd ~
git clone https://github.com/devttys0/binwalk.git
cd binwalk
sudo src/easy_install.sh
rm -rf /tmp/binwalk

#
# Use zsh
#
sudo chsh -s $(which zsh) $user
