#!/bin/bash
set -e

echo "[INFO] Mendeteksi partisi root saat ini..."
ROOT_DEV=$(findmnt -n -o SOURCE /)
if [[ ! -e "$ROOT_DEV" ]]; then
    echo "[ERROR] Tidak bisa menemukan partisi root." >&2
    exit 1
fi

echo "[INFO] Root filesystem ada di: $ROOT_DEV"

DISK_DEV=$(lsblk -no PKNAME "$ROOT_DEV")
PART_NUM=$(echo "$ROOT_DEV" | grep -o '[0-9]*$')

DISKS=($(lsblk -ndo NAME,TYPE | awk '$2=="disk"{print $1}'))
GRUB_INDEX=-1
for i in "${!DISKS[@]}"; do
    if [[ "${DISKS[$i]}" == "$DISK_DEV" ]]; then
        GRUB_INDEX=$i
        break
    fi
done

if [[ "$GRUB_INDEX" == "-1" ]]; then
    echo "[ERROR] Tidak bisa menentukan GRUB disk index." >&2
    exit 1
fi

echo
echo "============================================"
echo "GRUB mapping:"
echo "  Linux device: $ROOT_DEV"
echo "  GRUB device : (hd${GRUB_INDEX},msdos${PART_NUM})"
echo "============================================"
echo
echo "Contoh grub.cfg:"
echo "  set root=(hd${GRUB_INDEX},msdos${PART_NUM})"
echo "  linux /boot/vmlinuz-... root=$ROOT_DEV ro"
