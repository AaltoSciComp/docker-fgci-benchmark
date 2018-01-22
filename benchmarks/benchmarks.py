import time
import subprocess
from yaml import load
import cpuinfo
import psutil

with open('/results/parameters.yml','r') as f:
    parameters = load(f.read())

if 'ncpus' in parameters:
    ncpus = int(parameters['ncpus'])
else:
    ncpus=psutil.cpu_count()
cpu_info    = cpuinfo.get_cpu_info()
cpu_flags   = cpu_info['flags']
if 'avx' in cpu_flags:
    gromacs_version = 'AVX_256'
elif 'sse4.1' in cpu_flags:
    gromacs_version = 'SSE4.1'
else:
    gromacs_version = 'SSE2'

def run_R_GFA(xsize,ysize,learnstart,nlearn,njobs):
    runstring = ' '.join(list(map(str,range(1,njobs+1))))
    cmd = 'parallel -j {0} R --vanilla --slave -f /benchmarks/R_GFA.R --args -x {1} -y {2} -l {3} -n {4} -s -- {5}'.format(ncpus,xsize,ysize,learnstart,nlearn,runstring)
    return subprocess.call([cmd],shell=True)

def run_CP2K_MPI_testA():
    cmd = 'OMP_NUM_THREADS={0} mpirun -np {1} cp2k -i /tmp/cp2k-datas/H2O-1024.inp -o /results/cp2k-mpi-testA.out'.format(1,int(ncpus))
    return subprocess.call([cmd],shell=True,cwd='/tmp/cp2k-datas')

def run_GROMACS_MPI_testA():
    nsteps = parameters['GROMACS_MPI_testA']['nsteps']
    cmd = 'OMP_NUM_THREADS={0} mpirun -np {1} /benchmarks/gromacs-{2}/bin/gmx_mpi mdrun -s /benchmarks/gromacs-datas/ion_channel.tpr -maxh 0.50 -resethway -noconfout -nsteps {3} -g /results/gromacs-mpi-testA.log -e /results/gromacs-mpi-testA.edr'.format(1,int(ncpus),gromacs_version,nsteps)
    return subprocess.call([cmd],shell=True)
"""
def test_R_GFA(benchmark):
    xsize=parameters['R_GFA']['xsize']
    ysize=parameters['R_GFA']['ysize']
    learnstart = ysize/3
    njobs = parameters['R_GFA']['njobs']
    nlearn = parameters['R_GFA']['nlearn'] 
    result = benchmark.pedantic(run_R_GFA,args=(xsize,ysize,learnstart,nlearn,njobs),rounds=parameters['R_GFA']['rounds'])
    assert result == 0
"""
def test_CP2K_MPI_testA(benchmark):
    result = benchmark.pedantic(run_CP2K_MPI_testA,rounds=parameters['CP2K_MPI_testA'].get('rounds',1))
    assert result == 0
"""
def test_GROMACS_MPI_testA(benchmark):
    result = benchmark.pedantic(run_GROMACS_MPI_testA,rounds=parameters['GROMACS_MPI_testA'].get('rounds',1))
    assert result == 0
"""
