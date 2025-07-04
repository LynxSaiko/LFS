#!/bin/bash
# Cek apakah LFS siap reboot dengan GRUB dan TTY login
# Jalankan di dalam chroot
# by ChatGPT

echo "=== [ Cek Sistem LFS Siap Boot ] ==="
echo

# 1. Cek kernel
kernel=$(ls /boot/vmlinuz-* 2>/dev/null)
if [ -n "$kernel" ]; then
    echo "✅ Kernel ditemukan: $kernel"
else
    echo "❌ Kernel TIDAK ditemukan di /boot"
fi

# 2. Cek grub.cfg
if [ -f /boot/grub/grub.cfg ]; then
    echo "✅ grub.cfg ditemukan"
    grep -q "menuentry" /boot/grub/grub.cfg && echo "✅ grub.cfg berisi menu boot" || echo "❌ grub.cfg kosong/tidak valid"
else
    echo "❌ grub.cfg TIDAK ditemukan"
fi

# 3. Cek apakah GRUB berhasil ter-install
if grub-install --version >/dev/null 2>&1; then
    echo "✅ GRUB tersedia di sistem"
else
    echo "❌ GRUB belum terpasang dengan benar"
fi

# 4. Cek /etc/inittab untuk getty (login tty)
if grep -q "tty1" /etc/inittab 2>/dev/null; then
    echo "✅ getty tty1 ditemukan di /etc/inittab"
else
    echo "❌ Tidak ada login tty (cek /etc/inittab)"
fi

# 5. Cek user root ada
if grep -q "^root:" /etc/passwd; then
    echo "✅ User root ada"
else
    echo "❌ User root tidak ditemukan (cek /etc/passwd)"
fi

# 6. Cek apakah init ada
if [ -x /sbin/init ] || [ -x /bin/init ]; then
    echo "✅ init ditemukan"
else
    echo "❌ init tidak ditemukan"
fi

echo
echo "=== [ Rangkuman ] ==="

if [ -n "$kernel" ] && [ -f /boot/grub/grub.cfg ] && grep -q "menuentry" /boot/grub/grub.cfg \
   && grep -q "tty1" /etc/inittab 2>/dev/null && grep -q "^root:" /etc/passwd \
   && ( [ -x /sbin/init ] || [ -x /bin/init ] ); then
    echo "✅ SISTEM LFS SIAP UNTUK BOOT & LOGIN TTY"
else
    echo "❌ Ada masalah. Sistem belum siap boot penuh."
fi
