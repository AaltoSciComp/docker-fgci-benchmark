#!/bin/bash

GMXVER="gromacs-2019"
# Obtain Gromacs ZIP
cd /tmp &&
curl -OL http://ftp.gromacs.org/pub/gromacs/${GMXVER}.tar.gz

# Number of procs for make
# Note 'nproc' from coreutils says only 1 cpu available when running
# docker build, so instead pull it from cpuinfo.
NPROC=$(grep -c ^processor /proc/cpuinfo)

# Install Gromacs with SSE2
tar xzf ${GMXVER}.tar.gz && \
cd ${GMXVER} && \
mkdir build && \
cd build && \
cmake \
        -DCMAKE_INSTALL_PREFIX=/benchmarks/gromacs-SSE2/ \
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
make -j ${NPROC} && \
make install

# Clean up build directory
cd /tmp && \
rm -rf ${GMXVER}

# Install Gromacs with SSE 4.1
tar xzf ${GMXVER}.tar.gz && \
cd ${GMXVER} && \
mkdir build && \
cd build && \
cmake \
        -DCMAKE_INSTALL_PREFIX=/benchmarks/gromacs-SSE4.1/ \
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
make -j ${NPROC} && \
make install

# Clean up build directory
cd /tmp && \
rm -rf ${GMXVER}

# Install Gromacs with 256-bit AVX
tar xzf ${GMXVER}.tar.gz && \
cd ${GMXVER} && \
mkdir build && \
cd build && \
cmake \
        -DCMAKE_INSTALL_PREFIX=/benchmarks/gromacs-AVX_256/ \
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
make -j ${NPROC} && \
make install

# Clean up build directory
cd /tmp && \
rm -rf ${GMXVER}


# Install Gromacs with AVX512
tar xzf ${GMXVER}.tar.gz && \
cd ${GMXVER} && \
mkdir build && \
cd build && \
cmake \
        -DCMAKE_INSTALL_PREFIX=/benchmarks/gromacs-AVX_512/ \
        -DBUILD_SHARED_LIBS=off \
        -DBUILD_TESTING=off \
        -DREGRESSIONTEST_DOWNLOAD=OFF \
        -DCMAKE_C_COMPILER=`which mpicc` \
        -DCMAKE_CXX_COMPILER=`which mpicxx` \
        -DGMX_BUILD_OWN_FFTW=on \
        -DGMX_SIMD=AVX_512 \
        -DGMX_DOUBLE=off \
        -DGMX_EXTERNAL_BLAS=off \
        -DGMX_EXTERNAL_LAPACK=off \
        -DGMX_FFT_LIBRARY=fftw3 \
        -DGMX_GPU=off \
        -DGMX_MPI=on \
        -DGMX_OPENMP=on \
        -DGMX_X11=off \
        .. && \
make -j ${NPROC} && \
make install

# Clean up build directory                                                                                                                                                                           
cd /tmp && \
rm -rf ${GMXVER}
