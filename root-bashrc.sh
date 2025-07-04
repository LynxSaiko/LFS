#!/bin/bash
# [+] Setup .bashrc dan .bash_profile untuk root chroot di /mnt/lfs/root
# [+] By LynxSaiko

LFS=/mnt/lfs
ROOTDIR=$LFS/root

echo "[+] Membuat /root/.bash_profile..."
cat > $ROOTDIR/.bash_profile << "EOF"
exec env -i HOME=/root TERM=$TERM PS1='(lfs) \u:\w\$ ' /bin/bash --login
EOF

echo "[+] Membuat /root/.bashrc..."
cat > $ROOTDIR/.bashrc << "EOF"
set +h
umask 022
export LFS LC_ALL LFS_TGT PATH MAKEFLAGS
EOF
