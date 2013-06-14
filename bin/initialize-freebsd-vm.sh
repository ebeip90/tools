#!/bin/sh

cd /usr/ports/*/subversion
make clean
make batch=yes install clean

cd /usr/ports
svn update

cd /usr/ports/*/git
make clean
make batch=yes install clean

cd /usr/ports/*/nc
make clean
make batch=yes install clean

cd /usr/ports/*/vim
make clean
make batch=yes install clean

cd /usr/ports/*/zsh
make clean
make batch=yes install clean

cd /usr/ports/*/nmap
make clean
make batch=yes install clean

cd /usr/ports/*/nasm
make clean
make batch=yes install clean

cd /usr/ports/*/gdb
make clean
make batch=yes install clean

cd /usr/ports/*/llvm
make clean
make batch=yes install clean

cd /usr/ports/*/bzip
make clean
make batch=yes install clean



cd /usr/ports/*/portaudit

rehash

portaudit -Fda
