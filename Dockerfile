FROM debian:latest

RUN apt-get update && apt-get install -y \
  r-base \
  && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y \
  openmpi-bin \
  libopenmpi-dev \
  fftw3 \
  cmake \
  wget \
  curl \
  && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y \
  python3-pip \
  python3-yaml \
  moreutils \
  && rm -rf /var/lib/apt/lists/*

COPY install_scripts /tmp/install_scripts
RUN R CMD BATCH /tmp/install_scripts/install_rpackages.R

RUN pip3 install -U \
  psutil \
  pytest \
  pytest-benchmark

RUN cd /tmp && \
  wget ftp://ftp.gromacs.org/pub/gromacs/gromacs-5.1.4.tar.gz && \
  tar xzf gromacs-5.1.4.tar.gz && \
  cd gromacs-5.1.4 && \
  mkdir build && \
  cd build && \
  cmake \
          -DCMAKE_INSTALL_PREFIX=/benchmarks/gromacs/ \
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
  
COPY benchmarks/benchmarks.py /benchmarks
COPY benchmarks/R-benchmark.R /benchmarks
COPY benchmarks/R-benchmark.sh /benchmarks
COPY benchmarks/parameters.yml /benchmarks

CMD cd /benchmarks && \
  pytest benchmarks.py
