#!/bin/bash

# Jalankan sebagai root (atau pakai sudo)
mksquashfs /mnt/lfs live/boot/filesystem.sfs \
    -b 1048576 \
    -comp gzip \
    -e /root/* \
    -e /tmp/* \
    -e /dev/* \
    -e /proc/* \
    -e /sys/* \
    -e /run/* \
    -e /home/*\
    -e /var/* \
    -e /usr/share/doc/* \
    -e /usr/share/info* \
    -e /mnt/* \
    -e /media/*
