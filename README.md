# docker-fgci-benchmark

This repository contains instructions on how to build a benchmark docker image for FGCI node evaluation.

## Usage

1. Install Docker on your system.
2. Pull image from Docker Hub with  
    ```sh
    sudo docker pull aaltoscienceit/fgci-benchmark:latest
    ```
    or build the most recent image from GitHub
    ```sh
    sudo docker build -t aaltoscienceit/fgci-benchmark:latest github.com/AaltoScienceIT/docker-fgci-benchmark
    ```
3. After this you should create a folder that is writable to every user. This is where the results will be stored. For example:
    ```sh
    mkdir /tmp/results
    chmod a+w /tmp/results
    ```

4. Now you can run the benchmarks with:
    ```sh
    sudo docker run --hostname $(hostname)-benchmark --mount type=bind,source=/tmp/results,target=/results -it aaltoscienceit/fgci-benchmark:latest
    ```

## Included benchmarks

### Multiple serial R jobs

This benchmark uses the command `parallel` to fill every CPU on the computer with R processes that solve group factor analysis using a package called [GFA](https://cran.r-project.org/web/packages/GFA/index.html). In total 200 different jobs are run.

### GROMACS with MPI

This benchmark runs GROMACS test A from PRACE's [Unified European Applications Benchmark Suite](http://www.prace-ri.eu/ueabs/) using OpenMPI and all available cores.

### GROMACS with OpenMP

This benchmark runs GROMACS test A from PRACE's [Unified European Applications Benchmark Suite](http://www.prace-ri.eu/ueabs/) using OpenMP and all available cores.

## Analyzing results

All results are compared against a reference result run on a Dell PowerEdge C4130 machine with 2x12 core Xeon E5 2680 v3 2.50 GHz processors and 128 GB of DDR4-2133 memory.

Results are stored as json files in /results. There are also histograms in /results/histograms.
