#!/bin/bash
echo "=== [ LFS Final System Check - by ChatGPT ] ==="
echo

# Tanda status
ok="✅ OK"
fail="❌ ERROR"

# Cek GCC Version
gcc_ver=$(gcc --version | head -n1 | awk '{print $3}')
if [[ "$gcc_ver" == "12.2.0" ]]; then
  echo "[GCC Version] $ok - gcc $gcc_ver"
else
  echo "[GCC Version] $fail - Ditemukan gcc $gcc_ver (seharusnya 12.2.0)"
fi

# Cek glibc dynamic linker
ld_chk=$(readlink -f /lib64/ld-linux-x86-64.so.2)
if [[ "$ld_chk" == "/lib/ld-linux-x86-64.so.2" ]]; then
  echo "[ld-linux] $ok - $ld_chk"
else
  echo "[ld-linux] $fail - Linker tidak sesuai ($ld_chk)"
fi

# Cek apakah ada binary masih tergantung pada /tools
echo -n "[/tools linkage] "
tools_found=$(find /bin /usr/bin /lib /usr/lib -type f -exec ldd {} + 2>/dev/null | grep '/tools')
if [[ -z "$tools_found" ]]; then
  echo "$ok - Tidak ada binary tergantung /tools"
else
  echo "$fail - Masih ada file tergantung /tools:"
  echo "$tools_found"
fi

# Cek dynamic binary contoh
check_dynamic() {
  local file="$1"
  ldd "$file" 2>&1 | grep -q "not a dynamic executable" && \
    echo "[Check $file] ❌ Static binary (not dynamic)" && return

  local linked=$(ldd "$file" | grep -v 'statically linked' | grep -v 'not a dynamic' | grep -v '^$')
  if echo "$linked" | grep -q '/tools'; then
    echo "[Check $file] ❌ Masih tergantung /tools"
  elif [[ -n "$linked" ]]; then
    echo "[Check $file] ✅ Linked dengan benar"
  else
    echo "[Check $file] ❌ Tidak ditemukan dependency"
  fi
}

# Cek binary penting
check_dynamic /bin/bash
check_dynamic /bin/ls
check_dynamic /usr/bin/gcc
check_dynamic /lib/libc.so.6

echo
echo "=== Selesai. Periksa tanda ❌ jika ada masalah. ==="
