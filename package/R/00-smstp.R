#' The smstp class
#'
#'@section Slots: 
#'  \describe{
#'    \item{\code{nDomains}:}{\code{"numeric"} of length 1, the number of domains}
#'    \item{\code{nUnits}:}{Object of class \code{"character"}, containing data that needs to go in slot2.}
#'    \item{\code{nUnits}:}{Object of class \code{"character"}, containing data that needs to go in slot2.}
#'  }
#'
#' @rdname smstp
#' @aliases smstp-class
#' @exportClass smstp
setClass("smstp", 
         slots = c(nDomains = "numeric", nUnits = "numeric"),
         contains = "VIRTUAL", 
         prototype = prototype(nDomains = 1, nUnits = 1),
         validity = function(object) {
           nDomains <- slot(object, "nDomains")
           nUnits <- slot(object, "nUnits")
           #nSample <- slot(object, "nSample")
           checkTemp <- function(x) {
             if (length(x) == 1) return(TRUE)
             if (length(x) != nDomains) stop("The number of units in each area and the number of sample sizes are expected to be a scalar or a vector with the length of the number of domains!") 
           }
           if(length(nDomains) > 1) stop("The number of domains is expected to be a scalar.")
           checkTemp(nUnits)
           #checkTemp(nSample)
         })