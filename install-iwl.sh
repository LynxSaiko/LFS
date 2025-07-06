#!/bin/bash

FIRMWARE_FILE="linux-firmware-20250531.tar.xz"
FIRMWARE_URL="https://cdn.kernel.org/pub/linux/kernel/firmware/$FIRMWARE_FILE"

echo "[1] Mengecek file firmware lokal..."
if [ ! -f "$FIRMWARE_FILE" ]; then
    echo "⚠️  File $FIRMWARE_FILE tidak ditemukan. Mencoba download..."
    wget $FIRMWARE_URL -O $FIRMWARE_FILE
    if [ $? -ne 0 ]; then
        echo "❌ Gagal mendownload firmware. Periksa koneksi internet."
        exit 1
    fi
else
    echo "✅ Firmware ditemukan lokal: $FIRMWARE_FILE"
fi

echo "[2] Mengekstrak firmware ke /lib/firmware..."
mkdir -p /lib/firmware
tar -xf $FIRMWARE_FILE -C /lib/firmware

echo "[3] Memuat ulang daftar modul kernel..."
depmod

echo "[4] Memuat modul iwlwifi..."
modprobe iwlwifi

echo "[5] Menampilkan interface jaringan..."
ip link

echo "[6] Mengatur DNS resolver ke 8.8.8.8..."
echo "nameserver 8.8.8.8" > /etc/resolv.conf

echo "[7] Selesai ✅"
echo "Silakan jalankan:"
echo "  dhclient wlan0       # Dapatkan IP"
echo "  ping google.com      # Cek koneksi"
