import time
import subprocess
from yaml import load
import cpuinfo
import psutil

with open('/results/parameters.yml','r') as f:
    parameters = load(f.read())


cpu_info    = cpuinfo.get_cpu_info()
cpu_flags   = cpu_info['flags']
ncpus=psutil.cpu_count()

def run_R_GFA(xsize,ysize,learnstart,nlearn,njobs):
    runstring = ' '.join(list(map(str,range(1,njobs+1))))
    cmd = 'parallel -j {0} R --vanilla --slave -f /benchmarks/R_GFA.R --args -x {1} -y {2} -l {3} -n {4} -s -- {5}'.format(ncpus,xsize,ysize,learnstart,nlearn,runstring)
    return subprocess.call([cmd],shell=True)


def run_GROMACS_MPI_testA():
    nsteps = parameters['GROMACS_MPI_testA']['nsteps']
    if 'avx' in cpu_flags:
        gromacs_version = 'avx256'
    elif 'sse4.1' in cpu_flags:
        gromacs_version = 'sse4.1'
    else:
        gromacs_version = 'sse2'
    cmd = 'mpirun -np {0} /benchmarks/gromacs-{1}/bin/gmx_mpi mdrun -s /benchmarks/gromacs-datas/ion_channel.tpr -maxh 0.50 -resethway -noconfout -nsteps {2} -g $(tempfile) -e $(tempfile)'.format(int(ncpus),gromacs_version,nsteps)
    return subprocess.call([cmd],shell=True)

def run_GROMACS_OpenMP_testA():
    nsteps = parameters['GROMACS_OpenMP_testA']['nsteps']
    cmd = 'mpirun -np {0} /benchmarks/gromacs-{1}/bin/gmx_mpi mdrun -s /benchmarks/gromacs-datas/ion_channel.tpr -maxh 0.50 -resethway -noconfout -nsteps {2} -g $(tempfile) -e $(tempfile)'.format(int(ncpus/2),gromacs_version,nsteps)
    return subprocess.call([cmd],shell=True)

def test_R_GFA(benchmark):
    xsize=parameters['R_GFA']['xsize']
    ysize=parameters['R_GFA']['ysize']
    learnstart = ysize/3
    njobs = parameters['R_GFA']['njobs']
    nlearn = parameters['R_GFA']['nlearn'] 
    
    result = benchmark.pedantic(run_R_GFA,args=(xsize,ysize,learnstart,nlearn,njobs),rounds=parameters['R_GFA']['rounds'])
    assert result == 0

def test_GROMACS_MPI_testA(benchmark):
    result = benchmark.pedantic(run_GROMACS_MPI_testA,rounds=parameters['GROMACS_MPI_testA'].get('rounds',1))
    assert result == 0

def test_GROMACS_OpenMP_testA(benchmark):
    result = benchmark.pedantic(run_GROMACS_OpenMP_testA,rounds=parameters['GROMACS_OpenMP_testA'].get('rounds',1))
    assert result == 0
