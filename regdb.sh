#!/bin/bash

set -e

echo "===> [1] Membuat direktori sumber..."
mkdir -p /usr/local/src
cd /usr/local/src

echo "===> [2] Clone repo wireless-regdb terbaru..."
rm -rf wireless-regdb
git clone https://git.kernel.org/pub/scm/linux/kernel/git/wens/wireless-regdb.git
cd wireless-regdb

echo "===> [3] Build (opsional, jika kamu edit db.txt)..."
make || true

echo "===> [4] Salin regulatory.db ke /lib/firmware..."
cp -v regulatory.db regulatory.db.p7s /lib/firmware/

echo "===> [5] Reload modul cfg80211..."
modprobe -r cfg80211 || true
modprobe cfg80211

echo "===> [6] Atur regional default Indonesia (ID)..."
iw reg set ID

echo "===> [7] Verifikasi hasil:"
dmesg | grep cfg80211 || echo "Periksa log kernel secara manual."

echo "✅ Regulatory.db berhasil dipasang dan aktif!"
