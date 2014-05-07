#' @export
sample_sampleWrapper <- function(...) {
  function(nDomains, nUnits) {
    sample(...)
  }
}

#' @export
sample_srs <- function(size = 0.05, ...) {
  function(nDomains, nUnits) {
    id <- make_id(nDomains, if (length(nUnits) == 1) nUnits else as.list(nUnits))
    sample.int(nrow(id), if(is.integer(size)) size else ceiling(size * nrow(id)), ...)
  }
}

#' @export
sample_csrs <- function(size = 0.05, ...) {
  function(nDomains, nUnits) {
    id <- make_id(nDomains, if (length(nUnits) == 1) nUnits else as.list(nUnits))
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


