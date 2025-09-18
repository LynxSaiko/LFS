#!/bin/bash
# Extract SeaMonkey source
tar -xvf seamonkey-2.53.13.source.tar.xz
cd seamonkey-2.53.13

# Create mozconfig file
cat > mozconfig << "EOF"
# Default configuration file for SeaMonkey build
ac_add_options --disable-dbus
ac_add_options --disable-necko-wifi
#ac_add_options --enable-system-hunspell
#ac_add_options --enable-startup-notification
#ac_add_options --disable-pulseaudio
#ac_add_options --enable-alsa
ac_add_options --disable-gconf
ac_add_options --with-system-icu
ac_add_options --with-system-libevent
ac_add_options --with-system-nspr
ac_add_options --with-system-nss
ac_add_options --with-system-webp
ac_add_options --disable-debug-symbols
ac_add_options --disable-elf-hack
ac_add_options --enable-calendar
ac_add_options --enable-dominspector
ac_add_options --enable-irc
ac_add_options --prefix=/usr
ac_add_options --enable-application=comm/suite
ac_add_options --disable-crashreporter
ac_add_options --disable-updater
ac_add_options --disable-tests
ac_add_options --disable-rust-simd
ac_add_options --enable-optimize="-O2"
ac_add_options --enable-strip
ac_add_options --enable-install-strip
ac_add_options --enable-official-branding
ac_add_options --enable-system-ffi
ac_add_options --enable-system-pixman
ac_add_options --with-system-bz2
ac_add_options --with-system-jpeg
ac_add_options --with-system-png
ac_add_options --with-system-zlib
EOF

# Configure the build environment using clang
export CC=clang CXX=clang++
./mach configure

# Build SeaMonkey
./mach build

# Install SeaMonkey
sudo ./mach install

# Set correct permissions
sudo chown -R 0:0 /usr/lib/seamonkey

# Install man page
sudo cp -v $(find -name seamonkey.1 | head -n1) /usr/share/man/man1

# Create desktop entry for SeaMonkey
sudo mkdir -pv /usr/share/{applications,pixmaps}
cat > /usr/share/applications/seamonkey.desktop << "EOF"
[Desktop Entry]
Encoding=UTF-8
Type=Application
Name=SeaMonkey
Comment=The Mozilla Suite
Icon=seamonkey
Exec=seamonkey
Categories=Network;GTK;Application;Email;Browser;WebBrowser;News;
StartupNotify=true
Terminal=false
EOF

# Link icon
sudo ln -sfv /usr/lib/seamonkey/chrome/icons/default/default128.png /usr/share/pixmaps/seamonkey.png

# Done
echo "SeaMonkey installation completed!"
