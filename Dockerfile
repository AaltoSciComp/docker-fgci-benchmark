FROM rocker/r-base
RUN apt-get update && apt-get install -y \
	gromacs-openmpi \
	python3 \
	python3-pip \
	&& rm -rf /var/lib/apt/lists/*
RUN pip3 install \
	pytest \
	pytest-benchmark
COPY install_scripts /tmp/install_scripts
RUN R CMD BATCH /tmp/install_scripts/install_rpackages.R
COPY benchmarks /benchmarks
CMD cd /benchmarks && \
	pytest benchmarks.py
