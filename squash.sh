#!/bin/bash

# Jalankan sebagai root (atau pakai sudo)
sudo mksquashfs / live/boot/filesystem.sfs \
    -comp gzip -Xcompression-level 9 -b 1M \
    -no-xattrs -noappend \
    -wildcards \
    -e dev/* proc/* sys/* run/* tmp/* \
       root/* tools/* lost+found var/* mnt/* media/* \
       boot/vmlinuz* boot/initrd* boot/System.map* boot/config* \
       \
       .cache npm .npm node_modules .git .nvm .yarn \
       .node-gyp pip_cache \
       home/*/.cache home/*/.npm home/*/.node-gyp \
       home/*/.nvm home/*/node_modules home/*/.git \
       home/*/.yarn home/*/.pip_cache \
       root/.cache root/.npm root/node_modules root/.git
