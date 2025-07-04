#!/bin/sh
########################################################################
# Begin /etc/rc.d/rc.sysinit
#
# Based on sysvinit-2.88dsf and LFS-Bootscripts-20210608
########################################################################

# Mount proc and sysfs
/bin/mount -n -t proc proc /proc
/bin/mount -n -t sysfs sysfs /sys

# Set kernel message logging level
/bin/dmesg -n 1

# Create initial device nodes
/bin/mount -n -t devtmpfs devtmpfs /dev

# Populate /dev
/bin/udevd --daemon
/bin/udevadm trigger --type=subsystems --action=add
/bin/udevadm trigger --type=devices --action=add
/bin/udevadm settle

# Create pseudo terminal devices
/bin/mkdir -p /dev/pts
/bin/mkdir -p /dev/shm
/bin/mount -n -t devpts devpts /dev/pts
/bin/mount -n -t tmpfs tmpfs /dev/shm

# Remount root as rw if needed
/bin/mount -n -o remount,rw /

# Set hostname
if [ -f /etc/hostname ]; then
    HOSTNAME=$(cat /etc/hostname)
    /bin/hostname "$HOSTNAME"
fi

# Activate swap
/sbin/swapon -a

# Set system clock
if [ -x /etc/rc.d/init.d/setclock ]; then
    /etc/rc.d/init.d/setclock start
fi

# Clean up /run
/bin/rm -rf /run/*
/bin/mkdir -p /run/lock

# Mount tmpfs on /run
/bin/mount -n -t tmpfs tmpfs /run

# Done
exit 0

########################################################################
# End /etc/rc.d/rc.sysinit
########################################################################
