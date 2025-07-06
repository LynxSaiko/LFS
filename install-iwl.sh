#!/bin/bash

echo "[1] Mengekstrak firmware..."
if [ -f /tmp/linux-firmware-*.tar.xz ]; then
    mkdir -p /lib/firmware
    tar -xf /tmp/linux-firmware-*.tar.xz -C /lib/firmware
else
    echo "❌ File firmware tidak ditemukan di /tmp. Salin dulu dari USB."
    exit 1
fi

echo "[2] Masuk ke direktori kernel source di /sources..."
cd /sources/linux-5.19.2 || { echo "❌ Kernel source tidak ditemukan di /sources."; exit 1; }

echo "[3] Mengaktifkan dukungan Wi-Fi (iwlwifi)..."
yes "" | make oldconfig
scripts/config --enable CONFIG_CFG80211
scripts/config --module CONFIG_MAC80211
scripts/config --module CONFIG_IWLWIFI
scripts/config --module CONFIG_IWLWIFI_OPMODE_MODULAR
scripts/config --enable CONFIG_WLAN
scripts/config --module CONFIG_IWLDVM
scripts/config --module CONFIG_IWLMVM

echo "[4] Build dan install modul Wi-Fi..."
make modules -j$(nproc)
make modules_install

echo "[5] Memuat ulang modul iwlwifi..."
depmod
modprobe iwlwifi

echo "[6] Menampilkan interface jaringan..."
ip link

echo "[7] Mengatur DNS resolver ke 8.8.8.8..."
echo "nameserver 8.8.8.8" > /etc/resolv.conf

echo "[8] Selesai. Coba jalankan perintah berikut:"
echo "  ip link        # Untuk melihat apakah wlan0 muncul"
echo "  dhclient wlan0 # Untuk mendapatkan IP otomatis"
echo "  ping google.com"
