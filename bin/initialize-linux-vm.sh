#!/bin/sh

#
# Setup script for Ubuntu and Debian VMs.
#

#
# TinyURL: This script is available at http://goo.gl/3e2B0
#
#
# Binaries and prerequisites
#
sudo apt-get update
sudo apt-get dist-upgrade
sudo apt-get -y install \
    'binutils' \
    'build-essential' \
    'patch' \
    'curl' \
    'emacs' \
    'git-core' \
    'libbz2-dev' \
    'libbz2-dev' \
    'libexpat1-dev' \
    'libgdb-*' \
    'libgdbm-dev' \
    'libgdbm-dev' \
    'libncursesw5-dev' \
    'libreadline6-*' \
    'libsqlite3-dev' \
    'libssl-dev' \
    'libssl-dev' \
    'libxml2' \
    'libxml2-dev' \
    'libxslt1-dev' \
    'nasm' \
    'tk-dev' \
    'vim' \
    'yodl' \
    'zlib1g-dev' \
    'zlib1g-dev' \
    'zsh' \
    libncurses5{,-dev} \
    libgmp-dev \
    libpng-dev \
    qemu \
    ssh \
    libpcap-dev \
    subversion \
    ack-grep \
    realpath \
    tree \
    linux-headers-$(uname -r) || (echo Failed && exit)
#
# Pythonbrew and its prereqs
#
curl -kL https://raw.github.com/utahta/pythonbrew/master/pythonbrew-install | bash
source ~/.pythonbrew/etc/bashrc
pythonbrew install 2.7.3
pythonbrew switch  2.7.3
pythonbrew venv init 

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

echo '[[ -s "$HOME/.pythonbrew/etc/bashrc" ]] && source "$HOME/.pythonbrew/etc/bashrc"' >> ~/.profile
echo 'pythonbrew switch 2.7.3' >> ~/.profile


#
# Ruby things
#
curl -L https://get.rvm.io | bash
rvm install ruby-1.9.3-p429
gem install bundler

#
# Set up home directory repo
#
cd ~
git init
git remote add origin https://github.com/zachriggle/tools.git
git pull origin master
git submodule update --init --recursive

#
# Install pwntools
#
cd ~/pwntools
sudo ./install.sh


#
# Metasploit requirements --> RVM
# 
curl -L https://get.rvm.io | bash



#
# Set up metasploit
#
cd ~/metasploit-framework
gem install bundler
bundle install

#
# Use zsh
#
chsh -s $(which zsh) $user
