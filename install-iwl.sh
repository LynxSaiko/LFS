#!/bin/bash

FIRMWARE_FILE="linux-firmware-20250311.tar.xz"

echo "[1] Mengecek file firmware lokal..."
if [ -f "$FIRMWARE_FILE" ]; then
    echo "✅ Firmware ditemukan: $FIRMWARE_FILE"
    echo "[2] Mengekstrak firmware ke /lib/firmware..."
    mkdir -p /lib/firmware
    tar -xf "$FIRMWARE_FILE" -C /lib/firmware
else
    echo "❌ File $FIRMWARE_FILE tidak ditemukan di direktori ini."
    echo "Silakan salin file firmware versi 20250311 ke direktori ini."
    exit 1
fi

echo "[3] Masuk ke direktori kernel source di /sources/linux-5.19.2..."
cd /sources/linux-5.19.2 || { echo "❌ Kernel source tidak ditemukan."; exit 1; }

echo "[4] Mengaktifkan dukungan Wi-Fi (iwlwifi)..."
scripts/config --enable CONFIG_CFG80211
scripts/config --module CONFIG_MAC80211
scripts/config --module CONFIG_IWLWIFI
scripts/config --module CONFIG_IWLWIFI_OPMODE_MODULAR
scripts/config --enable CONFIG_WLAN
scripts/config --module CONFIG_IWLDVM
scripts/config --module CONFIG_IWLMVM

echo "[5] Menyimpan konfigurasi dengan 'make olddefconfig'..."
make olddefconfig

echo "[6] Build dan install modul Wi-Fi..."
make modules -j$(nproc)
make modules_install

echo "[7] Memuat ulang modul dan memuat iwlwifi..."
depmod
modprobe iwlwifi

echo "[8] Menampilkan interface jaringan..."
ip link

echo "[9] Mengatur DNS ke 8.8.8.8..."
echo "nameserver 8.8.8.8" > /etc/resolv.conf

echo "[10] Selesai ✅"
echo "Jika interface wlan0 muncul, jalankan:"
echo "  dhclient wlan0"
echo "  ping google.com"
