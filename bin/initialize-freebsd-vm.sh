#!/bin/sh

install() {
    cd /usr/ports/*/$1
    make clean
    make batch=yes install clean
}

# Install subversion first, then update the available ports
install subversion
cd /usr/ports
svn update

# Install things we want
install git
install nc
install vim
install zsh
install bash
install nmap
install nasm
install gdb
install llvm
install bzip
install binutils
install py-matplotlib


# Audit the ports for security issues
cd /usr/ports/*/portaudit
rehash
portaudit -Fda
