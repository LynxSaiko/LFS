# Setelah chroot di /mnt/lfs

# Ambil UUID
SDB3_UUID=$(blkid /dev/sdb3 | sed -E 's/.*UUID="([^"]+)".*/\1/')

# Install GRUB ke MBR disk /dev/sdb
grub-install --target=i386-pc --recheck /dev/sdb

# Buat grub.cfg menggunakan UUID
cat > /boot/grub/grub.cfg << EOF
set default=0
set timeout=5

menuentry "LFS 11.2 (on /dev/sdb3)" {
    search --no-floppy --fs-uuid --set=root $SDB3_UUID
    linux /boot/vmlinuz-5.19.2-lfs-11.2 root=UUID=$SDB3_UUID ro
}
EOF
