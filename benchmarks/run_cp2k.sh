#!/bin/bash

. /etc/profile.d/modules.sh

. /benchmarks/spack/share/spack/setup-env.sh

spack load --dependencies cp2k 

export OMP_NUM_THREADS=$1

CP2K_DATA_DIR=/benchmarks/cp2k-datas mpirun -np $2 cp2k.popt -i /benchmarks/cp2k-datas/H2O-1024.inp -o /results/cp2k-mpi-testA.out
