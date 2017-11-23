#!/bin/bash

savename=$(hostname)-$(date "+%0d-%0m-%Y_%H-%M-%S")

cd /results
if [ ! -e parameters.yml ] ; then 
  wget https://raw.githubusercontent.com/AaltoScienceIT/docker-fgci-benchmark/master/benchmarks/parameters.yml
fi
if [ ! -e reference.json ] ; then 
  wget https://raw.githubusercontent.com/AaltoScienceIT/docker-fgci-benchmark/master/benchmarks/reference.json 
fi

pytest /benchmarks/benchmarks.py --benchmark-storage=/results \
  --benchmark-save=$savename \
  --benchmark-histogram=/results/histograms/$savename \
  --benchmark-compare=/results/reference.json
