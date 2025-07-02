#!/bin/bash
set -e

# === KONFIGURASI DASAR ===
DISK="/dev/sda"         # Disk tempat GRUB akan dipasang (bukan partisi!)
ROOT_PART="/dev/sda2"   # Partisi root LFS kamu
GRUB_DIR="/boot/grub"

echo "📌 Memulai setup LeakOS GRUB untuk root $ROOT_PART di $DISK"

# === Buat direktori grub jika belum ada ===
[ -d "$GRUB_DIR" ] || mkdir -v "$GRUB_DIR"

# === Deteksi nama kernel ===
KERNEL=$(ls /boot/vmlinuz-* 2>/dev/null | head -n1)
if [[ -z "$KERNEL" ]]; then
    echo "❌ Kernel tidak ditemukan di /boot/"
    exit 1
fi
KERNEL_NAME=$(basename "$KERNEL")
echo "✅ Kernel ditemukan: $KERNEL_NAME"

# === Hitung indeks partisi GRUB (hd0,Y) ===
PART_INDEX=$(echo "$ROOT_PART" | grep -o '[0-9]*$')
GRUB_INDEX=$((PART_INDEX - 1))
GRUB_ROOT="(hd0,$GRUB_INDEX)"

# === Tulis grub.cfg ===
echo "📝 Membuat grub.cfg di $GRUB_DIR ..."
cat > "$GRUB_DIR/grub.cfg" << EOF
# Begin /boot/grub/grub.cfg
set default=0
set timeout=5

insmod ext2
set root=$GRUB_ROOT

menuentry "LeakOS V1 (Shadow Edition)" {
    linux /boot/$KERNEL_NAME root=$ROOT_PART ro
}
EOF
echo "✅ grub.cfg selesai dibuat."

# === Install GRUB ke MBR ===
echo "⚙️  Menanamkan GRUB ke $DISK ..."
grub-install --target=i386-pc "$DISK"
echo "✅ GRUB berhasil dipasang ke $DISK."

# === Buat /etc/os-release ===
echo "📝 Membuat /etc/os-release ..."
cat > /etc/os-release << "EOF"
NAME="LeakOS"
VERSION="V1 (Shadow Edition)"
ID=leakos
PRETTY_NAME="LeakOS V1 (Shadow Edition)"
VERSION_ID="1.0"
HOME_URL="https://leakos.local"
EOF

# === Buat /etc/lsb-release ===
echo "📝 Membuat /etc/lsb-release ..."
cat > /etc/lsb-release << "EOF"
DISTRIB_ID=LeakOS
DISTRIB_RELEASE=1.0
DISTRIB_CODENAME=shadow
DISTRIB_DESCRIPTION="LeakOS V1 (Shadow Edition)"
EOF

echo "✅ os-release dan lsb-release selesai dibuat."

# === Unmount semua dari /mnt/lfs kalau ada ===
if mountpoint -q /mnt/lfs; then
    echo "🧹 Melakukan unmount /mnt/lfs secara rekursif..."
    umount -Rv /mnt/lfs || echo "⚠️ Beberapa mount mungkin masih terpakai."
else
    echo "ℹ️ Tidak mendeteksi /mnt/lfs sebagai mount aktif. Lewatkan unmount."
fi

echo "🎉 Setup LeakOS selesai! Siap reboot!"
