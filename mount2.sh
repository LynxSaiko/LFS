#!/bin/bash

# Memeriksa apakah variabel LFS sudah terdefinisi
if [ -z "$LFS" ]; then
  echo "Variabel LFS belum didefinisikan!"
  exit 1
fi

# Membuat perangkat khusus yang diperlukan
mknod -m 600 $LFS/dev/console c 5 1 || true
mknod -m 666 $LFS/dev/null c 1 3 || true
mknod -m 666 $LFS/dev/zero c 1 5 || true
mknod -m 622 $LFS/dev/tty c 5 0 || true

# Setel kepemilikan perangkat
chown root:tty $LFS/dev/console $LFS/dev/tty || true

# Mount sistem file yang diperlukan hanya jika belum dimount
if ! mountpoint -q $LFS/dev && ! mount | grep -q "$LFS/dev "; then
  mount -v --bind /dev $LFS/dev
fi

if ! mountpoint -q $LFS/dev/pts && ! mount | grep -q "$LFS/dev/pts "; then
  mount -v --bind /dev/pts $LFS/dev/pts
fi

if ! mountpoint -q $LFS/proc && ! mount | grep -q "$LFS/proc "; then
  mount -vt proc proc $LFS/proc
fi

if ! mountpoint -q $LFS/sys && ! mount | grep -q "$LFS/sys "; then
  mount -vt sysfs sysfs $LFS/sys
fi

if ! mountpoint -q $LFS/run && ! mount | grep -q "$LFS/run "; then
  mount -vt tmpfs tmpfs $LFS/run
fi

# Jika ada link simbolis untuk /dev/shm, buatkan direktori yang sesuai
if [ -h $LFS/dev/shm ]; then
  mkdir -pv $LFS/$(readlink $LFS/dev/shm)
fi

# Memastikan sistem di $LFS sudah siap dan siap untuk di-chroot
if [ ! -d "$LFS" ]; then
  echo "Direktori $LFS tidak ada atau salah. Pastikan pathnya benar."
  exit 1
fi

# Memasuki chroot dengan pengaturan lingkungan minimal
chroot "$LFS" /usr/bin/env -i \
    HOME=/root                  \
    TERM="$TERM"                \
    PS1='(lfs chroot) \u:\w\$ ' \
    PATH=/usr/bin:/usr/sbin     \
    /bin/bash --login
