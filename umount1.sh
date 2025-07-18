#!/bin/bash
TARGET="/mnt/lfs/{dev,proc,sys,run}"

echo "[INFO] Mengecek folder literal..."
if [ ! -d "$TARGET" ]; then
    echo "[OK] Folder literal tidak ditemukan."
    exit 0
fi

echo "[FOUND] Folder literal ditemukan: $TARGET"

echo "[INFO] Mengecek mount point di dalam folder..."
MOUNTS=$(mount | grep "$TARGET" | awk '{print $3}' | sort -r)

if [ -n "$MOUNTS" ]; then
    echo "[INFO] Ditemukan mount point, melakukan umount satu per satu..."
    for M in $MOUNTS; do
        echo "  - Umount $M"
        umount -l "$M"
    done
else
    echo "[OK] Tidak ada mount point."
fi

echo "[INFO] Menghapus folder literal..."
rm -rf "$TARGET"

if [ ! -d "$TARGET" ]; then
    echo "[SUCCESS] Folder literal berhasil dihapus!"
else
    echo "[ERROR] Folder masih ada, periksa manual!"
fi
