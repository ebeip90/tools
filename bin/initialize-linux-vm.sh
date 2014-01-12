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
do sudo apt-get install -qy $(sh -c "echo $package; exit")
done << EOF
binutils
build-essential
patch
curl
emacs
git-core
libbz2-*
libexpat1-*
libgdb-*
libgdbm-*
libncurses*
libreadline6-*
libsqlite3-dev
libssl-*
libxml2-*
libxslt1-dev
nasm
tk-dev
vim
yodl
zlib1g*
zsh
libpq-dev
libncurses5-*
libgmp*
libpng*
qemu-system-arm
ssh
libpcap*
subversion
ack-grep
realpath
tree
open-vm-tools
linux-headers-*
EOF


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
# Most of these are prerequisites for pwntools.
# For whatever reason, they don't all install if you put them on the same line.
#
pip install ipython
pip install numpy
pip install matplotlib
pip install gmpy
pip install sympy
pip install pygments

# echo '[[ -s "$HOME/.pythonbrew/etc/bashrc" ]] && source "$HOME/.pythonbrew/etc/bashrc"' >> ~/.profile
# echo 'pythonbrew switch 2.7.3' >> ~/.profile


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
