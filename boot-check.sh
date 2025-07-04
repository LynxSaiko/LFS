#!/bin/bash
# Cek lengkap apakah LFS siap reboot dan login tty
# Jalankan di dalam chroot

echo "=== [ Cek Kesiapan Sistem LFS untuk Boot ] ==="
echo

# --- KERNEL ---
kernel=$(ls /boot/vmlinuz-* 2>/dev/null)
if [ -n "$kernel" ]; then
    echo "✅ Kernel ditemukan: $kernel"
else
    echo "❌ Kernel TIDAK ditemukan di /boot"
fi

# --- GRUB ---
if [ -f /boot/grub/grub.cfg ]; then
    echo "✅ grub.cfg ditemukan"
    grep -q "menuentry" /boot/grub/grub.cfg && echo "✅ grub.cfg berisi menu boot" || echo "❌ grub.cfg kosong/tidak valid"
else
    echo "❌ grub.cfg TIDAK ditemukan"
fi

grub-install --version >/dev/null 2>&1 && echo "✅ GRUB tersedia" || echo "❌ GRUB tidak tersedia"

# --- INIT ---
if [ -x /sbin/init ]; then
    echo "✅ /sbin/init ditemukan"
elif [ -x /bin/init ]; then
    echo "✅ /bin/init ditemukan"
else
    echo "❌ init tidak ditemukan"
fi

# --- SYMLINK /init ---
if [ -L /init ] && [ "$(readlink -f /init)" = "/sbin/init" ]; then
    echo "✅ Symlink /init -> /sbin/init OK"
else
    echo "⚠️ /init tidak menunjuk ke /sbin/init"
fi

# --- INITTAB / LOGIN ---
if grep -q "tty1" /etc/inittab 2>/dev/null; then
    echo "✅ Konfigurasi login tty1 OK (/etc/inittab)"
else
    echo "❌ Tidak ada getty tty1 di /etc/inittab"
fi

# --- USER ROOT ---
if grep -q "^root:" /etc/passwd; then
    echo "✅ User root ada"
else
    echo "❌ User root tidak ditemukan di /etc/passwd"
fi

# --- FSTAB ---
echo
echo "📁 Pemeriksaan /etc/fstab:"
if [ -f /etc/fstab ]; then
    grep -q " / " /etc/fstab && echo "✅ Entri root (/) ada" || echo "❌ Entri root (/) hilang"
    grep -q "/proc" /etc/fstab && echo "✅ Entri /proc ada" || echo "❌ Entri /proc hilang"
    grep -q "/sys" /etc/fstab && echo "✅ Entri /sys ada" || echo "⚠️ /sys belum di-mount otomatis"
else
    echo "❌ File /etc/fstab tidak ditemukan"
fi

# --- HOSTNAME ---
if [ -f /etc/hostname ] && [ -s /etc/hostname ]; then
    echo "✅ /etc/hostname ada: $(cat /etc/hostname)"
else
    echo "⚠️ /etc/hostname tidak ada atau kosong"
fi

# --- SHELL ---
[ -x /bin/bash ] && echo "✅ Shell default /bin/bash tersedia" || echo "❌ /bin/bash tidak ditemukan"

echo
echo "=== [ RANGKUMAN ] ==="

failcount=0
grep -q "^root:" /etc/passwd || ((failcount++))
[ -n "$kernel" ] || ((failcount++))
[ -f /boot/grub/grub.cfg ] || ((failcount++))
grep -q "menuentry" /boot/grub/grub.cfg || ((failcount++))
[ -x /sbin/init ] || [ -x /bin/init ] || ((failcount++))
grep -q "tty1" /etc/inittab 2>/dev/null || ((failcount++))
[ -x /bin/bash ] || ((failcount++))

if [ "$failcount" -eq 0 ]; then
    echo "✅ SISTEM LFS SIAP UNTUK BOOT & LOGIN TTY"
else
    echo "❌ Ada $failcount masalah. Sistem belum siap boot penuh."
fi
