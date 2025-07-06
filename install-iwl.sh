#!/bin/bash

FIRMWARE_FILE="linux-firmware-20250531.tar.xz"
FIRMWARE_URL="https://cdn.kernel.org/pub/linux/kernel/firmware/$FIRMWARE_FILE"

echo "[1] Mengecek file firmware lokal..."
if [ ! -f "$FIRMWARE_FILE" ]; then
    echo "⚠️  File $FIRMWARE_FILE tidak ditemukan. Mencoba download dari:"
    echo "    $FIRMWARE_URL"
    
    wget "$FIRMWARE_URL" -O "$FIRMWARE_FILE"
    if [ $? -ne 0 ]; then
        echo "❌ Gagal mendownload firmware. Periksa koneksi internet atau salin file manual."
        exit 1
    fi
else
    echo "✅ Firmware ditemukan lokal: $FIRMWARE_FILE"
fi

echo "[2] Mengekstrak firmware ke /lib/firmware..."
mkdir -p /lib/firmware
tar -xf "$FIRMWARE_FILE" -C /lib/firmware

echo "[3] Masuk ke direktori kernel source di /sources/linux-5.19.2..."
cd /sources/linux-5.19.2 || { echo "❌ Kernel source tidak ditemukan di /sources."; exit 1; }

echo "[4] Mengaktifkan dukungan Wi-Fi (iwlwifi)..."
scripts/config --enable CONFIG_CFG80211
scripts/config --module CONFIG_MAC80211
scripts/config --module CONFIG_IWLWIFI
scripts/config --module CONFIG_IWLWIFI_OPMODE_MODULAR
scripts/config --enable CONFIG_WLAN
scripts/config --module CONFIG_IWLDVM
scripts/config --module CONFIG_IWLMVM

echo "[5] Menyimpan konfigurasi kernel dengan olddefconfig..."
make olddefconfig

echo "[6] Build dan install modul Wi-Fi..."
make modules -j$(nproc)
make modules_install

echo "[7] Memuat ulang modul dan interface..."
depmod
modprobe iwlwifi

echo "[8] Menampilkan interface jaringan..."
ip link

echo "[9] Mengatur DNS resolver ke 8.8.8.8..."
echo "nameserver 8.8.8.8" > /etc/resolv.conf

echo "[10] Selesai ✅"
echo "Silakan jalankan:"
echo "  dhclient wlan0       # Untuk mendapatkan IP via DHCP"
echo "  ping google.com      # Untuk menguji koneksi"
