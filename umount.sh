#!/bin/bash
# Script untuk menghapus folder literal {dev,proc,sys,run} dengan aman
# Pastikan dijalankan sebagai root

TARGET="/mnt/lfs/\{dev,proc,sys,run\}"

echo "[INFO] Mengecek apakah folder literal ada..."
if [ ! -d "$TARGET" ]; then
    echo "[OK] Folder $TARGET tidak ditemukan. Tidak ada yang perlu dihapus."
    exit 0
fi

echo "[INFO] Mencari mount point di dalam $TARGET..."
MOUNTS=$(mount | grep "$TARGET" | awk '{print $3}' | sort -r)

if [ -n "$MOUNTS" ]; then
    echo "[INFO] Ditemukan mount di dalam folder, melakukan umount..."
    for M in $MOUNTS; do
        echo "  - Umount $M"
        umount -l "$M"
    done
else
    echo "[OK] Tidak ada mount point di dalam folder."
fi

echo "[INFO] Menghapus folder literal..."
rm -rf "$TARGET"

if [ ! -d "$TARGET" ]; then
    echo "[SUCCESS] Folder literal {dev,proc,sys,run} berhasil dihapus!"
else
    echo "[ERROR] Folder masih ada, periksa manual!"
fi
