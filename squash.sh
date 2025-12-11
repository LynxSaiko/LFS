#!/bin/bash

# Jalankan sebagai root (atau pakai sudo)
sudo mksquashfs / live/boot/filesystem.sfs \
    -comp gzip -Xcompression-level 22 \
    -wildcards \
    -e dev/* proc/* sys/* run/* tmp/* \
       root/* tools/* home/* lost+found \
       usr/share/doc/* usr/share/info/* usr/share/man \
       mnt/* /media/* \
       var/cache/* var/log/* var/tmp/*
