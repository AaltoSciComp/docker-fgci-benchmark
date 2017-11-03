import time
import subprocess
import psutil
from yaml import load

with open('/benchmarks/parameters.yml','r') as f:
    parameters = load(f.read())

ncpus=psutil.cpu_count()

def run_R_GFA():
    x = int(parameters['R_GFA']['xsize'])
    y = int(parameters['R_GFA']['ysize'])
    l = int(abs(x-y/2))
    njobs=int(parameters['R_GFA']['njobs'])
    runs = ' '.join(reversed(list(map(str,range(1,njobs+1)))))
    #cmd = 'parallel -j {0} bash /benchmarks/R-benchmark.sh {1} {2} {3} -- {4}'.format(ncpus,x,y,l,runs)
    cmd = 'parallel -j {0} R --vanilla --slave -f /benchmarks/R_GFA.R --args -x {1} -y {2} -l {3} -s -- {4}'.format(ncpus,x,y,l,runs)
    return subprocess.call([cmd],shell=True)


def run_GROMACS_MPI_A():
    nsteps = parameters['GROMACS_MPI_testA']['nsteps']
    cmd = 'mpirun -np {0} /benchmarks/gromacs/bin/gmx_mpi mdrun -s /benchmarks/gromacs-datas/ion_channel.tpr -maxh 0.50 -resethway -noconfout -nsteps {1} -g $(tempfile)'.format(ncpus,nsteps)
    return subprocess.call([cmd],shell=True)

def run_GROMACS_OpenMP_A():
    nsteps = parameters['GROMACS_OpenMP_testA']['nsteps']
    cmd = 'mpirun -np 1 /benchmarks/gromacs/bin/gmx_mpi mdrun -s /benchmarks/gromacs-datas/ion_channel.tpr -maxh 0.50 -resethway -noconfout -nsteps {0} -g $(tempfile)'.format(nsteps)
    return subprocess.call([cmd],shell=True)

def testR(benchmark):
    result = benchmark(run_R_GFA)
    assert result == 0

def testGROMACS_MPI_A(benchmark):
    result = benchmark(run_GROMACS_MPI_A)
    assert result == 0

def testGROMACS_OpenMP_A(benchmark):
    result = benchmark(run_GROMACS_OpenMP_A)
    assert result == 0
