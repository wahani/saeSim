###
# SUBJECT:  Datageneration (Representative/ Non-representative outliers) 
# AUTHOR:   Timo Schmid Mai 12, 2012
# LICENSE:  GPL
# Description:  Generation of a Population including y, covariates, area effects and spatial matrix W and 
#               also outliers. For the population. Then a sample is sampled out of the population. The area 
#               outliers are in the last areas respectively. The fraction of individual outliers varies in 
#                the sample due to sample effects.
#------------------------------------------------------------------------------

# Loading Packages
#------------------------------------------------------------------------------
library(pps)
library(MASS)
library(nlme)
library(sp)
library(spgwr)
library(spdep)
library(mnormt)
set.seed(120)
rm(list=ls())

#------------------------------------------------------------------------------
# Szenario
#------------------------------------------------------------------------------
# szen<-rep(0,30)
# szen[1] <-"MODn05p00v0e0W1SYMRep"
# szen[2] <-"MODn05p00v0e5W1SYMRep"
# szen[3] <-"MODn05p00v5e0W1SYMRep"
# szen[4] <-"MODn05p00v5e5W1SYMRep"
# szen[5] <-"MODn05p80v0e0W1SYMRep"
# szen[6]<-"MODn05p80v0e5W1SYMRep"
# szen[7]<-"MODn05p80v5e0W1SYMRep"
# szen[8]<-"MODn05p80v5e5W1SYMRep"
# szen[9] <-"MODn05p00v0e5W1SYMRepN"
# szen[10] <-"MODn05p00v5e0W1SYMRepN"
# szen[11] <-"MODn05p00v5e5W1SYMRepN"
# szen[12] <-"MODn05p80v0e5W1SYMRepN"
# szen[13] <-"MODn05p80v5e0W1SYMRepN"
# szen[14]<-"MODn05p80v5e5W1SYMRepN"
# 
# szen[15] <-"MODn05p00v0e5W1NSYMRep"
# szen[16] <-"MODn05p00v5e0W1NSYMRep"
# szen[17] <-"MODn05p00v5e5W1NSYMRep"
# szen[18]<-"MODn05p80v0e5W1NSYMRep"
# szen[19]<-"MODn05p80v5e0W1NSYMRep"
# szen[20]<-"MODn05p80v5e5W1NSYMRep"
# szen[21] <-"MODn05p00v0e5W1NSYMRepN"
# szen[22] <-"MODn05p00v5e0W1NSYMRepN"
# szen[23] <-"MODn05p00v5e5W1NSYMRepN"
# szen[24] <-"MODn05p80v0e5W1NSYMRepN"
# szen[25] <-"MODn05p80v5e0W1NSYMRepN"
# szen[26]<-"MODn05p80v5e5W1NSYMRepN"
# szen[27] <-"MODn05p00v5e5b5W1SYMRep"
# szen[28] <-"MODn05p80v5e5b5W1SYMRep"
# szen[29] <-"MODn05p00v5e5b5W1NSYMRep"
# szen[30] <-"MODn05p80v5e5b5W1NSYMRep"

szen<-rep(0,20)
szen[1] <-"MODn05Nv0Ne0SYMRep"
szen[2] <-"MODn05Nv0Ne5SYMRep"
szen[3] <-"MODn05Nv5Ne0SYMRep"
szen[4] <-"MODn05Nv5Ne5SYMRep"
szen[5] <-"MODn05Nv5Ne5NSYMRep"
szen[6]<-"MODn05Nv0Te100SYMRep"
szen[7]<-"MODn05Nv0Le1000SYMRep"
szen[8]<-"MODn20v5e0SYMRep"
szen[9] <-"MODn50Nv0Ne0SYMRep"
szen[10]<-"MODn50Nv20Ne20SYMRep"
szen[11]<-"MODn50Nv30Ne30SYMRep"
szen[12]<-"MODn50Nv40Ne40SYMRep"
szen[13]<-"MODn50Nv_var0Ne0SYMRep"

