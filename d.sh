#!/bin/bash

# LeakOS GRUB Auto Fix (BIOS - MBR)
# Kompatibel LFS 11.2 / LeakOS
# Jalankan dari LiveCD (BlackArch, Debian, dsb)

set -e

### === KONFIGURASI DASAR === ###
ROOT_PART="/dev/sda2"
DISK="/dev/sda"
LFS="/mnt"

echo "📦 Mounting root LeakOS: $ROOT_PART → $LFS"
mount "$ROOT_PART" "$LFS"

for dir in dev proc sys run; do
    mount --bind /$dir $LFS/$dir
done

### === CHROOT DAN INSTAL GRUB === ###
echo "🚀 Masuk ke chroot dan install GRUB..."
chroot "$LFS" /usr/bin/env -i \
    HOME=/root TERM="$TERM" PS1='(leakos chroot) \u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin \
    /bin/bash --login << 'EOF'

# Langkah 1: install grub ke MBR
echo "💾 Menginstal GRUB ke /dev/sda ..."
grub-install --target=i386-pc /dev/sda

# Langkah 2: deteksi kernel
BOOT_KERNEL=\$(ls /boot/vmlinuz-* 2>/dev/null | head -n1)
BOOT_KERNEL_FILE=\$(basename "\$BOOT_KERNEL")

if [[ -z "\$BOOT_KERNEL_FILE" ]]; then
    echo "❌ Kernel tidak ditemukan di /boot"
    exit 1
fi

# Langkah 3: generate grub.cfg
echo "⚙️ Menulis grub.cfg ..."
cat > /boot/grub/grub.cfg << EOF_CFG
set default=0
set timeout=5

insmod ext2
set root=(hd0,1)

menuentry "LeakOS (Auto Fixed)" {
    linux /boot/\$BOOT_KERNEL_FILE root=/dev/sda2 ro
}
EOF_CFG

echo "✅ GRUB LeakOS berhasil diperbaiki!"
EOF

### === UNMOUNT & SELESAI === ###
echo "🔧 Unmount semua..."
umount -Rv "$LFS"

echo "✅ LeakOS GRUB FIX selesai. Silakan reboot."
