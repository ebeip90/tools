#!/bin/sh

#
# Setup script for Ubuntu and Debian VMs.
# TinyURL: This script is available at:
# $ wget https://goo.gl/3e2B0
# $ bash 3e2B0
#

#
# Print commands as they're run, and fail on error.
#
set -ex

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
sudo bash -c "echo '$USER ALL=(ALL:ALL) NOPASSWD: ALL' >> /etc/sudoers.d/$USER"
fi

#
# Default mirrors are sloooooooow
#
# us.archive.ubuntu.com => Ubuntu DVD install
# archive.ubuntu.com    => DigitalOcean install
# ftp.us.debian.org     => Debian DVD install
#
ubuntu="(us.)?archive.ubuntu.com"
debian="ftp.(us.)?debian.org"
fast="ftp.ussg.indiana.edu\/linux"
sudo mv -n /etc/apt/sources.list{,.original}
sudo cp    /etc/apt/sources.list{.original,}
sudo sed -i -E "s/($ubuntu|$debian)/$fast/g" /etc/apt/sources.list


#
# Binaries and prerequisites
#
sudo apt-get -qq update
sudo apt-get -y -qq dist-upgrade

install() {
    sudo apt-get install -qq --yes $1
}
install ack-grep
install binutils
install build-essential
install curl
install dissy
install emacs
install fortune
install gdb
install git-core
install irssi
install libbz2-dev
install libexpat1-dev
install libgdbm-dev
install libgmp-dev
install libncurses5-dev
install libncursesw5-dev
install libpcap-dev
install libpng-dev
install libpq-dev
install libreadline6-dev
install libsqlite3-dev
install libssl-dev
install libxml2
install libxml2-dev
install libxslt1-dev
install linux-headers-$(uname -r)
install nasm
install openssh-blacklist
install openssh-blacklist-extra
install openssh-server
install patch
install qemu-system*  || true
install realpath
install screen
install silversearcher-ag
install ssh
install subversion
install tk-dev
install tree
install vim
install yodl
install zlib1g-dev
install zsh

sudo apt-get --yes --silent autoremove


#
# Configure SSH for pubkey only
#
sudo service ssh restart
sudo mv -n /etc/ssh/sshd_config{,.original}
sudo sh -c "cat > /etc/ssh/sshd_config <<EOF
Protocol                        2
Port                            22
PubkeyAuthentication            yes

UsePAM                          no
PermitRootLogin                 no
PasswordAuthentication          no
PermitEmptyPasswords            no
KerberosAuthentication          no
GSSAPIAuthentication            no
ChallengeResponseAuthentication no

Subsystem      sftp             /usr/lib/openssh/sftp-server
EOF"
sudo service ssh restart

#
# Put the IP address on the login screen
#
cat >issue <<EOF
if [[ "\$reason" == "BOUND" ]];
then
    rm /etc/issue
    lsb_release -ds       >> /etc/issue
    echo \$new_ip_address >> /etc/issue
    echo "\\n \\l"        >> /etc/issue
fi
EOF
sudo chown root.root issue
sudo mv    issue     /etc/dhcp/dhclient-enter-hooks.d

#
# Set up home directory repo
#
# This should set up pyenv and a bunch of other things
#
cd ~
git init
git remote add origin git://github.com/zachriggle/tools.git
git pull -q -f origin master
git reset -q --hard
git submodule update -q --init --recursive

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
git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
git clone git://github.com/jamis/rbenv-gemset.git     ~/.rbenv/plugins/rbenv-gemset
PATH="$PATH:$HOME/.rbenv/shims:$HOME/.rbenv/bin"
rbenv install        1.9.3-p484
rbenv gemset  create 1.9.3-p484 gems
rbenv rehash
gem install bundler
rbenv rehash

#
# Install pwntools
#
cd ~/pwntools
git pull origin master
sudo bash ./install.sh


#
# Set up metasploit
#
case "$(uname -m)" in
    "x86_64" ) metasploit_url="http://goo.gl/G9oxTe" ;;
    "i686" )   metasploit_url="http://goo.gl/PwzxlC" ;;
esac
wget  -O ./metasploit-installer "$metasploit_url"
chmod +x ./metasploit-installer
sudo     ./metasploit-installer --mode unattended
rm       ./metasploit-installer
sudo     update-rc.d metasploit disable

#
# Set up binwalk
#
cd ~
git clone git://github.com/devttys0/binwalk.git
cd binwalk/src
sudo bash ./easy_install.sh

#
# Use zsh
#
sudo chsh -s $(which zsh) $(whoami)

#
# Reboot
#
sudo reboot

# #
# # Fix hostname so that it looks like...
# #
# #    ubuntu-12.10-quantal-i686
# #
# distro="$(lsb_release -si)"
# codename="$(lsb_release -sc)"
# version="$(lsb_release -sr)"
# arch="$(uname -m)"
# hostname="$distro-$version-$codename-$arch"
# hostname=${hostname,,}
# hostname="$(echo $hostname | sed 's|\.|-|')"
# sudo bash -c "echo $hostname > /etc/hostname"
