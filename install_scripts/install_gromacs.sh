#!/bin/bash

# Obtain Gromacs ZIP
cd /tmp &&
wget ftp://ftp.gromacs.org/pub/gromacs/gromacs-5.1.4.tar.gz

# Install Gromacs with SSE2
tar xzf gromacs-5.1.4.tar.gz && \
cd gromacs-5.1.4 && \
mkdir build && \
cd build && \
cmake \
        -DCMAKE_INSTALL_PREFIX=/benchmarks/gromacs-sse2/ \
        -DBUILD_SHARED_LIBS=off \
        -DBUILD_TESTING=off \
        -DREGRESSIONTEST_DOWNLOAD=OFF \
        -DCMAKE_C_COMPILER=`which mpicc` \
        -DCMAKE_CXX_COMPILER=`which mpicxx` \
        -DGMX_BUILD_OWN_FFTW=on \
        -DGMX_SIMD=SSE2 \
        -DGMX_DOUBLE=off \
        -DGMX_EXTERNAL_BLAS=off \
        -DGMX_EXTERNAL_LAPACK=off \
        -DGMX_FFT_LIBRARY=fftw3 \
        -DGMX_GPU=off \
        -DGMX_MPI=on \
        -DGMX_OPENMP=on \
        -DGMX_X11=off \
        .. && \
make -j 4 && \
make install

# Clean up build directory
cd /tmp && \
rm -rf gromacs-5.1.4

# Install Gromacs with SSE 4.1
tar xzf gromacs-5.1.4.tar.gz && \
cd gromacs-5.1.4 && \
mkdir build && \
cd build && \
cmake \
        -DCMAKE_INSTALL_PREFIX=/benchmarks/gromacs-sse4.1/ \
        -DBUILD_SHARED_LIBS=off \
        -DBUILD_TESTING=off \
        -DREGRESSIONTEST_DOWNLOAD=OFF \
        -DCMAKE_C_COMPILER=`which mpicc` \
        -DCMAKE_CXX_COMPILER=`which mpicxx` \
        -DGMX_BUILD_OWN_FFTW=on \
        -DGMX_SIMD=SSE4.1 \
        -DGMX_DOUBLE=off \
        -DGMX_EXTERNAL_BLAS=off \
        -DGMX_EXTERNAL_LAPACK=off \
        -DGMX_FFT_LIBRARY=fftw3 \
        -DGMX_GPU=off \
        -DGMX_MPI=on \
        -DGMX_OPENMP=on \
        -DGMX_X11=off \
        .. && \
make -j 4 && \
make install

# Clean up build directory
cd /tmp && \
rm -rf gromacs-5.1.4

# Install Gromacs with 256-bit AVX
tar xzf gromacs-5.1.4.tar.gz && \
cd gromacs-5.1.4 && \
mkdir build && \
cd build && \
cmake \
        -DCMAKE_INSTALL_PREFIX=/benchmarks/gromacs-avx256/ \
        -DBUILD_SHARED_LIBS=off \
        -DBUILD_TESTING=off \
        -DREGRESSIONTEST_DOWNLOAD=OFF \
        -DCMAKE_C_COMPILER=`which mpicc` \
        -DCMAKE_CXX_COMPILER=`which mpicxx` \
        -DGMX_BUILD_OWN_FFTW=on \
        -DGMX_SIMD=AVX_256 \
        -DGMX_DOUBLE=off \
        -DGMX_EXTERNAL_BLAS=off \
        -DGMX_EXTERNAL_LAPACK=off \
        -DGMX_FFT_LIBRARY=fftw3 \
        -DGMX_GPU=off \
        -DGMX_MPI=on \
        -DGMX_OPENMP=on \
        -DGMX_X11=off \
        .. && \
make -j 4 && \
make install
