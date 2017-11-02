#!/bin/bash

xval=$1
yval=$2
learnstart=$3
seed=$4

echo $xval $yval $learnstart $seed

echo R --vanilla --slave -f /benchmarks/R-benchmark.R --args -x $xval -y $yval -l $learnstart -s $seed
R --vanilla --slave -f /benchmarks/R-benchmark.R --args -x $xval -y $yval -l $learnstart -s $seed
