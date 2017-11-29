# Start from Debian image
FROM debian:latest

# Install requirements for GROMACS benchmark
RUN apt-get update && apt-get install -y \
  openssh-client \
  openmpi-bin \
  libopenmpi-dev \
  fftw3 \
  cmake \
  wget \
  curl \
  build-essential \
  && rm -rf /var/lib/apt/lists/*

# Compile and install GROMACS
COPY install_scripts /tmp/install_scripts
RUN bash /tmp/install_scripts/install_gromacs.sh

# Download GROMACS test data
RUN mkdir /benchmarks/gromacs-datas && \
  cd /tmp && \
  wget http://www.prace-ri.eu/UEABS/GROMACS/1.2/GROMACS_TestCaseA.tar.gz && \
  tar xzf GROMACS_TestCaseA.tar.gz && \
  cp ion_channel.tpr /benchmarks/gromacs-datas
  
# Install requirements for R benchmark
RUN apt-get update && apt-get install -y \
  r-base \
  && rm -rf /var/lib/apt/lists/*

# Install packages used for R benchmark
COPY install_scripts /tmp/install_scripts
RUN R CMD BATCH /tmp/install_scripts/install_rpackages.R

# Install requirements for Python benchmark suite
RUN apt-get update && apt-get install -y \
  python3-pip \
  python3-yaml \
  moreutils \
  && rm -rf /var/lib/apt/lists/*

# Install packages for Python benchmark suite
RUN pip3 install -U \
  psutil \
  pytest \
  pygal \
  pygal.js \
  py-cpuinfo \
  pytest-benchmark

# Copy benchmark scripts
COPY benchmarks/benchmarks.py /benchmarks
COPY benchmarks/R_GFA.R /benchmarks

# Set result folder
RUN mkdir /results

# chown /benchmarks and results for a new user with uid 1001
RUN chown 1001:1001 /benchmarks /results

# Create user benchmark with uid 1001 (MPI is risky to run as root)
RUN adduser --home /benchmarks --uid 1001 --shell /bin/bash --disabled-password --gecos '' benchmark

# Set default user and run location
USER benchmark
WORKDIR /benchmarks

RUN ln -s /tmp /benchmarks/.cache

# Copy entrypoint script
COPY ./entry.sh /entry.sh
ENTRYPOINT ["/entry.sh"]
