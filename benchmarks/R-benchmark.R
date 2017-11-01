#Data generation

require(GFA)

xval <- 1000
yval <- 1500
learnstart <- 400

X <- matrix(rnorm(xval*3),xval,3) #Latent variables
W <- matrix(rnorm(yval*3),yval,3) #Projection matrix
Y <- tcrossprod(X,W) + matrix(rnorm(xval*yval),xval,yval) #Observations
Y <- sweep(Y, MARGIN=2, runif(yval), "+") #Feature means
Y <- list(Y[,1:learnstart], Y[,(learnstart+1):yval]) #Data grouping
#Model inference and visualization
norm <- normalizeData(Y, type="center") #Centering
opts <- getDefaultOpts() #Model options
#Fast runs for the demo, default options recommended in general
opts[c("iter.burnin", "iter.max")] <- c(500, 1000)
res <- gfa(norm$train, K=5, opts=opts) #Model inference
rec <- reconstruction(res) #Reconstruction
recOrig <- undoNormalizeData(rec, norm) #... to original space
vis <- visualizeComponents(res, Y, norm) #Visualization
