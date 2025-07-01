#!/bin/bash

# Dapatkan semua partisi dari /dev/sdb
for part in /dev/sdb?; do
  if [[ -b "$part" ]]; then
    part_num=$(echo "$part" | grep -o '[0-9]*$')
    echo "$part → (hd1,msdos$part_num)"
  fi
done
