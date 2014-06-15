#!/bin/bash

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
slow="(ftp|https?)://.*/(ubuntu|debian)"
fast="\1://mirrors.mit.edu/\2"
sudo mv -n /etc/apt/sources.list{,.original}
sudo cp    /etc/apt/sources.list{.original,}
sudo sed -i -E "s $slow $fast i" /etc/apt/sources.list


#
# Binaries and prerequisites
#
sudo apt-get -qq update
sudo apt-get -y -qq dist-upgrade

install() {
    sudo apt-get install -qq --yes $*
}
install ack-grep
install autoconf
install binutils
install build-essential
install clang-3.5 || install clang
install cmake
install curl
install dissy
install emacs
install expect{,-dev}
install fortune
install gcc-aarch64-linux-\* || true
install gcc-arm-linux-\* || true
install gdb
install git-core
install htop || true
install irssi
install libbz2-dev
install libc6-dev\*
install libexpat1-dev
install libgdbm-dev
install libgmp-dev
install liblzma-dev # binwalk
install libncurses5-dev
install libncursesw5-dev
install libpcap0.8{,-dev}
install libpng-dev
install libpq-dev
install libreadline6-dev
install libsqlite3-dev
install libssl-dev
install libtool
install libxml2
install libxml2-dev
install libxslt1-dev
install linux-headers-$(uname -r)
install llvm-3.5 || install llvm
install mercurial
install nasm
install nmap
install ntp
install openssh-blacklist
install openssh-blacklist-extra
install openssh-server
install patch
install qemu-system*  || true
install rar
install realpath
install silversearcher-ag || true
install socat
install ssh
install subversion
install tk-dev
install tmux
install tree
install uncrustify
install vim
install yodl
install zlib1g-dev
install zsh
install unzip

case "$(uname -m)" in
    i686)   ARCH="i386" ;;
    x86_64) ARCH="amd64" ;;
esac

# GUI install?
if dpkg -l xorg > /dev/null 2>&1; then
    sudo add-apt-repository ppa:ubuntu-wine/ppa -y
    sudo apt-get update -qq

    install compiz
    install compiz-plugins
    install compizconfig-settings-manager
    install dconf-tools
    install gnome-system-monitor
    install rescuetime
    # install eclipse # Don't install eclipse, since Ubuntu's is OLD
    sudo debconf-set-selections <<EOF
ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true
EOF
    install wine1.7 winetricks

    gsettings set org.gnome.desktop.wm.preferences theme 'Greybird'
    gsettings set org.gnome.desktop.wm.preferences titlebar-font 'Droid Sans 10'

    wget http://c758482.r82.cf2.rackcdn.com/sublime-text_build-3059_$ARCH.deb
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_$ARCH.deb

    rm -f *.deb
fi

wget http://www.capstone-engine.org/download/2.1.2/capstone-2.1.2_$ARCH.deb
sudo dpkg --install *.deb
rm -rf *.deb

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
[ -d .git ] && git submodule foreach 'rm -rf $(pwd)'
[ -d .git ] && rm -rf .git
git init
git remote add origin https://github.com/zachriggle/tools.git
git fetch -q --all
git checkout -f master
git reset -q --hard
git submodule update -f -q --init --recursive

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

#
# Install pwntools
#
cd ~/pwntools
git pull origin master
# sudo bash ./install.sh

#
# Set up metasploit
#
# case "$(uname -m)" in
#     "x86_64" ) metasploit_url="http://goo.gl/G9oxTe" ;;
#     "i686" )   metasploit_url="http://goo.gl/PwzxlC" ;;
# esac
# wget  -O ./metasploit-installer "$metasploit_url"
# chmod +x ./metasploit-installer
# sudo     ./metasploit-installer --mode unattended
# rm       ./metasploit-installer
# sudo     update-rc.d metasploit disable
# sudo     service metasploit stop
cd ~
wget https://github.com/rapid7/metasploit-framework/archive/release.zip
unzip release.zip
cd metasploit-framework-*
gem install bundler # metasploit has its own gemset
bundle install

#
# Set up binwalk
#
cd ~
git clone git://github.com/devttys0/binwalk.git
cd binwalk
./configure
make deps # dependencies
echo Y | make
sudo make install       # uses system python
python setup.py install # uses pyenv  python
cd ~
sudo rm -rf binwalk

#
# Use zsh
#
sudo chsh -s $(which zsh) $(whoami)

#
# Reboot
#
while true; do
    read -p "Reboot? [yn] " yn
    case $yn in
        [Yy]* ) sudo reboot; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

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
