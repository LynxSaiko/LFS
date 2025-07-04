#!/bin/bash
# Cek semua tools penting di chroot LFS
# Jalankan dari dalam chroot

TOOLS=(
  bash sh
  gcc g++ ld as
  make cmake
  ldconfig
  mount umount
  grub-install grub-mkconfig
  login getty
  passwd su
  cat ls cp mv rm mkdir
  systemctl init
)

echo "=== [ Cek Tools Utama di Chroot LFS ] ==="
fail=0

for tool in "${TOOLS[@]}"; do
  path=$(command -v "$tool" 2>/dev/null)

  if [ -z "$path" ]; then
    echo "❌ $tool: TIDAK DITEMUKAN"
    ((fail++))
    continue
  fi

  echo -n "🔍 $tool → $path ... "

  if [[ ! -x "$path" ]]; then
    echo "❌ Tidak bisa dieksekusi"
    ((fail++))
    continue
  fi

  # Periksa apakah ELF valid dan tidak tergantung host
  if file "$path" | grep -q "statically linked"; then
    echo "✅ Statik (mandiri)"
  elif ldd "$path" &>/dev/null; then
    echo "✅ Dinamis (cek ldd)"
  else
    echo "⚠️ Tidak dapat dianalisis (bukan ELF?)"
    ((fail++))
  fi
done

echo
echo "=== [ RANGKUMAN ] ==="
if [ "$fail" -eq 0 ]; then
  echo "✅ Semua tool chroot utama ditemukan & valid"
else
  echo "⚠️ Ada $fail tool yang bermasalah atau tidak lengkap"
fi
