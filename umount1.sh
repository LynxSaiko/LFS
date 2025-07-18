#!/bin/bash
# Script untuk membersihkan semua bind mount LFS dan menghapus folder literal brace expansion
# Pastikan dijalankan sebagai root

LFS="/mnt/lfs"
BRACE_FOLDER="$LFS/{dev,proc,sys,run}"

echo "[INFO] Membersihkan mount bind di $LFS"
echo "==========================================="

# Cari semua mount di bawah /mnt/lfs dan urutkan dari paling dalam
MOUNTS=$(mount | grep "$LFS" | awk '{print $3}' | sort -r)

if [ -z "$MOUNTS" ]; then
    echo "[OK] Tidak ada mount di bawah $LFS."
else
    echo "[INFO] Ditemukan mount point:"
    echo "$MOUNTS"
    echo "[INFO] Melakukan umount semua mount point..."
    for M in $MOUNTS; do
        echo "  - Umount $M"
        umount -l "$M"
    done
fi

echo "==========================================="
echo "[INFO] Mengecek folder literal brace expansion..."
if [ -d "$BRACE_FOLDER" ]; then
    echo "[FOUND] Folder literal $BRACE_FOLDER ditemukan, menghapus..."
    rm -rf "$BRACE_FOLDER"
    if [ ! -d "$BRACE_FOLDER" ]; then
        echo "[SUCCESS] Folder literal berhasil dihapus!"
    else
        echo "[ERROR] Gagal menghapus folder literal!"
    fi
else
    echo "[OK] Folder literal tidak ditemukan."
fi

echo "==========================================="
echo "[DONE] Semua mount telah dibersihkan dan folder brace dicek."
