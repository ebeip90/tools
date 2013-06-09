#!/bin/sh

#
# Binaries and prerequisites
#
sudo apt-get install \
    'binutils' \
    'build-essential' \
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
    'libsqlite3-dev' 
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
    linux-headers-$(uname -r) \

#
# Pythonbrew and its prereqs
#
curl -kL https://raw.github.com/utahta/pythonbrew/master/pythonbrew-install | bash
source ~/.pythonbrew/etc/bashrc
pythonbrew install 2.7.3
pythonbrew switch  2.7.3
pythonbrew venv init 

# Python things
pip install ipython

echo '[[ -s "$HOME/.pythonbrew/etc/bashrc" ]] && source "$HOME/.pythonbrew/etc/bashrc"' >> ~/.profile
echo 'pythonbrew switch 2.7.3' >> ~/.profile


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
sudo pwntools/install.sh

#
# Use zsh
#
chsh -s $(which zsh) $user
