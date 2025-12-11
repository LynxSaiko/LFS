#!/bin/sh

xorriso -as mkisofs \
  -volid "MYOWNLIVE" \
  -isohybrid-mbr /home/leakos/live/isolinux/isohdpfx.bin \
  -b isolinux/isolinux.bin \
  -no-emul-boot \
  -boot-load-size 4 \
  -boot-info-table \
  -iso-level 3 \
  -rock \
  -joliet \
  -partition_offset 16 \
  --allow-limited-size \
  -o MyOwnLinuxLiveCD.iso \
  /home/leakos/live
