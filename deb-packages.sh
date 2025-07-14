#!/bin/bash
# Author: LynxSaiko
# Date: $(date +%F)

set -e
apt update
apt install -y \
    build-essential flex bison gawk texinfo wget \
    python3 tar git gzip bzip2 xz-utils \
    m4 make patch gcc g++ libc6-dev libc6-dev \
    libgmp-dev libmpfr-dev libmpc-dev libncurses-dev
