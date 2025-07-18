#!/bin/bash
# Script untuk menghapus folder literal {dev,proc,sys,run} dengan aman
# Tidak akan menghapus folder asli dev, proc, sys, run

TARGET="{dev,proc,sys,run}"

echo "[INFO] Mengecek keberadaan folder literal: $TARGET"

if [ -d "$TARGET" ]; then
    echo "[FOUND] Folder literal ditemukan di $(pwd)"
    
    # Pastikan tidak sedang ada mount di dalam folder ini
    echo "[INFO] Mengecek mount point di dalam folder..."
    MOUNTS=$(mount | grep "$TARGET" | awk '{print $3}' | sort -r)
    
    if [ -n "$MOUNTS" ]; then
        echo "[INFO] Ditemukan mount point di bawah $TARGET, melakukan umount..."
        for M in $MOUNTS; do
            echo "  - Umount $M"
            umount -l "$M"
        done
    fi
    
    echo "[INFO] Menghapus folder literal $TARGET..."
    rm -rf "$TARGET"
    
    if [ ! -d "$TARGET" ]; then
        echo "[SUCCESS] Folder literal {dev,proc,sys,run} berhasil dihapus!"
    else
        echo "[ERROR] Gagal menghapus folder literal!"
    fi
else
    echo "[OK] Folder literal {dev,proc,sys,run} tidak ditemukan."
fi
