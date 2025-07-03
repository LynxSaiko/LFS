#!/bin/bash

set -e
ROOT_DEV="/dev/sda2"
DISK="/dev/sda"
MNT="/mnt"

echo "📦 Mount LeakOS root: $ROOT_DEV → $MNT"
mount | grep "$MNT" >/dev/null || mount "$ROOT_DEV" "$MNT"

echo "🔧 Membuat device node di $MNT/dev..."
mknod -m 600 $MNT/dev/console c 5 1 || true
mknod -m 666 $MNT/dev/null c 1 3 || true
mknod -m 666 $MNT/dev/zero c 1 5 || true
mknod -m 622 $MNT/dev/tty c 5 0 || true
chown root:tty $MNT/dev/console $MNT/dev/tty || true

echo "🔁 Mounting virtual filesystems..."
for fs in dev proc sys; do
  mount --bind /$fs $MNT/$fs
done

echo "🚪 Masuk chroot LeakOS untuk perbaikan..."
chroot $MNT /bin/bash --login << "EOF"
echo "🧠 Menulis ulang /etc/inittab..."
cat > /etc/inittab << "EOT"
id:3:initdefault:
si::sysinit:/etc/rc.d/init.d/rc S
l0:0:wait:/etc/rc.d/init.d/rc 0
l1:1:wait:/etc/rc.d/init.d/rc 1
l2:2:wait:/etc/rc.d/init.d/rc 2
l3:3:wait:/etc/rc.d/init.d/rc 3
l4:4:wait:/etc/rc.d/init.d/rc 4
l5:5:wait:/etc/rc.d/init.d/rc 5
l6:6:wait:/etc/rc.d/init.d/rc 6
ca:12345:ctrlaltdel:/sbin/shutdown -t1 -a -r now
su:S016:once:/sbin/sulogin
c1:12345:respawn:/sbin/agetty --noclear tty1 9600
c2:2345:respawn:/sbin/agetty tty2 9600
c3:2345:respawn:/sbin/agetty tty3 9600
c4:2345:respawn:/sbin/agetty tty4 9600
c5:2345:respawn:/sbin/agetty tty5 9600
c6:2345:respawn:/sbin/agetty tty6 9600
EOT

echo "💽 Memasang ulang GRUB ke /dev/sda..."
grub-install --target=i386-pc /dev/sda

echo "📝 Membuat grub.cfg otomatis..."
KERNEL=\$(ls /boot/vmlinuz-* | head -n1 | xargs basename)
cat > /boot/grub/grub.cfg << EOG
set default=0
set timeout=5
insmod ext2
set root=(hd0,2)
menuentry "LeakOS Auto" {
    linux /boot/\$KERNEL root=/dev/sda2 ro
}
EOG

echo "🔍 Mengecek komponen penting..."
for f in /sbin/init /sbin/agetty /etc/inittab /etc/rc.d/init.d/rc; do
  [[ -x "\$f" || -f "\$f" ]] && echo "✔️  \$f OK" || echo "❌ \$f TIDAK ADA!"
done

[[ -e /dev/console ]] && echo "✔️  /dev/console OK" || echo "❌ /dev/console TIDAK ADA!"

echo "🧪 Mengecek kernel..."
file /boot/\$KERNEL | grep "Linux kernel" && echo "✅ Kernel OK" || echo "❌ Kernel rusak!"

echo "✅ Semua langkah selesai di chroot."
EOF

echo "🔄 Unmount semua..."
umount -Rv $MNT

echo "🎉 LeakOS siap reboot!"
