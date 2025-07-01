#!/bin/bash
# install-lang.sh - Install Python 2.7.18, Ruby 2.7.8, and Ruby 3.3.0 to /usr (LFS Chroot)
# Author: ChatGPT - RedTeam Build Helper
# Date: $(date +%F)

set -e
cd /sources

######################################
# Python 2.7.18
######################################

echo "[+] Installing Python 2.7.18..."
tar -xf Python-2.7.18.tar.xz
cd Python-2.7.18

./configure --prefix=/usr              \
            --enable-shared            \
            --with-system-expat        \
            --with-system-ffi          \
            --enable-unicode=ucs4      \
            --with-ensurepip=yes

make -j$(nproc)
make install

# Symlink
ln -sfv /usr/bin/python2 /usr/bin/python2.7
ln -sfv /usr/bin/pip2    /usr/bin/pip2.7

cd /sources
rm -rf Python-2.7.18


######################################
# Ruby 2.7.8
######################################

echo "[+] Installing Ruby 2.7.8..."
tar -xf ruby-2.7.8.tar.gz
cd ruby-2.7.8

./configure --prefix=/usr \
            --program-suffix=2.7 \
            --disable-install-doc

make -j$(nproc)
make install

# Symlink
ln -sfv /usr/bin/ruby2.7 /usr/bin/ruby2
ln -sfv /usr/bin/gem2.7  /usr/bin/gem2
ln -sfv /usr/bin/irb2.7  /usr/bin/irb2

cd /sources
rm -rf ruby-2.7.8


######################################
# Ruby 3.3.0
######################################

echo "[+] Installing Ruby 3.3.0..."
tar -xf ruby-3.3.0.tar.gz
cd ruby-3.3.0

./configure --prefix=/usr \
            --program-suffix=3.3 \
            --disable-install-doc

make -j$(nproc)
make install

# Symlink
ln -sfv /usr/bin/ruby3.3 /usr/bin/ruby3
ln -sfv /usr/bin/gem3.3  /usr/bin/gem3
ln -sfv /usr/bin/irb3.3  /usr/bin/irb3

cd /sources
rm -rf ruby-3.3.0


######################################
# Selesai
######################################

echo "[✔] Python 2.7.18, Ruby 2.7.8, dan Ruby 3.3.0 berhasil diinstal ke /usr"
