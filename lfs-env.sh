#!/bin/bash
# [+] LFS Environment Reset (User lfs)
# [+] Author: LynxSaiko

# Set environment dasar
export LFS=/mnt/lfs
export LC_ALL=POSIX
export LFS_TGT=$(uname -m)-lfs-linux-gnu
export PATH=$LFS/tools/bin:/bin:/usr/bin

# Hapus variabel build yang bisa menyebabkan kontaminasi
unset CC CXX LD AR AS RANLIB READELF STRIP

# Info status
clear
echo "[✓] LFS Environment Aktif & Bersih"
echo "LFS       = $LFS"
echo "LFS_TGT   = $LFS_TGT"
echo "PATH      = $PATH"
echo
echo "✅ Variabel build (CC, LD, dll) telah dibersihkan."