szen[14]<-"MODn50Nv10Ne10SYMRep"
szen[15]<-"MODn50Tv10Te10SYMRep"
szen[16]<-"MODn50Tv20Te20SYMRep"
szen[17]<-"MODn50Tv30Te30SYMRep"
szen[18]<-"MODn50Tv40Te40SYMRep"
szen[19] <-"MODn100Nv0Ne0SYMRep"
szen[20] <-"MODn250Nv0Ne0SYMRep"

t=20
#------------------------------------------------------------------------------
# Data Setup
#------------------------------------------------------------------------------

# A DataSetup template

DataSetup <- list(
  # number of areas/clusters
  nclusters=100,
  # number of units per small area
  nunits=100,
  # parameter-value of the intercept
  alpha=100,
  # parameter-value of the slope
  beta=1,
  # parameter-value of the intercept outlier
  alphaout=150,
  # parameter-value of the slope ourlier
  betaout=1,
  # relative number of outliers, betas
  betaepsilon=0,
  # logical, whether the model has an intercept or not
  constant=TRUE,
  # Standard deviation of the x-variable
  xsigma=sqrt(0.5),
  # Mean of the x-variable
  xmu=1,
  # relative number of outliers, x-variable
  xepsilon=0,
  # Standard deviation of the contamination mixture for the x-variable
  xsigmacontam=sqrt(10),
  # Mean of the contamination mixture for the x-variable
  xmucontam=0,
  # Outlier type: Representative outlier (TRUE), Non-representative outlier (FALSE)
  outlier_type=TRUE,
  # relative number of outliers, model error
  eepsilon=0,
  # Mean of the contamination mixture for the model error
  emucontam=10,
  # Standard deviation of the un-contaminated model error
  esigma=sqrt(4),
  # Standard deviation of the contamination mixture for the model error
  esigmacontam=sqrt(150),
  # relative number of outliers, area-specific random effect
  vepsilon=0.1,
  # Mean of the contamination mixture for the random effect
  vmucontam=9,
  # Standard deviation of the un-contaminated random effect
  vsigma=sqrt(4),
  # Standard deviation of the contamination mixture of the random effect
  vsigmacontam=sqrt(20),                    
  # Spatial correlation in the area effects
  spatial=FALSE,
  # Spatial correlation parameter 
  p=0,
  # Spatial neighbour structure
  type="rook",      # rook or queen
  # Dimension of the spatial matrix
  nrow_spatial=5,  # condition: nrow*nrow!=nclusters
  ncol_spatial=5,
  # Style of the spatial matrix
  w_style="W"       # style = B is 0,1 and W=weighted
)

SampleSetup<- list(snunits=10)
# number of sampled units per small area

