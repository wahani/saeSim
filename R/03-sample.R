#' Sampling function
#' 
#' This function is intended to be used with \code{\link{sim_sample}} and not interactively. \code{sample_sampleWrapper} is a wrapper of the sample function already implemented in R. The arguments will simply be passed to \code{\link{sample}}.
#' 
#' @param ... Arguments passed to \code{\link{sample}}.
#' 
#' @seealso \code{\link{sample_srs}}, \code{\link{sample_csrs}}, \code{\link{sim_sample}}, \code{\link{sample}}
#' @export
#' 
#' @examples 
#' sim_lm() %+% sim_sample(sample_sampleWrapper(1:(100*100), 50))
sample_sampleWrapper <- function(...) {
  function(nDomains, nUnits) {
    sample(...)
  }
}

#' Sampling function
#' 
#' This function is intended to be used with \code{\link{sim_sample}} and not interactively. \code{sample_srs} will draw with simple random sampling. \code{\link{sample.int}} is used under the hood.
#' 
#' @param size can either be >= 1 giving the sample size or < 1 where it is treated as proportion.
#' @param ... Arguments passed to \code{\link{sample.int}}.
#' 
#' @seealso \code{\link{sample_sampleWrapper}}, \code{\link{sample_csrs}}, \code{\link{sim_sample}}, \code{\link{sample.int}}
#' @export
#' 
#' @examples 
#' sim_lm() %+% sim_sample(sample_srs())
sample_srs <- function(size = 0.05, ...) {
  function(nDomains, nUnits) {
    id <- make_id(nDomains, nUnits)
    sample.int(nrow(id), if(is.integer(size) | size >= 1) as.integer(size) else 
      ceiling(size * nrow(id)), ...)
  }
}

#' Sampling function
#' 
#' This function is intended to be used with \code{\link{sim_sample}} and not interactively. \code{sample_csrs} will draw with simple random sampling in each cluster. Clusters are identified using the \code{nDomains} and \code{nUnits} specified in the sim_base. \code{\link{sample.int}} is used under the hood.
#' 
#' @param size can either be >= 1 giving the sample size (in each cluster) or < 1 where it is treated as proportion (in each cluster). Additionally size can have \code{length(size) > 1} which will be interpreted as different sample sizes in each cluster/domain.
#' 
#' @seealso \code{\link{sample_srs}}, \code{\link{sample_sampleWrapper}}, \code{\link{sim_sample}}, \code{\link{sample.int}}
#' @export
#' 
#' @examples 
#' sim_lm() %+% sim_sample(sample_csrs())
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


