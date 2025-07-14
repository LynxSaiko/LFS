#!/bin/bash

# Periksa apakah script dijalankan dengan hak akses root
if [ "$(id -u)" -ne 0 ]; then
    echo "Harus dijalankan sebagai root!"
    exit 1
fi

# Tentukan disk yang akan dipartisi, ganti /dev/sda sesuai dengan disk Anda
DISK="/dev/sda"

# Tentukan partisi LFS
PARTITION_LFS="/dev/sda2"

# 1. Jalankan cfdisk untuk mempartisi disk
echo "Memulai cfdisk untuk mempartisi disk $DISK"
sudo cfdisk $DISK

# 2. Format Partisi LFS dengan ext4
echo "Memformat partisi LFS ($PARTITION_LFS) dengan ext4..."
mkfs.ext4 $PARTITION_LFS

# 3. Membuat Mount Point untuk LFS
echo "Membuat mount point untuk LFS di /mnt/lfs..."
mkdir -pv /mnt/lfs

# 4. Mount Partisi LFS
echo "Mount partisi $PARTITION_LFS ke /mnt/lfs..."
mount $PARTITION_LFS /mnt/lfs

# 5. Menambahkan ke /etc/fstab agar mount otomatis saat reboot
echo "Menambahkan entri ke /etc/fstab..."
echo "$PARTITION_LFS  /mnt/lfs  ext4  defaults  0  1" >> /etc/fstab

# Menampilkan hasil
echo "Partisi LFS telah dibuat dan diformat."
echo "Partisi LFS telah dipasang di /mnt/lfs."
echo "Entri untuk partisi LFS telah ditambahkan ke /etc/fstab."
