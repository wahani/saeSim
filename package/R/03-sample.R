#' Sampling function
#' 
#' These function control the sampling mechanism. They are designed to be used with \code{\link{sim_sample}}. \code{sample_sampleWrapper} is a wrapper of the sample function already implemented in R. The arguments will simply be passed to \code{\link{sample}}
#' 
#' @param ... Arguments passed to \code{\link{sample}}
#' 
#' @seealso \code{\link{sample_srs}}, \code{\link{sample_csrs}}, \code{\link{sim_sample}}
#' @export
sample_sampleWrapper <- function(...) {
  function(nDomains, nUnits) {
    sample(...)
  }
}

#' Sampling function
#' 
#' This function controls the sampling mechanism. They are designed to be used with \code{\link{sim_sample}}. \code{sample_srs} will draw with simple random sampling.
#' 
#' @param size can either be >= 1 giving the sample size or < 1 where it is treated as proportion
#' @param ... Arguments passed to \code{\link{sample.int}}
#' 
#' @seealso \code{\link{sample_sampleWrapper}}, \code{\link{sample_csrs}}, \code{\link{sim_sample}}
#' @export
sample_srs <- function(size = 0.05, ...) {
  function(nDomains, nUnits) {
    id <- make_id(nDomains, nUnits)
    sample.int(nrow(id), if(is.integer(size) | size >= 1) as.integer(size) else 
      ceiling(size * nrow(id)), ...)
  }
}

#' Sampling function
#' 
#' This function controls the sampling mechanism. They are designed to be used with \code{\link{sim_sample}}. \code{sample_csrs} will draw with simple random sampling in each cluster. The cluster is hard coded as \code{idD}.
#' 
#' @param size can either be >= 1 giving the sample size (in each cluster) or < 1 where it is treated as proportion (in each cluster). Additionally size can have \code{length(size) > 1} which will be interpreted as different sample sizes in each cluster/domain.
#' 
#' @seealso \code{\link{sample_srs}}, \code{\link{sample_sampleWrapper}}, \code{\link{sim_sample}}
#' @export
sample_csrs <- function(size = 0.05) {
  function(nDomains, nUnits) {
    id <- make_id(nDomains, nUnits)
    dataList <- split(id, list(id$idD))
    unlist(lapply(as.list(1:nDomains), 
           function(i) {
             df <- dataList[[i]]
             df <- df[sample.int(nrow(df), 
                                 if(is.integer(size)) 
                                   if(length(size) == 1) 
                                     size else 
                                       size[i] else 
                                         if(size >= 1) size else
                                           ceiling(size * nrow(df))), ]
             as.numeric(rownames(df))
           }))
  }
}


