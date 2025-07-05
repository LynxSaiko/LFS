#!/bin/bash

echo "=== 1. Install firmware Wi-Fi ==="
cd /lib/firmware || exit 1
git clone https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git
cp -rv linux-firmware/* . && rm -rf linux-firmware

echo "=== 2. Build iw ==="
cd /sources
wget https://www.kernel.org/pub/software/network/iw/iw-5.19.tar.xz
tar -xf iw-5.19.tar.xz
cd iw-5.19
make && make install

echo "=== 3. Build wpa_supplicant ==="
cd /sources
wget https://w1.fi/releases/wpa_supplicant-2.10.tar.gz
tar -xf wpa_supplicant-2.10.tar.gz
cd wpa_supplicant-2.10/wpa_supplicant
cp defconfig .config
make && make install

echo "=== 4. Tambahkan auto start wlan0 ==="
if ! grep -q "ifconfig wlan0 up" /etc/rc.d/rc.local; then
  echo "ifconfig wlan0 up" >> /etc/rc.d/rc.local
  chmod +x /etc/rc.d/rc.local
  echo "✅ wlan0 auto start ditambahkan"
else
  echo "✔ Sudah ada wlan0 up di rc.local"
fi

echo
echo "=== 5. (Opsional) Tambah dhclient ==="
echo "Gunakan source dari ISC dhcp (dhclient) jika ingin DHCP otomatis"
