#!/bin/sh
# Available at: http://goo.gl/24idVT


#
# Print commands as they're run, and fail on error.
#
set -ex

install() {
    pkg install $*
}

src_install() {
    cd /usr/ports/*/$1
    shift
    sudo make -DBATCH batch=yes install clean $*
}

# Set up ports and sudo
portsnap fetch
portsnap extract

src_install pkg
install sudo


# Set things up as root
USER=user
useradd
echo '$USER ALL=(ALL:ALL) NOPASSWD: ALL' || tee /usr/local/etc/sudoers.d/$USER


#
# Don't run as root
#
if [ $UID -eq 0 ] ; then
    cat <<EOF
Run as a regular user with sudo access
# useradd -m user -p password
# echo "user ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers.d/user
EOF
    exit
fi

if [ ! -f /etc/sudoers.d/$USER ]; then
echo "$USER ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers.d/$USE
Rtfwdi

cat <<EOF > /etc/rc.conf
sshd_enable="YES"
ifconfig_em0="DHCP"
hostname=$(uname -n)_$(uname -m)
EOF

# Install things we want
install compat6x-i386
install git
install nc
install vim
install zsh
install bash
install nmap
install nasm
install autoconf
install cmake
install clang34
isntall gcc49
install tree
install bzip
install binutils
install the_silver_searcher
install vim
install p7zip
install readline
src_install gdb WITH="PYTHON"


# Audit the ports for security issues
cd /usr/ports/*/portaudit
rehash
portaudit -Fda

# Set up git
cd ~
git init
git remote add https://github.com/zachriggle/tools.git
git pull
git checkout -f master
git submodule update --init --recursive


#
# Force pyenv for this script
#
PYENV_ROOT="$HOME/.pyenv"
PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

#
# Install python
#
pyenv install 2.7.6
pyenv local 2.7.6

pip_install() {
    pip install --allow-all-external --allow-unverified $* $*
}
pip_install pygments
pip_install pexpect
pip_install hg+http://hg.secdev.org/scapy || true # scapy is down
pip_install tldr
pip_install httpie

# N.B. All of the following are required by pwntools
pip_install ipython
pip_install numpy
pip_install matplotlib
pip_install gmpy
pip_install sympy
pip_install requests
pip_install pycrypto
pip_install argparse
pip_install paramiko


#
# Ruby things
#
git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
git clone git://github.com/jamis/rbenv-gemset.git     ~/.rbenv/plugins/rbenv-gemset
PATH="$PATH:$HOME/.rbenv/shims:$HOME/.rbenv/bin"
rbenv install        1.9.3-p484
rbenv gemset  create 1.9.3-p484 gems
rbenv rehash

gem install bundler
gem install gist

rbenv rehash
