#!/bin/bash
umount -l /mnt/lfs/{dev,proc,sys,run}/dev/pts
umount -l /mnt/lfs/{dev,proc,sys,run}/dev
umount -l /mnt/lfs/{dev,proc,sys,run}/proc
umount -l /mnt/lfs/{dev,proc,sys,run}/sys
umount -l /mnt/lfs/{dev,proc,sys,run}/run
