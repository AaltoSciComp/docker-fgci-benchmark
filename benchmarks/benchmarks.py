import time
import subprocess
import psutil
from yaml import load

with open('/benchmarks/parameters.yml','r') as f:
    parameters = load(f.read())

njobs=3
ncpus=psutil.cpu_count()

def runR():
    x = 10
    y = 20
    l = 5
    runs = ' '.join(reversed(list(map(str,range(1,njobs+1)))))
    cmd = 'parallel -j {0} bash /benchmarks/R-benchmark.sh {1} {2} {3} -- {4}'.format(ncpus,x,y,l,runs)
    #return subprocess.call(['parallel','-j',str(ncpus),'/benchmarks/R-benchmark.sh','20','30','10','--']+runs,shell=True)
    return subprocess.call([cmd],shell=True)

def testR(benchmark):
    result = benchmark(runR)
    assert result == 0
