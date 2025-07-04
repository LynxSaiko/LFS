cat > /boot/grub/grub.cfg << "EOF"
set default=0
set timeout=5
insmod ext2
set root=(hd0,2)
menuentry "LeakOS LFS 5.19.2" {
    linux /boot/vmlinuz-leakos root=/dev/sda1 ro
}
EOF
