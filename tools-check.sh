#!/bin/bash
# [+] Skrip Cek Kontaminasi /tools Langsung di Terminal
# [+] Author: LynxSaiko

set -e

# === Variabel Dasar ===
LFS=${LFS:-/mnt/lfs}
TOOLS_DIR="$LFS/tools"

echo "[+] Memulai pengecekan kontaminasi di $TOOLS_DIR"
echo

kontaminasi_ditemukan=0

# === Cek ELF Files ===
find "$TOOLS_DIR" -type f -exec file {} \; | grep ELF | awk -F: '{print $1}' | while read file; do
    if strings "$file" | grep -qE '/usr|/lib'; then
        echo "[!] Kontaminasi PATH ditemukan di: $file"
        kontaminasi_ditemukan=1
    fi

    interp=$(readelf -l "$file" 2>/dev/null | grep interpreter | awk '{print $NF}')
    if [[ "$interp" == */usr/* ]]; then
        echo "[!] Interpreter host ditemukan di: $file ➔ $interp"
        kontaminasi_ditemukan=1
    fi
done

# === Cek Dynamic Linker (ldd) ===
find "$TOOLS_DIR" -type f -executable | while read exe; do
    if ldd "$exe" 2>/dev/null | grep -qE '/usr|/lib'; then
        echo "[!] LDD host link ditemukan di: $exe"
        kontaminasi_ditemukan=1
    fi
done

# === Hasil Akhir ===
echo
if [ "$kontaminasi_ditemukan" -eq 1 ]; then
    echo "🚨 [!] Potensi kontaminasi TERDETEKSI di $TOOLS_DIR!"
    echo "👉 Solusi: Build ulang minimal binutils, gcc, glibc (Bab 5)"
else
    echo "✅ [✓] /tools bersih dari kontaminasi host."
fi
