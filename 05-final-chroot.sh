#!/bin/bash
# [+] Author: LynxSaiko

package_name=""
package_ext=""

begin() {
	package_name=$1
	package_ext=$2

	echo "[lfs-final] Starting build of $package_name at $(date)"

	tar xf $package_name.$package_ext
	cd $package_name
}

finish() {
	echo "[lfs-final] Finishing build of $package_name at $(date)"

	cd /sources
	rm -rf $package_name
}

cd /sources
#install lfs-bootscripts
cd lfs-bootscripts-20220723
make install
finish

echo "[*] Custom Udev [*]"
# 9.4.1.2. Creating Custom Udev Rules
bash /usr/lib/udev/init-net-rules.sh

echo "[*] Creating Network [*]"
# 9.5.1. Creating Network Interface Configuration Files
cd /etc/sysconfig/
cat > ifconfig.wlan0 << "EOF"
ONBOOT=yes
IFACE=wlan0
SERVICE=ipv4-static
IP=192.168.1.2
GATEWAY=192.168.1.1
PREFIX=24
BROADCAST=192.168.1.255
EOF

echo "[*] Creating Resolv [*]"
# 9.5.2. Creating the /etc/resolv.conf File
cat > /etc/resolv.conf << "EOF"
# Begin /etc/resolv.conf

nameserver 8.8.8.8
nameserver 8.8.4.4

# End /etc/resolv.conf
EOF

echo "[*] Configure System Host [*]"
# 9.5.3. Configuring the system hostname
echo "leakos" > /etc/hostname

# 9.5.4. Customizing the /etc/hosts File
cat > /etc/hosts << "EOF"
# Begin /etc/hosts

127.0.0.1 localhost.localdomain localhost
::1       localhost ip6-localhost ip6-loopback
ff02::1   ip6-allnodes
ff02::2   ip6-allrouters

# End /etc/hosts
EOF

echo "[*] Configure SysVinit [*]"
# 9.6.2. Configuring Sysvinit
cat > /etc/inittab << "EOF"
# Begin /etc/inittab

id:3:initdefault:

si::sysinit:/etc/rc.d/init.d/rc S

l0:0:wait:/etc/rc.d/init.d/rc 0
l1:S1:wait:/etc/rc.d/init.d/rc 1
l2:2:wait:/etc/rc.d/init.d/rc 2
l3:3:wait:/etc/rc.d/init.d/rc 3
l4:4:wait:/etc/rc.d/init.d/rc 4
l5:5:wait:/etc/rc.d/init.d/rc 5
l6:6:wait:/etc/rc.d/init.d/rc 6

ca:12345:ctrlaltdel:/sbin/shutdown -t1 -a -r now

su:S016:once:/sbin/sulogin

1:2345:respawn:/sbin/agetty --noclear tty1 9600 linux
2:2345:respawn:/sbin/agetty tty2 9600 linux
3:2345:respawn:/sbin/agetty tty3 9600 linux
4:2345:respawn:/sbin/agetty tty4 9600 linux
5:2345:respawn:/sbin/agetty tty5 9600 linux
6:2345:respawn:/sbin/agetty tty6 9600 linux

# End /etc/inittab
EOF

echo "[*] Configure System Clock [*]"
# 9.6.4. Configuring the System Clock
cat > /etc/sysconfig/clock << "EOF"
# Begin /etc/sysconfig/clock

UTC=1

# Set this to any options you might need to give to hwclock,
# such as machine hardware clock type for Alphas.
CLOCKPARAMS=

# End /etc/sysconfig/clock
EOF

echo "[*] Setting Bash Shell [*]"
# 9.7. The Bash Shell Startup Files
cat > /etc/profile << "EOF"
# Begin /etc/profile

export LANG=en_US.UTF-8

# End /etc/profile
EOF

echo "[*] Create Inputrc [*]"
# 9.8. Creating the /etc/inputrc File
cat > /etc/inputrc << "EOF"
# Begin /etc/inputrc
# Modified by Chris Lynn <roryo@roryo.dynup.net>

# Allow the command prompt to wrap to the next line
set horizontal-scroll-mode Off

# Enable 8bit input
set meta-flag On
set input-meta On

# Turns off 8th bit stripping
set convert-meta Off

# Keep the 8th bit for display
set output-meta On

# none, visible or audible
set bell-style none

# All of the following map the escape sequence of the value
# contained in the 1st argument to the readline specific functions
"\eOd": backward-word
"\eOc": forward-word

# for linux console
"\e[1~": beginning-of-line
"\e[4~": end-of-line
"\e[5~": beginning-of-history
"\e[6~": end-of-history
"\e[3~": delete-char
"\e[2~": quoted-insert

# for xterm
"\eOH": beginning-of-line
"\eOF": end-of-line

# for Konsole
"\e[H": beginning-of-line
"\e[F": end-of-line

# End /etc/inputrc
EOF

echo "[*] Create Shells [*]"
# 9.9. Creating the /etc/shells File
cat > /etc/shells << "EOF"
# Begin /etc/shells

/bin/sh
/bin/bash

# End /etc/shells
EOF

echo "[*] Create Fstab [*]"
# 10.2. Creating the /etc/fstab File
cat > /etc/fstab << "EOF"
# Begin /etc/fstab

# file system  mount-point  type     options             dump  fsck
#                                                              order

/dev/sda2       /           ext4     defaults            1     1
proc           /proc        proc     nosuid,noexec,nodev 0     0
sysfs          /sys         sysfs    nosuid,noexec,nodev 0     0
devpts         /dev/pts     devpts   gid=5,mode=620      0     0
tmpfs          /run         tmpfs    defaults            0     0
devtmpfs       /dev         devtmpfs mode=0755,nosuid    0     0

# End /etc/fstab
EOF

echo "[*] Config Linux & Grub [*]"
cd /sources
# mv .config /sources/linux-5.19.2/
# 10.3. Linux-5.10.195
begin linux-5.10.195 tar.xz
make mrproper
make olddefconfig
make -j$(nproc)
make modules
make modules_install
cp -iv arch/x86/boot/bzImage /boot/vmlinuz-leakos
cp -iv System.map /boot/System.map-5.10.195
cp -iv .config /boot/config-5.10.195
install -d /usr/share/doc/linux-5.10.195
finish

cat > /boot/grub/grub.cfg << "EOF"
set default=0
set timeout=5

menuentry "LeakOS V1 (Shadow Edition)" {
    linux /boot/vmlinuz-leakos root=/dev/sda2 ro
}
EOF
grub-install /dev/sda

echo "[*] Config Modprobe [*]"
# 10.3.2. Configuring Linux Module Load Order
install -v -m755 -d /etc/modprobe.d
cat > /etc/modprobe.d/usb.conf << "EOF"
# Begin /etc/modprobe.d/usb.conf

install ohci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i ohci_hcd ; true
install uhci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i uhci_hcd ; true

# End /etc/modprobe.d/usb.conf
EOF

echo "[*] Config Os-release [*]"
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


echo "[lfs-final] The end"
