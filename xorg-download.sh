#!/bin/bash
# [*] Author: LynxSaiko
# [*] Script untuk mengunduh dan mengekstrak semua file dari daftar URL ke /mnt/lfs/xorg

# Direktori untuk menyimpan file yang diunduh dan diekstrak
DOWNLOAD_DIR="/mnt/lfs/xorg"

# Membuat direktori untuk menyimpan file jika belum ada
mkdir -pv "$DOWNLOAD_DIR"

# Daftar URL yang akan diunduh
urls=(
    "https://github.com/lfs-book/make-ca/releases/download/v1.10/make-ca-1.10.tar.xz"
    "https://ftp.gnu.org/gnu/libtasn1/libtasn1-4.18.0.tar.gz"
    "https://github.com/p11-glue/p11-kit/releases/download/0.24.1/p11-kit-0.24.1.tar.xz"
    "https://www.gnupg.org/ftp/gcrypt/gnutls/v3.7/gnutls-3.7.7.tar.xz"
    "https://ftp.gnu.org/gnu/nettle/nettle-3.8.1.tar.gz"
    "https://ftp.gnu.org/gnu/libunistring/libunistring-1.0.tar.xz"
    "https://ftp.gnu.org/gnu/libidn/libidn-1.41.tar.gz"
    "https://ftp.gnu.org/gnu/libidn/libidn2-2.3.3.tar.gz"
    "http://dist.schmorp.de/libptytty/libptytty-2.0.tar.gz"
    "https://cmake.org/files/v3.24/cmake-3.24.1.tar.gz"
    "https://dist.libuv.org/dist/v1.44.2/libuv-v1.44.2.tar.gz"
    "https://www.linuxfromscratch.org/patches/blfs/11.2/cmake-3.24.1-upstream_fix-1.patch"
    "https://xkbcommon.org/download/libxkbcommon-1.4.1.tar.xz"
    "https://www.x.org/pub/individual/data/xkeyboard-config/xkeyboard-config-2.36.tar.xz"
    "https://xorg.freedesktop.org/archive/individual/lib/libxcb-1.15.tar.xz"
    "https://gitlab.freedesktop.org/wayland/wayland/-/releases/1.21.0/downloads/wayland-1.21.0.tar.xz"
    "https://wayland.freedesktop.org/releases/wayland-protocols-1.26.tar.xz"
    "https://www.freedesktop.org/software/fontconfig/release/fontconfig-2.14.0.tar.xz"
    "https://downloads.sourceforge.net/freetype/freetype-2.12.1.tar.xz"
    "https://github.com/harfbuzz/harfbuzz/releases/download/5.1.0/harfbuzz-5.1.0.tar.xz"
    "https://downloads.sourceforge.net/libpng/libpng-1.6.37.tar.xz"
    "https://downloads.sourceforge.net/sourceforge/libpng-apng/libpng-1.6.37-apng.patch.gz"
    "https://download.gnome.org/sources/libxml2/2.10/libxml2-2.10.0.tar.xz"
    "https://www.w3.org/XML/Test/xmlts20130923.tar.gz"
    "https://download.gnome.org/sources/libxslt/1.1/libxslt-1.1.36.tar.xz"
    "https://github.com/silnrsi/graphite/releases/download/1.3.14/graphite2-1.3.14.tgz"
    "https://downloads.sourceforge.net/libjpeg-turbo/libjpeg-turbo-2.1.4.tar.gz"
    "https://dbus.freedesktop.org/releases/dbus/dbus-1.14.0.tar.xz"
    "https://ftp.gnu.org/gnu/wget/wget-1.21.3.tar.gz"
    "https://www.kernel.org/pub/software/utils/pciutils/pciutils-3.8.0.tar.xz"
    "https://downloads.sourceforge.net/infozip/unzip60.tar.gz"
    "https://www.linuxfromscratch.org/patches/blfs/11.2/unzip-6.0-consolidated_fixes-1.patch"
    "https://downloads.sourceforge.net/infozip/zip30.tar.gz"
    "https://roy.marples.name/downloads/dhcpcd/dhcpcd-9.4.1.tar.xz"
    "https://github.com/llvm/llvm-project/releases/download/llvmorg-14.0.6/llvm-14.0.6.src.tar.xz"
    "https://github.com/llvm/llvm-project/releases/download/llvmorg-14.0.6/clang-14.0.6.src.tar.xz"
    "https://github.com/llvm/llvm-project/releases/download/llvmorg-14.0.6/compiler-rt-14.0.6.src.tar.xz"
    "https://www.linuxfromscratch.org/patches/blfs/11.2/compiler-rt-14.0.6-glibc_2_36-1.patch"
    "https://hewlettpackard.github.io/wireless-tools/wireless_tools.29.tar.gz"
    "https://www.linuxfromscratch.org/patches/blfs/11.2/wireless_tools-29-fix_iwlist_scanning-1.patch"
    "https://w1.fi/releases/wpa_supplicant-2.10.tar.gz"
    "https://github.com/thom311/libnl/releases/download/libnl3_7_0/libnl-3.7.0.tar.gz"
    "https://github.com/thkukuk/libnsl/releases/download/v2.0.0/libnsl-2.0.0.tar.xz"
    "https://www.tcpdump.org/release/libpcap-1.10.1.tar.gz"
    "https://www.x.org/pub/individual/util/util-macros-1.19.3.tar.bz2"
    "https://www.x.org/archive/individual/proto/xorgproto-2024.1.tar.xz"
    "https://www.x.org/pub/individual/lib/libXau-1.0.9.tar.bz2"
    "https://www.x.org/pub/individual/lib/libXdmcp-1.1.3.tar.bz2"
    "https://xorg.freedesktop.org/archive/individual/proto/xcb-proto-1.15.2.tar.xz"
    "https://www.x.org/pub/individual/lib/libxcvt-0.1.2.tar.xz"
    "https://xcb.freedesktop.org/dist/xcb-util-0.4.0.tar.bz2"
    "https://xcb.freedesktop.org/dist/xcb-util-image-0.4.0.tar.bz2"
    "https://xcb.freedesktop.org/dist/xcb-util-0.4.0.tar.bz2"
    "https://xcb.freedesktop.org/dist/xcb-util-keysyms-0.4.0.tar.bz2"
    "https://xcb.freedesktop.org/dist/xcb-util-renderutil-0.3.9.tar.bz2"
    "https://xcb.freedesktop.org/dist/xcb-util-wm-0.4.1.tar.bz2"
    "https://xcb.freedesktop.org/dist/xcb-util-cursor-0.1.3.tar.bz2"
    "https://ftp2.osuosl.org/pub/blfs/conglomeration/MesaLib/mesa-22.1.7.tar.xz"
    "https://www.linuxfromscratch.org/patches/blfs/11.2/mesa-22.1.7-add_xdemos-1.patch"
    "https://dri.freedesktop.org/libdrm/libdrm-2.4.112.tar.xz"
    "https://files.pythonhosted.org/packages/source/M/Mako/Mako-1.2.1.tar.gz"
    "https://www.x.org/pub/individual/data/xbitmaps-1.1.2.tar.bz2"
    "https://www.x.org/pub/individual/data/xkeyboard-config/xkeyboard-config-2.36.tar.xz"
    "https://www.x.org/pub/individual/xserver/xwayland-22.1.3.tar.xz"
    "https://www.cairographics.org/releases/pixman-0.40.0.tar.gz"
    "https://download.gnome.org/sources/libepoxy/1.5/libepoxy-1.5.10.tar.xz"
    "https://downloads.sourceforge.net/libtirpc/libtirpc-1.3.3.tar.bz2"
    "https://www.x.org/pub/individual/xserver/xorg-server-21.1.4.tar.xz"
    "https://www.freedesktop.org/software/libevdev/libevdev-1.13.0.tar.xz"
    "https://www.x.org/pub/individual/driver/xf86-input-evdev-2.10.6.tar.bz2"
    "https://gitlab.freedesktop.org/libinput/libinput/-/archive/1.21.0/libinput-1.21.0.tar.gz"
    "https://www.x.org/pub/individual/driver/xf86-input-libinput-1.2.1.tar.xz"
    "https://www.x.org/pub/individual/driver/xf86-input-synaptics-1.9.2.tar.xz"
    "https://github.com/linuxwacom/xf86-input-wacom/releases/download/xf86-input-wacom-1.1.0/xf86-input-wacom-1.1.0.tar.bz2"
    "https://anduin.linuxfromscratch.org/BLFS/xf86-video-intel/xf86-video-intel-20210222.tar.xz"
    "https://invisible-mirror.net/archives/xterm/xterm-372.tgz"
    "https://www.x.org/pub/individual/app/xclock-1.1.1.tar.xz"
    "https://www.x.org/pub/individual/app/xinit-1.4.1.tar.bz2"
    "https://ftp.gnu.org/gnu/nano/nano-5.9.tar.xz"
    "https://github.com/seccomp/libseccomp/releases/download/v2.5.4/libseccomp-2.5.4.tar.gz"
)

# Unduh file-file menggunakan wget
for url in "${urls[@]}"; do
    echo "Downloading $url ..."
    wget -P "$DOWNLOAD_DIR" "$url"
    
    # Mengekstrak file berdasarkan format
    if [[ "$url" =~ \.tar\.gz$ ]]; then
        tar -xvzf "$DOWNLOAD_DIR/$(basename $url)" -C "$DOWNLOAD_DIR"
    elif [[ "$url" =~ \.tar\.xz$ ]]; then
        tar -xvJf "$DOWNLOAD_DIR/$(basename $url)" -C "$DOWNLOAD_DIR"
    elif [[ "$url" =~ \.tgz$ ]]; then
        tar -xvzf "$DOWNLOAD_DIR/$(basename $url)" -C "$DOWNLOAD_DIR"
    elif [[ "$url" =~ \.bz2$ ]]; then
        tar -xvjf "$DOWNLOAD_DIR/$(basename $url)" -C "$DOWNLOAD_DIR"
    fi
done

echo "[+] All downloads and extractions complete!"
