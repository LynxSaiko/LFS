#!/bin/bash
# [*] Author: Red Team
# [*] Script to check if LFS toolchain in /tools is contaminated by host system (e.g., Debian)

set -e

# Define LFS root directory and target triplet
LFS=/mnt/lfs
LFS_TGT=$(uname -m)-lfs-linux-gnu

# Ensure we're in chroot and checking the correct environment
if [ ! -d "$LFS" ]; then
    echo "Error: LFS root directory '$LFS' does not exist. Please set the correct LFS path."
    exit 1
fi

echo "[+] Checking if /tools is contaminated by host system..."

# Check if any binaries in /tools are from host system (Debian or other)
echo "[+] Checking binaries in /tools/bin..."
for bin in $LFS/tools/bin/*; do
    if [ -x "$bin" ]; then
        # Get the file's linked libraries (if any)
        ldd_output=$(ldd $bin 2>/dev/null)
        
        # Check if any library is linked to the host system
        if echo "$ldd_output" | grep -q "/lib"; then
            echo "[WARNING] Binary $bin is linked to system libraries (may be from host system)"
        fi

        # Check for the binary's file metadata (like file owner)
        file_owner=$(ls -l $bin | awk '{print $3}')
        if [[ "$file_owner" != "root" ]]; then
            echo "[WARNING] Binary $bin has non-root ownership: $file_owner"
        fi
    fi
done

# Check if any libraries in /tools/lib64 are linked to host system libraries
echo "[+] Checking libraries in /tools/lib64..."
for lib in $LFS/tools/lib64/*; do
    if [ -f "$lib" ]; then
        # Check if any library is linked to the host system
        ldd_output=$(ldd $lib 2>/dev/null)
        
        if echo "$ldd_output" | grep -q "/lib"; then
            echo "[WARNING] Library $lib is linked to system libraries (may be from host system)"
        fi
    fi
done

# Check if any headers in /tools/include are from host system
echo "[+] Checking headers in /tools/include..."
for header in $LFS/tools/include/*; do
    if [ -f "$header" ]; then
        # Check if the file matches known system headers
        if grep -q "Debian" "$header"; then
            echo "[WARNING] Header file $header appears to be from the host system (Debian)"
        fi
    fi
done

# Check if any files in /tools are from the host system based on ownership and group
echo "[+] Checking file ownership and group in /tools..."
for file in $(find $LFS/tools -type f); do
    owner=$(ls -l $file | awk '{print $3}')
    group=$(ls -l $file | awk '{print $4}')
    
    if [[ "$owner" != "root" ]] || [[ "$group" != "root" ]]; then
        echo "[WARNING] File $file has non-root ownership or group: Owner=$owner, Group=$group"
    fi
done

echo "[+] Check complete. Please review warnings above for contamination indications."
