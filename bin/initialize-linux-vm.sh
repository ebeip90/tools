#!/bin/sh

#
# Setup script for Ubuntu and Debian VMs.
# TinyURL: This script is available at curl -L http://goo.gl/3e2B0 | bash
#

#
# Binaries and prerequisites
#
sudo apt-get update
sudo apt-get -y dist-upgrade

while read -r package;
do sudo apt-get install -qq --yes $package
done << EOF
binutils
build-essential
patch
curl
emacs
git-core
libbz2-dev
libexpat1-dev
libgdb-dev
libgdbm-dev
libncurses5-dev
libncursesw5-dev
libreadline6-dev
libsqlite3-dev
libssl-dev
libxml2
libxml2-dev
libxslt1-dev
nasm
tk-dev
vim
yodl
zlib1g-dev
zsh
libpq-dev
libgmp-dev
libpng-dev
qemu-system-arm
ssh
libpcap-dev
subversion
ack-grep
realpath
tree
open-vm-tools
linux-headers-$(uname -r)
openssh-server
openssh-blacklist
openssh-blacklist-extra
shellnoob
dissy
fortune
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

#
# Set up home directory repo
#
# This should set up pyenv and a bunch of other things
#
cd ~
git init
git remote add origin https://github.com/zachriggle/tools.git
git pull -f origin master
git reset --hard
git submodule update --init --recursive

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
rbenv install ruby-1.9.3-p429
gem install bundler


#
# Install pwntools
#
cd ~/pwntools
sudo ./install.sh


#
# Set up metasploit
#
cd ~/metasploit-framework
gem install bundler
bundle install

#
# Set up binwalk
#
pushd 
cd /tmp
git clone https://github.com/devttys0/binwalk.git
cd binwalk/src
sudo bash easy_install.sh
popd

#
# Use zsh
#
chsh -s $(which zsh) $user