simruns <- 100
# number of simulation runs
Pop<-NULL
#------------------------------------------------------------------------------
# Generation of the data  
#------------------------------------------------------------------------------
if(DataSetup$outlier_type==TRUE){
#------------------------------------------------------------------------------
# Generation of the population (Representative outliers)   
#------------------------------------------------------------------------------
  
  
  # Generate the spatial Matrix W
  
  nb_structure <- cell2nb(DataSetup$nrow_spatial,DataSetup$ncol_spatial,type=DataSetup$type) 
  xyccc <- attr(nb_structure, "region.id")
  xycc <- matrix(as.integer(unlist(strsplit(xyccc, ":"))), ncol=2, byrow=TRUE)
  plot(nb_structure, xycc)
  
  W_list<-nb2listw(nb_structure)
  W <- nb2mat(nb_structure, glist=NULL, style=DataSetup$w_style) # Spatial Matrix W
  IrWinv <- invIrM(nb_structure, DataSetup$p,style=DataSetup$w_style) # (I-\lambda W)^{-1}
  
  GetPop <- function(DataSetup, scale.it=20){
    # total number of observations
    n <- DataSetup$nclusters * DataSetup$nunits
    # regression constant alpha
    alpha <- rep(1, n)
    # regression design matrix x + outlier
    no.xoutliers <- floor(n*DataSetup$xepsilon) 
    x <- c(rlnorm((n-no.xoutliers), DataSetup$xmu, DataSetup$xsigma), rnorm(no.xoutliers, DataSetup$xmucontam, DataSetup$xsigmacontam))
    # shuffle the x's
    x <- x[order(runif(n))]
    if(DataSetup$constant){
      x <- cbind(rep(1,n), x)
      colnames(x)[1] <- "cst"
    }
    
    # build clusterid, unitid, and cluster-level random effect
    clusterid <- numeric(n) 
    unitid <- numeric(n)
    v <- numeric(DataSetup$nclusters)
    
    # generate the cluster and unit ID
    for(i in 1:DataSetup$nclusters){
      # build the cluster and unit ids
      clusterid[((i-1)*DataSetup$nunits+1):(DataSetup$nunits+(i-1)*DataSetup$nunits)] <- rep(i, DataSetup$nunits)
      unitid[((i-1)*DataSetup$nunits+1):(DataSetup$nunits+(i-1)*DataSetup$nunits)] <- seq(1, DataSetup$nunits)
    }
    
    # Generate the v
    
    if(DataSetup$spatial==TRUE){
      # generate the spatial correlation matrix and correlated v
      
      K<-diag(DataSetup$vsigma^2,DataSetup$nclusters)%*%solve((diag(1,DataSetup$nclusters)-diag(DataSetup$p,DataSetup$nclusters)%*%W)%*%(diag(1,DataSetup$nclusters)-diag(DataSetup$p,DataSetup$nclusters)%*%t(W)))
      v1<-rmnorm(1, mean=rep(0,DataSetup$nclusters ), K)
      v2<-v1/(sd(v1[1:DataSetup$nclusters]))*DataSetup$vsigma
      v<-rep(v2,each=DataSetup$nunits)
    }else{
      
      # generate the  uncorrelated v
      for(i in 1:DataSetup$nclusters){
        v[((i-1)*DataSetup$nunits+1):(DataSetup$nunits+(i-1)*DataSetup$nunits)] <- rep(rnorm(1, 0, DataSetup$vsigma), DataSetup$nunits)
      }
    }     
    
    # generate the cluster-effect outliers
    No.of.outliers<-floor(DataSetup$nclusters*DataSetup$vepsilon)
    
    if(No.of.outliers==0){}else{
      the.outlier.clusters <- c((DataSetup$nclusters-No.of.outliers+1):DataSetup$nclusters)
      
      for(k in the.outlier.clusters){
        v[((k-1)*DataSetup$nunits+1):(DataSetup$nunits+(k-1)*DataSetup$nunits)] <- rep(rnorm(1, DataSetup$vmucontam, DataSetup$vsigmacontam), DataSetup$nunits)
      }} 
    
    #     for(i in 1:DataSetup$nclusters){
    #       v[((i-1)*DataSetup$nunits+1):(DataSetup$nunits+(i-1)*DataSetup$nunits)] <- rep(rnorm(1, 0, DataSetup$vsigma), DataSetup$nunits)
    #     } 
    #  
    #     # generate the cluster-effect outliers
    #     No.of.outliers<-floor(DataSetup$nclusters*DataSetup$vepsilon)
    #     
    #     if(No.of.outliers==0){}else{
    #       the.outlier.clusters <- c((DataSetup$nclusters-No.of.outliers+1):DataSetup$nclusters)
    #       
    #       for(k in the.outlier.clusters){
    #         v[((k-1)*DataSetup$nunits+1):(DataSetup$nunits+(k-1)*DataSetup$nunits)] <- rep(rnorm(1, DataSetup$vmucontam, DataSetup$vsigmacontam), DataSetup$nunits)
    #       }}
    #     
    #     if(DataSetup$spatial==TRUE){
    #       # generate the spatial correlation matrix and correlated v
    #       v1<-IrWinv%*%unique(v)
    #       v<-rep(v1,each=DataSetup$nunits)
    #     }else{}
    
    
    # regression-model error term (i.e., e_ij)
    no.eoutliers <- floor(n*DataSetup$eepsilon) 
    e <- c(rnorm((n), 0, DataSetup$esigma))
    oute<-sample(1:n,no.eoutliers)
    # shuffle the e's
    for(i in oute){e[i]<-rnorm(1, DataSetup$emucontam, DataSetup$esigmacontam)}
    out.e1<-rep(0,n)
    for(i in oute){out.e1[i]<-1}
    
    # outliers in beta
    no.betaoutliers <- floor(n*DataSetup$betaepsilon)
    outbeta<-sample(1:n,no.betaoutliers)
    
    # Generation of y
    y <-  x[,1]*DataSetup$alpha + x[,2]*DataSetup$beta + v + e
    y2 <- x[,1]*DataSetup$alphaout + x[,2]*DataSetup$betaout + v + e
    for(i in outbeta){y[i]<-y2[i]}
    res <- data.frame(y,x,v,e,out.e1,clusterid, unitid=as.factor(unitid))
    attr(res, "DataSetup") <- DataSetup
    attr(res, "class") <- "data.frame"
    return(res)
  }
  

  # Data output and storage
  for(ii in 1:simruns){
  # Data output and storage
  Pop[ii]<-list(GetPop(DataSetup))
  }
  
  
#------------------------------------------------------------------------------
  
# Drawing of samples
#------------------------------------------------------------------------------
  sample_id<-matrix(0,nrow=DataSetup$nclusters*SampleSetup$snunits,ncol=simruns)
  sample_y<-matrix(0,nrow=DataSetup$nclusters*SampleSetup$snunits,ncol=simruns)
  
  
for(u in 1:simruns){
    # SampleSetup     a list object that defines the parameters 
    GetSample <- function(SampleSetup){
      # generate the sample
      s<-stratsrs(Pop[[u]]$clusterid,rep(SampleSetup$snunits,DataSetup$nclusters))
      return(s)
    }
    
    # Storage of the sampled and non-sampled units
    sample_id[,u]<-GetSample(SampleSetup)
    sample_y[,u]<-cbind(Pop[[u]][sample_id[,u],1])
  }
  

#------------------------------------------------------------------------------
# Generation of the population (Non-Representative outliers)
}else{
#------------------------------------------------------------------------------
 
  # Generate the spatial Matrix W
  
  nb_structure <- cell2nb(DataSetup$nrow_spatial,DataSetup$ncol_spatial,type=DataSetup$type) 
  xyccc <- attr(nb_structure, "region.id")
  xycc <- matrix(as.integer(unlist(strsplit(xyccc, ":"))), ncol=2, byrow=TRUE)
  plot(nb_structure, xycc)
  
  W_list<-nb2listw(nb_structure)
  W <- nb2mat(nb_structure, glist=NULL, style=DataSetup$w_style) # Spatial Matrix W
  IrWinv <- invIrM(nb_structure, DataSetup$p,style=DataSetup$w_style) # (I-\lambda W)^{-1}
  
  GetPop <- function(DataSetup, scale.it=20){
    # total number of observations
    n <- DataSetup$nclusters * DataSetup$nunits
    # regression constant alpha
    alpha <- rep(1, n)
    # regression design matrix x + outlier
    no.xoutliers <- floor(n*DataSetup$xepsilon) 
    x <- c(rnorm((n-no.xoutliers), DataSetup$xmu, DataSetup$xsigma), rnorm(no.xoutliers, DataSetup$xmucontam, DataSetup$xsigmacontam))
    # shuffle the x's
    x <- x[order(runif(n))]
    if(DataSetup$constant){
      x <- cbind(rep(1,n), x)
      colnames(x)[1] <- "cst"
    }
    
    # build clusterid, unitid, and cluster-level random effect
    clusterid <- numeric(n) 
    unitid <- numeric(n)
    v <- numeric(DataSetup$nclusters)
    
    # generate the cluster and unit ID
    for(i in 1:DataSetup$nclusters){
      # build the cluster and unit ids
      clusterid[((i-1)*DataSetup$nunits+1):(DataSetup$nunits+(i-1)*DataSetup$nunits)] <- rep(i, DataSetup$nunits)
      unitid[((i-1)*DataSetup$nunits+1):(DataSetup$nunits+(i-1)*DataSetup$nunits)] <- seq(1, DataSetup$nunits)
    }
    
    # Generate the v
    
    if(DataSetup$spatial==TRUE){
      # generate the spatial correlation matrix and correlated v
      
      K<-diag(DataSetup$vsigma^2,DataSetup$nclusters)%*%solve((diag(1,DataSetup$nclusters)-diag(DataSetup$p,DataSetup$nclusters)%*%W)%*%(diag(1,DataSetup$nclusters)-diag(DataSetup$p,DataSetup$nclusters)%*%t(W)))
      v1<-rmnorm(1, mean=rep(0,DataSetup$nclusters ), K)
      v2<-v1/(sd(v1[1:DataSetup$nclusters]))*DataSetup$vsigma
      v<-rep(v2,each=DataSetup$nunits)
    }else{
      
      # generate the  uncorrelated v
      for(i in 1:DataSetup$nclusters){
        v[((i-1)*DataSetup$nunits+1):(DataSetup$nunits+(i-1)*DataSetup$nunits)] <- rep(rnorm(1, 0, DataSetup$vsigma), DataSetup$nunits)
      }
    }     
    
    
    #     for(i in 1:DataSetup$nclusters){
    #       v[((i-1)*DataSetup$nunits+1):(DataSetup$nunits+(i-1)*DataSetup$nunits)] <- rep(rnorm(1, 0, DataSetup$vsigma), DataSetup$nunits)
    #     } 
    #     
    #     if(DataSetup$spatial==TRUE){
    #       # generate the spatial correlation matrix and correlated v
    #       v1<-IrWinv%*%unique(v)
    #       v<-rep(v1,each=DataSetup$nunits)
    #     }else{}
    
    
    # regression-model error term (i.e., e_ij)
    no.eoutliers <- 0 
    e <- c(rnorm((n), 0, DataSetup$esigma))
    oute<-sample(1:n,no.eoutliers)
    # shuffle the e's
    for(i in oute){e[i]<-rnorm(1, DataSetup$emucontam, DataSetup$esigmacontam)}
    out.e1<-rep(0,n)
    for(i in oute){out.e1[i]<-1}
    
    # Generation of y
    y <- x[,1]*DataSetup$alpha + x[,2]*DataSetup$beta + v + e
    
    res <- data.frame(y,x,v,e,out.e1,clusterid, unitid=as.factor(unitid))
    attr(res, "DataSetup") <- DataSetup
    attr(res, "class") <- "data.frame"
    return(res)
  }
  
  for(ii in 1:simruns){
  # Data output and storage
  Pop[ii]<-list(GetPop(DataSetup))
  }

  
  #------------------------------------------------------------------------------
  
# Drawing of samples
#------------------------------------------------------------------------------
  sample_id<-matrix(0,nrow=DataSetup$nclusters*SampleSetup$snunits,ncol=simruns)
  sample_y<-matrix(0,nrow=DataSetup$nclusters*SampleSetup$snunits,ncol=simruns)
  sample_out_e<-matrix(0,nrow=DataSetup$nclusters*SampleSetup$snunits,ncol=simruns)
  
  
  for(u in 1:simruns){
    # SampleSetup     a list object that defines the parameters 
    GetSample <- function(SampleSetup){
      n<-DataSetup$ncluster*SampleSetup$snunits
      # generate the sample
      s<-stratsrs(Pop[[u]]$clusterid,rep(SampleSetup$snunits,DataSetup$nclusters))
      
      # regression-model error term (i.e., e_ij)
      no.eoutliers <- floor(n*DataSetup$eepsilon) 
      e <- rep(0,times=n)
      oute<-sample(1:n,no.eoutliers)
      # shuffle the e's
      for(i in oute){e[i]<-rnorm(1, DataSetup$emucontam, DataSetup$esigmacontam)}
      out.e1<-rep(0,n)
      for(i in oute){out.e1[i]<-1}
      
      # generate the cluster-effect outliers
      v4<-numeric(n)
      No.of.outliers<-floor(DataSetup$nclusters*DataSetup$vepsilon)
      if(No.of.outliers==0){}else{
        the.outlier.clusters <- c((DataSetup$nclusters-No.of.outliers+1):DataSetup$nclusters)
        
        for(k in the.outlier.clusters){
          v4[((k-1)*SampleSetup$snunits+1):(SampleSetup$snunits+(k-1)*SampleSetup$snunits)] <- rep(rnorm(1, DataSetup$vmucontam, DataSetup$vsigmacontam), SampleSetup$snunits)
        }}
      
      res <- data.frame(s,v4,e,out.e1)
      return(res)
    }
    
    # Storage of the sampled and non-sampled unit
    SAMPLE<-GetSample(SampleSetup)
    sample_id[,u]<-SAMPLE$s
    sample_y[,u]<-cbind(Pop[[u]][sample_id[,u],1])+SAMPLE$e+SAMPLE$v4
    sample_out_e[,u]<-SAMPLE$out.e1
  }
  
}

