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
#' sim_base_lm() %>% sim_sample(sample_sampleWrapper(1:(100*100), 50))
sample_sampleWrapper <- function(...) {
  function(dat) {
    dat[sample(...), ]
  }
}

#' Sampling function
#' 
#' This function is intended to be used with \code{\link{sim_sample}} and not interactively. \code{sample_srs} will draw with simple random sampling. \code{\link{sample.int}} is used under the hood.
#' 
#' @param size can either be >= 1 giving the sample size or < 1 where it is treated as proportion.
#' @param ... arguments passed to \code{\link{sample.int}}.
#' 
#' @seealso \code{\link{sample_sampleWrapper}}, \code{\link{sample_csrs}}, \code{\link{sim_sample}}, \code{\link{sample.int}}
#' @export
#' 
#' @examples 
#' sim_base_lm() %>% sim_sample(sample_srs())
sample_srs <- function(size = 0.05, ...) {
  function(dat) {
    ind <- sample.int(nrow(dat), 
                      if(is.integer(size) | size >= 1) as.integer(size) else 
                        ceiling(size * nrow(dat)), ...)
    dat[ind, ]
  }
}

#' Sampling function
#' 
#' This function is intended to be used with \code{\link{sim_sample}} and not interactively. \code{sample_csrs} will draw with simple random sampling in each cluster. Clusters are identified using the variable names given by \code{clusterVar}.
#' 
#' @param size can be >= 1 giving the sample size (in each cluster) or < 1 where it is treated as proportion (in each cluster). Additionally size can have \code{length(size) > 1} which will be interpreted as different sample sizes in each cluster/domain.
#' @param clusterVar variable names as character used to identify clusters.
#' @param ... Arguments passed to \code{\link{sample}}.
#' 
#' @seealso \code{\link{sample_srs}}, \code{\link{sample_sampleWrapper}}, \code{\link{sim_sample}}, \code{\link{sample.int}}
#' @export
#' 
#' @examples 
#' sim_base_lm() %>% sim_sample(sample_csrs())
sample_csrs <- function(size = 0.05, clusterVar = "idD", ...) {
  # Size is either a integer vector length > 1 | length == 1 or a numeric with 
  # length == 1
  if(any(size >= 1)) size <- as.integer(size)
  function(dat) {
    
    # Splitting positions in dat:
    posList <- split(1:nrow(dat), dat[clusterVar])
    
    # Check input:
    if(length(size) > 1 && length(size) != length(posList)) 
      stop("length(size) needs to be 1 or equal to the number of clusters!")    
            
    # Drawing sample of positions:
    pos <- mapply(function(pos, size) {
      if(size < 1) size <- ceiling(size * length(pos))
      sample(pos, size, ...)
    }, posList, size, SIMPLIFY = FALSE) %>% unlist
    
    # Return subset:
    dat[pos, ]
  }
}


