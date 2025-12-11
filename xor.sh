#!/bin/sh

xorriso -as mkisofs \
  -volid "MYOWNLIVE" \
  -isohybrid-mbr /home/leakos/live/isolinux/isohdpfx.bin \
  -b isolinux/isolinux.bin \
  -no-emul-boot \
  -boot-load-size 4 \
  -boot-info-table \
  -o MyOwnLinuxLiveCD.iso \
  /home/leakos/live
