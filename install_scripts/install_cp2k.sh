#!/bin/bash

cd /benchmarks

# Install Spack

git clone https://github.com/spack/spack.git spack
patch -p1 -dspack < spack.patch

# Alternatively, a released version:
#curl -OL https://github.com/spack/spack/releases/download/v0.12.1/spack-0.12.1.tar.gz
#tar xaf spack-0.12.1.tar.gz
#ln -s spack-0.12.1 spack

. /etc/profile.d/modules.sh
. spack/share/spack/setup-env.sh

#export SPACK_TARGET_TYPE="x86_64_avx"

# Install openblas devel version, 0.3.5 AVX-512 kernels are b0rken
# Unfortunately, so are 0.3.6dev AVX-512 kernels as of 2019-02-25.
#spack install cp2k@6.1 ^openblas@develop
# In spack.patch we disable AVX-512 kernels and build 0.3.5
spack install cp2k@6.1
