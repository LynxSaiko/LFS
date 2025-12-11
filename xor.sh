#!/bin/sh

xorriso -as mkisofs \
    -isohybrid-mbr syslinux-6.03/bios/mbr/isohdpfx.bin \
    -c isolinux/boot.cat \
    -b isolinux/isolinux.bin \
    -no-emul-boot \
    -boot-load-size 4 \
    -boot-info-table \
    -eltorito-alt-boot \
    -no-emul-boot \
    -isohybrid-gpt-basdat \
    -volid LIVECD \
    -o MyOwnLinuxLiveCD.iso live
