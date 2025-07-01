#!/bin/bash

# Nama file dan URL
URL="https://ftp.osuosl.org/pub/lfs/lfs-packages/lfs-packages-11.2.tar"
FILENAME="lfs-packages-11.2.tar"

# Cek apakah sudah ada
if [ -f "$FILENAME" ]; then
  echo "✅ File '$FILENAME' sudah ada. Tidak perlu diunduh ulang."
else
  echo "⬇️  Mengunduh $FILENAME dari $URL..."
  wget --continue "$URL" -O "$FILENAME"

  if [ $? -eq 0 ]; then
    echo "✅ Unduhan selesai: $FILENAME"
  else
    echo "❌ Gagal mengunduh $FILENAME"
    exit 1
  fi
fi

# Tampilkan ukuran file
du -h "$FILENAME"
