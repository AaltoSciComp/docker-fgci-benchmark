FROM rocker/r-base:latest
COPY install_scripts /tmp/install_scripts
RUN R CMD BATCH /tmp/install_scripts/install_rpackages.R

RUN apt-get update && apt-get install -y \
	python3-pip \
	gromacs-openmpi \
  moreutils \
	&& rm -rf /var/lib/apt/lists/*

RUN pip3 install -U \
  psutil \
	pytest \
	pytest-benchmark


COPY benchmarks /benchmarks
CMD cd /benchmarks && \
	pytest benchmarks.py