#------------------------------------------------------------------------------
# Description of the key parameters
#------------------------------------------------------------------------------

describe <- function(object){
  if(!is.null(attr(object, "DataSetup"))){
    object <- attr(object, "DataSetup")
  }
  cat("------------------------------------------------- \n")
  cat("Simulation setup (balanced data) \n")
  cat("------------------------------------------------- \n")
  cat("No. of clusters (i=1,...,m): ", object$nclusters,"\n")
  cat("No. units per clusters (j=1,...,k): ", object$nunits,"\n")
  cat("Representative Outliers typ: ", object$outlier_type,"\n")
  cat("Spatial Information in v: ", object$p,"\n")
  cat("Spatial Neighbour Structure: ", object$type,"\n")
  cat("Spatial Weighting Structure: ", object$w_style,"\n")
  cat("Sample size per area: ", SampleSetup$snunits,"\n")
  cat("Simulation runs: ", simruns,"\n")
  cat("\n")
  cat("FIXED EFFECTS \n")
  if(object$xepsilon==0){
    cat("  x_ij ~ N(",object$xmu, ", ", object$xsigma^2,")\n" ,sep="") 
  }
  else{
    cat("  x_ij ~ (", 1-object$xepsilon, ")*N(",object$xmu, ", ", object$xsigma^2,") + ", object$xepsilon, "*N(", object$xmucontam, ", ", object$xsigmacontam^2, ") \n", sep="") 
  }
  cat("  y_ij =", object$alpha, " + ", object$beta, "*x_ij + v_i + e_ij \n", sep="")  
  cat("\n")
  cat("RANDOM EFFECTS \n")
  if(object$vepsilon==0){
    cat("  v_i ~ N(0, ", object$vsigma^2,  ")\n", sep="") 
  }
  else{
    cat("  v_i ~ (", 1-object$vepsilon, ")*N(0, ", object$vsigma^2, ") + ", object$vepsilon, "*N(", object$vmucontam, ", ", object$vsigmacontam^2, ") \n", sep="") 
  }
  if(object$eepsilon==0){
    cat("  e_ij  ~ N(0, ", object$esigma^2,  ")\n", sep="")
  }else{
    cat("  e_ij  ~ (", 1-object$eepsilon, ")*N(0, ", object$esigma^2, ") + ", object$eepsilon, "*N(", object$emucontam, ", ", object$esigmacontam^2, ") \n", sep="")
  }
}
if(DataSetup$nrow_spatial*DataSetup$ncol_spatial==DataSetup$nclusters){print("Dimension Spatial Matrix valid")}else{print("Wrong Dimension Spatial Matrix")}
#------------------------------------------------------------------------------

#save(Pop, file="c:\\Arbeit\\02-Simulation\\R\\Estimators\\REBLUP\\Test.RData")

ymean<-tapply(Pop[[1]]$y,Pop[[1]]$clusterid, mean)
xmean<-tapply(Pop[[1]]$x,Pop[[1]]$clusterid, mean)
p_start <- moran.test(as.numeric(ymean), nb2listw(nb_structure, style="W"))
Y.mod <- errorsarlm(as.vector(ymean) ~ as.vector(xmean), listw = W_list)
p_start
Y.mod

# View(Pop[[1]])
