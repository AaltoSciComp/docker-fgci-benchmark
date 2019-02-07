#!/bin/bash

cd /benchmarks

# Install Spack

git clone https://github.com/spack/spack.git spack

. spack/share/spack/setup-env.sh

#export SPACK_TARGET_TYPE="x86_64_avx"

spack install cp2k@6.1
