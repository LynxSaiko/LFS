#!/bin/bash
# download-lang.sh - Unduh source Python 2.7.18, Ruby 2.7.8, dan Ruby 3.3.0
# Author: Lynx
# Date: $(date +%F)

set -e

# Python 2.7.18
echo "[+] Downloading Python 2.7.18..."
wget -c https://www.python.org/ftp/python/2.7.18/Python-2.7.18.tar.xz

# Ruby 2.7.8
echo "[+] Downloading Ruby 2.7.8..."
wget -c https://cache.ruby-lang.org/pub/ruby/2.7/ruby-2.7.8.tar.gz

# Ruby 3.3.0
echo "[+] Downloading Ruby 3.3.0..."
wget -c https://cache.ruby-lang.org/pub/ruby/3.3/ruby-3.3.0.tar.gz

echo "[✔] Semua source berhasil diunduh ke /sources"
