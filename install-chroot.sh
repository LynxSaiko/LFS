#!/bin/bash

package_name=""
package_ext=""

begin() {
	package_name=$1
	package_ext=$2

	echo "[lfs-chroot] Starting build of $package_name at $(date)"

	tar xf $package_name.$package_ext
	cd $package_name
}

finish() {
	echo "[lfs-chroot] Finishing build of $package_name at $(date)"

	cd /sources
	rm -rf $package_name
}

cd /sources

# 7.7. Gettext-0.21
begin gettext-0.21 tar.xz
./configure --disable-shared
make
cp -v gettext-tools/src/{msgfmt,msgmerge,xgettext} /usr/bin
finish

# 7.8. Bison-3.8.2
begin bison-3.8.2 tar.xz
./configure --prefix=/usr \
            --docdir=/usr/share/doc/bison-3.8.2
make
make install
finish

# 7.9. Perl-5.36.0
begin perl-5.36.0 tar.xz
sh Configure -des                                        \
             -Dprefix=/usr                               \
             -Dvendorprefix=/usr                         \
             -Dprivlib=/usr/lib/perl5/5.36/core_perl     \
             -Darchlib=/usr/lib/perl5/5.36/core_perl     \
             -Dsitelib=/usr/lib/perl5/5.36/site_perl     \
             -Dsitearch=/usr/lib/perl5/5.36/site_perl    \
             -Dvendorlib=/usr/lib/perl5/5.36/vendor_perl \
             -Dvendorarch=/usr/lib/perl5/5.36/vendor_perl
make
make install
finish

# 7.10. Python-3.10.6
begin Python-3.10.6 tar.xz
./configure --prefix=/usr            \
            --enable-shared          \
            --with-system-expat      \
            --with-system-ffi        \
            --enable-optimizations

make -j$(nproc)
make install
# pip config (optional)
mkdir -pv /etc
cat > /etc/pip.conf << EOF
[global]
disable-pip-version-check = true
root-user-action = ignore
EOF
# Symlink eksplisit
ln -sfv /usr/bin/python3
ln -sfv /usr/bin/pip3
finish


echo "[python2] Configuring..."
begin Python-2.7.18.tar.xz
./configure --prefix=/usr              \
            --enable-shared            \
            --with-system-expat        \
            --with-system-ffi          \
            --enable-unicode=ucs4      \
            --with-ensurepip=yes

make -j$(nproc)
make install
ln -sfv /usr/bin/python2
ln -sfv /usr/bin/pip2
finish

echo "[ruby2] Configuring..."
begin ruby-2.7.8.tar.gz
./configure --prefix=/usr --program-suffix=2.7 --disable-install-doc
make -j$(nproc)
make install
finish

echo "[ruby3] Configuring..."
begin ruby-3.3.0.tar.gz
./configure --prefix=/usr --program-suffix=3.3 --disable-install-doc
make -j$(nproc)
make install
finish


# Symlink untuk ruby2 & ruby3
ln -sfv /usr/bin/ruby2.7 /usr/bin/ruby2
ln -sfv /usr/bin/gem2.7  /usr/bin/gem2
ln -sfv /usr/bin/irb2.7  /usr/bin/irb2

ln -sfv /usr/bin/ruby3.3 /usr/bin/ruby3
ln -sfv /usr/bin/gem3.3  /usr/bin/gem3
ln -sfv /usr/bin/irb3.3  /usr/bin/irb3
# 7.11. Texinfo-6.8

echo "texinfo"
begin texinfo-6.8 tar.xz
./configure --prefix=/usr
make
make install
finish

# 7.12. Util-linux-2.38.1
begin util-linux-2.38.1 tar.xz
mkdir -pv /var/lib/hwclock
./configure ADJTIME_PATH=/var/lib/hwclock/adjtime    \
            --libdir=/usr/lib    \
            --docdir=/usr/share/doc/util-linux-2.38.1 \
            --disable-chfn-chsh  \
            --disable-login      \
            --disable-nologin    \
            --disable-su         \
            --disable-setpriv    \
            --disable-runuser    \
            --disable-pylibmount \
            --disable-static     \
            --without-python     \
            runstatedir=/run
make
make install
finish

