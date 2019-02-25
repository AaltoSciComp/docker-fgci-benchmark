#!/bin/bash

cd /benchmarks

# Install Spack

git clone https://github.com/spack/spack.git spack
patch -p0 < spack.patch

# Alternatively, a released version:
#curl -OL https://github.com/spack/spack/releases/download/v0.12.1/spack-0.12.1.tar.gz
#tar xaf spack-0.12.1.tar.gz
#ln -s spack-0.12.1 spack

. /etc/profile.d/modules.sh
. spack/share/spack/setup-env.sh

#export SPACK_TARGET_TYPE="x86_64_avx"

spack install cp2k@6.1
