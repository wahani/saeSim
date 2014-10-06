#' Construct ID-Variables
#' @description This function can be used to construct a data frame with grouping/\code{ID} variables. This is helpful for user written generator functions.
#' @param nDomains The number of domains. Can be considered as cluster variable.
#' @param nUnits The number of units in each domain. If \code{length(nUnits) > 1} each elemnt is the number of units in each domain respectively.
#' @param ... arguments passed to methods.
#' 
#' @rdname base_id
#' @export
#' @examples
#' base_id(2, 2)
#' base_id(2, c(2, 3))
base_id <- function(nDomains = 10, nUnits = 10) {
  
  stopifnot(length(nDomains) == 1, 
            if(length(nUnits) > 1) length(nUnits) == nDomains else TRUE)
  
  out <- data.frame(idD = rep(1:nDomains, times = nUnits)) %>% 
    group_by("idD") %>% mutate(idU = 1:n()) %>% arrange(idD, idU)
  as.data.frame(out)
  
}



