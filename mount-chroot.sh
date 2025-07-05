#!/bin/bash
mknod -m 600 $LFS/dev/console c 5 1 || true
mknod -m 666 $LFS/dev/null c 1 3 || true
mknod -m 666 $LFS/dev/zero c 1 5 || true
mknod -m 622 $LFS/dev/tty c 5 0 || true
chown root:tty $LFS/dev/console $LFS/dev/tty || true

mount -v --bind /dev $LFS/dev
mount -v --bind /dev/pts $LFS/dev/pts
mount -vt proc proc $LFS/proc
mount -vt sysfs sysfs $LFS/sys
mount -vt tmpfs tmpfs $LFS/run
if [ -h $LFS/dev/shm ]; then
  mkdir -pv $LFS/$(readlink $LFS/dev/shm)
fi
chroot "$LFS" /usr/bin/env -i   \
    HOME=/root                  \
    TERM="$TERM"                \
    PS1='(lfs chroot) \u:\w\$ ' \
    PATH=/usr/bin:/usr/sbin     \
    /bin/bash --login +h
