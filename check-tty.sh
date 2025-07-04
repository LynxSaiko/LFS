#!/bin/bash
# Cek kesiapan sistem LFS untuk menampilkan login TTY setelah boot
# Jalankan di dalam chroot LFS
# by ChatGPT

echo "=== [ Cek Login TTY Setelah Boot ] ==="

failcount=0

# 1. Cek init
echo -n "🔍 Cek /sbin/init: "
if [ -x /sbin/init ]; then
    echo "✅ OK"
else
    echo "❌ Tidak ditemukan"
    ((failcount++))
fi

# 2. Cek /etc/inittab untuk getty
echo -n "🔍 Cek /etc/inittab (tty1): "
if grep -q "tty1" /etc/inittab 2>/dev/null; then
    echo "✅ OK"
else
    echo "❌ tty1 tidak dikonfigurasi"
    ((failcount++))
fi

# 3. Cek /dev/console
echo -n "🔍 Cek /dev/console: "
if [ -c /dev/console ]; then
    echo "✅ OK"
else
    echo "❌ Tidak ada"
    ((failcount++))
fi

# 4. Cek /dev/null
echo -n "🔍 Cek /dev/null: "
if [ -c /dev/null ]; then
    echo "✅ OK"
else
    echo "❌ Tidak ada"
    ((failcount++))
fi

# 5. Cek shell /bin/bash
echo -n "🔍 Cek /bin/bash: "
if [ -x /bin/bash ]; then
    echo "✅ OK"
else
    echo "❌ Tidak ada /bin/bash"
    ((failcount++))
fi

# 6. Cek user root
echo -n "🔍 Cek user root di /etc/passwd: "
if grep -q "^root:" /etc/passwd; then
    echo "✅ OK"
else
    echo "❌ Tidak ditemukan"
    ((failcount++))
fi

# 7. Cek bootscripts getty aktif
echo -n "🔍 Cek bootscript getty (rcS): "
if grep -q "console" /etc/inittab || grep -q "getty" /etc/inittab; then
    echo "✅ OK"
else
    echo "⚠️  Mungkin belum aktif"
fi

echo
echo "=== [ RANGKUMAN ] ==="
if [ "$failcount" -eq 0 ]; then
    echo "✅ SISTEM SIAP TAMPILKAN LOGIN TTY SETELAH BOOT"
else
    echo "❌ Ada $failcount masalah. Login TTY kemungkinan gagal tampil."
fi
