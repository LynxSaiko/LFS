#!/bin/bash

# AUTO GRUB CONFIG GENERATOR UNTUK LFS / LeakOS
# Kompatibel dengan GRUB BIOS (i386-pc)

set -e

### === KONFIGURASI === ###
LFS_MOUNT=/mnt
BOOTDIR="$LFS_MOUNT/boot"
GRUBDIR="$BOOTDIR/grub"
GRUBCFG="$GRUBDIR/grub.cfg"

echo "📦 Mendeteksi kernel di $BOOTDIR ..."
KERNEL=$(ls "$BOOTDIR"/vmlinuz-* 2>/dev/null | head -n1)
KERNEL_FILE=$(basename "$KERNEL")

if [[ -z "$KERNEL_FILE" ]]; then
    echo "❌ Kernel tidak ditemukan di $BOOTDIR"
    exit 1
fi

echo "🖴 Mendeteksi partisi root LeakOS ..."
ROOT_DEVICE=$(findmnt -n -o SOURCE --target "$LFS_MOUNT")

if [[ -z "$ROOT_DEVICE" ]]; then
    echo "❌ Gagal mendeteksi device /mnt"
    exit 1
fi

# Ambil angka partisi, misal /dev/sda2 → 2
PART_NUM=$(echo "$ROOT_DEVICE" | grep -o '[0-9]*$')
GRUB_INDEX=$((PART_NUM - 1))

### === Buat GRUB CFG === ###
mkdir -p "$GRUBDIR"

cat > "$GRUBCFG" << EOF
set default=0
set timeout=5

insmod ext2
set root=(hd0,$GRUB_INDEX)

menuentry "LeakOS V1 (Shadow Edition)" {
    linux /boot/$KERNEL_FILE root=$ROOT_DEVICE ro
}
EOF

echo "✅ grub.cfg berhasil dibuat:"
echo "   → $GRUBCFG"
echo "   → Kernel: $KERNEL_FILE"
echo "   → Root: $ROOT_DEVICE → GRUB root: (hd0,$GRUB_INDEX)"
