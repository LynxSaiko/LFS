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
