# docker-fgci-benchmark

This repository contains instructions on how to build a benchmark docker image for FGCI node evaluation.

## Before installation

Please verify that the hyperthreading is disabled from BIOS and that the system has a kernel version new enough to protect against [Meltdown and Spectre](https://meltdownattack.com/).

## Usage with Docker

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

    Or with some sligthly different version of docker, the syntax for binding mountpoints is different:

    ```sh
    sudo docker run --hostname $(hostname)-benchmark -v /tmp/results:/results -it aaltoscienceit/fgci-benchmark:latest
    ```

    Estimated runtime of the benchmarks is around 2 hours.

## Usage with Singularity

1. Install [Singularity](http://singularity.lbl.gov/install-linux) on your system.
2. Build image from Docker Hub with
    ```sh
    singularity build fgci-benchmark.simg docker://aaltoscienceit/fgci-benchmark:latest
    ```
3. After this you should create a folder that is writable to every user. This is where the results will be stored. For example:
    ```sh
    mkdir /tmp/results
    chmod a+w /tmp/results
    ```
4. Now you can run the benchmarks with:
    ```sh
    singularity run -B /tmp/results:/results fgci-benchmark.simg
    ```
    
    Estimated runtime of the benchmarks is around 2 hours.

## Included benchmarks

### Multiple serial R jobs

This benchmark uses the command `parallel` to fill every CPU on the
computer with R processes that solve group factor analysis using a
package called
[GFA](https://cran.r-project.org/web/packages/GFA/index.html). One job
per core is run, and the total runtime is divided by the number of
cores, thus giving a time/job throughput metric.

### GROMACS with MPI

This benchmark runs GROMACS test A from PRACE's [Unified European Applications Benchmark Suite](http://www.prace-ri.eu/ueabs/) using OpenMPI and all available cores.

### CP2K with MPI

This benchmark runs CP2K test A from PRACE's [Unified European Applications Benchmark Suite](http://www.prace-ri.eu/ueabs/) using OpenMPI and all available cores.

## Analyzing results

All results are compared against a reference result run on a Dell PowerEdge C4130 machine with 2x14 core Xeon E5 2680 v4 2.40 GHz processors and 128 GB of DDR4-2400 memory.

Results are stored in /results as JSON files. There will also be output from running hardinfo, /proc/cpuinfo, GROMACS and CP2K. There are also histograms in /results/histograms.


To compute is single benchmark score for a node one can compute the
geometric mean of the medians, e.g. with

```sh
jq '.benchmarks[].stats.median' /path/to/result_file.json | awk '{ b  = $1; C += log(b);  D++ } END { print "Geometric mean ", exp(C/D);}'
```
