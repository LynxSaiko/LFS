#!/bin/bash

# Masuk ke direktori sources
cd /sources || { echo "/sources tidak ditemukan!"; exit 1; }

# Daftar URL
URLS=(
  "https://ftp.gnu.org/gnu/libtasn1/libtasn1-4.18.0.tar.gz"
  "https://ftp.gnu.org/gnu/gmp/gmp-6.3.0.tar.xz"
  "https://ftp.gnu.org/gnu/nettle/nettle-3.9.1.tar.gz"
  "https://ftp.gnu.org/gnu/gnutls/gnutls-3.8.3.tar.xz"
)

# Download semua file
for url in "${URLS[@]}"; do
  echo "Downloading: $url"
  curl -LO "$url"
done

# Ekstrak semua file yang sudah diunduh
for file in *.tar.*; do
  echo "Extracting: $file"
  case $file in
    *.tar.gz)  tar -xvf "$file" ;;
    *.tar.xz)  tar -xvf "$file" ;;
    *) echo "Unknown format: $file" ;;
  esac
done

echo "Download dan ekstraksi selesai!"
