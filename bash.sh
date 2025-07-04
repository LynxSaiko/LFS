#!/bin/bash
LFS=/mnt/lfs
ROOTDIR=$LFS/root

cat > ~/.bashrc << "EOF"
set +h
umask 022
LFS=/mnt/lfs
LC_ALL=POSIX
LFS_TGT=$(uname -m)-lfs-linux-gnu
PATH=/usr/bin
if [ ! -L /bin ]; then PATH=/bin:$PATH; fi
PATH=$LFS/tools/bin:$PATH
CONFIG_SITE=$LFS/usr/share/config.site
export LFS LC_ALL LFS_TGT PATH CONFIG_SITE
EOF

cat > ~/.bash_profile << "EOF"
exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash
EOF

source ~/.bashrc


echo "[+] Membuat /root/.bash_profile..."
cat > $ROOTDIR/.bash_profile << "EOF"
exec env -i HOME=/root TERM=$TERM PS1='(lfs) \u:\w\$ ' /bin/bash --login
EOF

echo "[+] Membuat /root/.bashrc..."
cat > $ROOTDIR/.bashrc << "EOF"
set +h
umask 022
LFS=/mnt/lfs
LC_ALL=POSIX
LFS_TGT=$(uname -m)-lfs-linux-gnu
export LFS LC_ALL LFS_TGT PATH MAKEFLAGS
EOF
