#Data generation

require(optparse)
require(GFA)

options <- list(
  make_option(c('-x','--xlength'),type='integer'),
  make_option(c('-y','--ylength'),type='integer'),
  make_option(c('-l','--learnstart'),type='integer'),
  make_option(c('-s','--seed'),type='integer'),
  make_option(c('-n','--nlearn'),type='integer')
  )

parser = OptionParser(option_list=options)
args=parse_args(parser)        

xval <- args$x
yval <- args$y
learnstart <- args$l
seed <- args$s
nlearn <- args$n

set.seed(seed)

X <- matrix(rnorm(xval*3),xval,3) #Latent variables
W <- matrix(rnorm(yval*3),yval,3) #Projection matrix
Y <- tcrossprod(X,W) + matrix(rnorm(xval*yval),xval,yval) #Observations
Y <- sweep(Y, MARGIN=2, runif(yval), "+") #Feature means
Y <- list(Y[,1:learnstart], Y[,(learnstart+1):yval]) #Data grouping
#Model inference and visualization
norm <- normalizeData(Y, type="center") #Centering
opts <- getDefaultOpts() #Model options
#Fast runs for the demo, default options recommended in general
opts[c("iter.burnin", "iter.max")] <- c(as.integer(0.4*nlearn), as.integer(nlearn))
res <- gfa(norm$train, K=5, opts=opts) #Model inference
rec <- reconstruction(res) #Reconstruction
recOrig <- undoNormalizeData(rec, norm) #... to original space
#vis <- visualizeComponents(res, Y, norm) #Visualization
