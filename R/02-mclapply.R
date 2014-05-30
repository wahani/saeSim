mclapply <- function(X, FUN, ..., mc.preschedule = TRUE, mc.set.seed = TRUE,
                     mc.silent = FALSE, mc.cores = 1L,
                     mc.cleanup = TRUE, mc.allow.recursive = TRUE) {
  
  # For Windows
  if(grepl("win", .Platform$OS.type)) {
    
    clusterFunction <- if(mc.preschedule) clusterApply else clusterApplyLB
    cl <- makeCluster(mc.cores)
    on.exit(stopCluster(cl))
    ptOptions <- getPTOption()
    packageToLoad <- if(is.null(ptOptions)) "" else ptOptions$parallelToolsPTL
    sourceFile <- if(is.null(ptOptions)) "" else ptOptions$parallelToolsSF
    
    # load packages
    if(all(packageToLoad != "")) {
      clusterExport(cl, "packageToLoad", envir = environment())
      clusterEvalQ(cl, lapply(packageToLoad, require, character.only = TRUE))
    }
    
    # source
    if(sourceFile != "") {
      clusterExport(cl, "sourceFile", envir = environment())
      clusterEvalQ(cl, source(sourceFile, echo=FALSE))
    }
    
    return(clusterFunction(cl = cl, x = X, fun = FUN, ...=...))
    
  } else {
    
    # For else
    return(parallel::mclapply(
      X = X, FUN = FUN, ...=..., mc.preschedule = mc.preschedule,
      mc.set.seed = mc.set.seed, mc.silent = mc.silent, mc.cores = mc.cores,
      mc.cleanup = mc.cleanup, mc.allow.recursive = mc.allow.recursive))
  }
}

getPTOption <- function() {
  ptOptions <- .Options[grepl("parallelTools", names(.Options))]
  if(length(ptOptions) == 0) {
    invisible(NULL)
  } else {
    invisible(ptOptions)
  }
}

setPTOption <- function(packageToLoad = "", sourceFile = "") {
  options(parallelToolsPTL = packageToLoad, parallelToolsSF = sourceFile)
}