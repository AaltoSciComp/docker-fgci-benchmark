#!/bin/bash

cd /benchmarks

# Install Spack

git clone https://github.com/spack/spack.git spack

. spack/share/spack/setup-env.sh

spack install cp2k
