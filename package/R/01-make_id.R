#' Construct ID-Variables
#' @description This function can be used to construct a data frame with \code{id*} variables. This is helpful for user written generator functions.
#' @param nDomains The number of domains. Can be considered as cluster variable.
#' @param nUnits The number of units in each domain. If \code{length(nUnits) > 1} each elemnt is the number of units in each domain respectively.
#' 
#' @rdname make_id
#' @export
#' @examples
#' make_id(2, 2)
#' make_id(2, c(2, 3))
setGeneric("make_id", function(nDomains, nUnits, ...) {
  stopifnot(length(nDomains) == 1, 
            if(length(nUnits) > 1) length(nUnits) == nDomains else TRUE)
  standardGeneric("make_id")
})

#' @rdname make_id
#' @export
setMethod("make_id", signature=c(nDomains = "numeric", nUnits = "numeric"),
          function(nDomains, nUnits, ...) {
            if(length(nUnits) == 1) {
              out <- data.frame(idD = rep(1:nDomains, each = nUnits)) %.% 
                group_by("idD") %.% mutate(idU = 1:n())
              return(as.data.frame(out))
            } else {
              make_id(nDomains, as.list(nUnits))
            }
            
          })

setMethod("make_id", signature=c(nDomains = "numeric", nUnits = "list"),
          function(nDomains, nUnits, ...) {
            out <- 
              data.frame(idD = unlist(lapply(1:nDomains, 
                                             function(i) rep(i, nUnits[[i]])))) %.% 
              group_by("idD") %.% mutate(idU = 1:n())
            as.data.frame(out)
          })