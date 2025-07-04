#!/bin/bash

echo "======================================="
echo "  🔧 LFS TTY Login Recovery Script 🔧"
echo "======================================="

# Cek apakah init ada
if [ ! -x /sbin/init ]; then
  echo "❌ ERROR: /sbin/init tidak ditemukan!"
  echo "Silakan install sysvinit dan buat symlink:"
  echo "  ln -sv /lib/sysvinit/init /sbin/init"
  exit 1
else
  echo "✅ OK: /sbin/init ditemukan."
fi

# Cek apakah agetty ada
if ! command -v agetty &>/dev/null; then
  echo "❌ ERROR: agetty tidak ditemukan!"
  echo "Silakan pastikan util-linux sudah terinstall."
  exit 1
else
  echo "✅ OK: agetty ditemukan."
fi

# Cek apakah /etc/inittab ada
if [ ! -f /etc/inittab ]; then
  echo "❌ ERROR: /etc/inittab tidak ada!"
  echo "Silakan buat /etc/inittab minimal seperti ini:"
  cat <<EOF
id:3:initdefault:

l3:3:wait:/etc/rc.d/init.d/rc 3

1:2345:respawn:/sbin/agetty --noclear tty1 9600
EOF
  exit 1
else
  echo "✅ OK: /etc/inittab ditemukan."
fi

# Cek apakah /etc/rc.d/init.d/rc ada
if [ ! -x /etc/rc.d/init.d/rc ]; then
  echo "❌ ERROR: /etc/rc.d/init.d/rc tidak ditemukan atau tidak bisa dieksekusi!"
  echo "Silakan pastikan skrip rc ada dan chmod +x."
  exit 1
else
  echo "✅ OK: /etc/rc.d/init.d/rc ditemukan dan executable."
fi

# Cek apakah TTY aktif
echo "🔍 Mengecek TTY aktif:"
ps aux | grep '[a]getty'

echo "======================================="
echo "✅ Pemeriksaan selesai."
echo "Jika semua OK, reboot sistemmu."
echo "Jika TTY belum muncul, cek /var/log/* untuk pesan error."
