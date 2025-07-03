#!/bin/bash
# [+] Cek File Penting LFS + Daftar Paket yang Harus Direbuild
# [+] Author: LynxSaiko

set -e

LFS=${LFS:-/mnt/lfs}
OUTPUT="$LFS/sources/logs/cek-penting.log"
mkdir -p "$(dirname "$OUTPUT")"
> "$OUTPUT"

# === Daftar file yang diperiksa ===
declare -A FILE_PAKET=(
  ["$LFS/bin/bash"]="bash"
  ["$LFS/bin/ls"]="coreutils"
  ["$LFS/bin/cp"]="coreutils"
  ["$LFS/bin/login"]="shadow"
  ["$LFS/sbin/init"]="sysvinit"
  ["$LFS/lib/libc.so.6"]="glibc"
  ["$LFS/lib/ld-linux-x86-64.so.2"]="glibc"
)

echo "[+] Mulai cek file penting untuk kontaminasi..."

# === Fungsi Cek Kontaminasi Per File ===
for file in "${!FILE_PAKET[@]}"; do
    if [ ! -f "$file" ]; then
        echo "[!] File hilang: $file (${FILE_PAKET[$file]})" | tee -a "$OUTPUT"
        continue
    fi

    strings "$file" | grep -E '/usr|/bin|/lib' >/dev/null && {
        echo "[!] Terkontaminasi: $file (${FILE_PAKET[$file]})" | tee -a "$OUTPUT"
    }

    interp=$(readelf -l "$file" 2>/dev/null | grep interpreter | awk '{print $NF}')
    if [[ "$interp" == */usr/* ]]; then
        echo "[!] Interpreter host: $file ➔ $interp (${FILE_PAKET[$file]})" | tee -a "$OUTPUT"
    fi
done

echo
if [ -s "$OUTPUT" ]; then
    echo "[!] Potensi kontaminasi terdeteksi:"
    cat "$OUTPUT" | sort | uniq

    echo
    echo "👉 Rekomendasi rebuild paket:"

    # Ambil nama paket yang harus direbuild (tanpa duplikat)
    awk '{print $NF}' "$OUTPUT" | sort | uniq | while read paket; do
        echo "- $paket"
    done
else
    echo "[✓] Semua file penting bersih dari kontaminasi."
fi
