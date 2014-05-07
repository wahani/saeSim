################################################################################

#' class-sim_virtual
#'
#'@section Slots: 
#'  \describe{
#'    \item{\code{nDomains}:}{\code{"numeric"} of length 1, the number of domains}
#'    \item{\code{nUnits}:}{Object of class \code{"character"}, containing data that needs to go in slot2.}
#'    \item{\code{nUnits}:}{Object of class \code{"character"}, containing data that needs to go in slot2.}
#'  }
#'
#' @rdname sim_virtual
#' @aliases sim_virtual-class
#' @export
setClass("sim_virtual",
         slots = c(fun = "function"),
         contains = "VIRTUAL")

################################################################################

#' class-sim_id_virtual
#' 
#' @rdname sim_virtual
#' @aliases sim_id_virtual-class
#' @export
setClass("sim_id_virtual", 
         slots = c(nDomains = "numeric", nUnits = "numeric"),
         contains = c("sim_virtual", "VIRTUAL"), 
         prototype = prototype(nDomains = 1, nUnits = 1),
         validity = function(object) {
           nDomains <- slot(object, "nDomains")
           nUnits <- slot(object, "nUnits")
           checkTemp <- function(x) {
             if (length(x) == 1) return(TRUE)
             if (length(x) != nDomains) stop("The number of units in each area and the number of sample sizes are expected to be a scalar or a vector with the length of the number of domains!") 
           }
           if(length(nDomains) > 1) stop("The number of domains is expected to be a scalar.")
           checkTemp(nUnits)
         })

#' class-sim_sample
#' 
#' @rdname sim_virtual 
#' @aliases sim_sample-class
#' @export
setClass("sim_sample", contains = "sim_id_virtual")


#' class-sim_gen_virtual
#' 
#' @rdname sim_virtual
#' @aliases sim_gen_virtual-class
#' @export
setClass("sim_gen_virtual",
         slots = c(const = "numeric", slope = "numeric", name = "character"),
         contains = c("sim_id_virtual", "VIRTUAL"),
         validity = function(object) {
           if(length(slot(object, "const")) != 1) 
             return("The argument 'const' is expected to be a scalar!")
           if(length(slot(object, "slope")) != 1) 
             return("The argument 'slope' is expected to be a scalar!")
           TRUE
         })

################################################################################

#' class-sim_gen
#' 
#' @rdname sim_virtual
#' @aliases sim_gen-class
#' @export
setClass("sim_gen", contains = "sim_gen_virtual")

#' class-sim_genCont_virtual
#' 
#' @rdname sim_virtual
#' @aliases sim_genCont_virtual-class
#' @export
setClass("sim_genCont_virtual",
         slots = c(nCont = "numeric", level = "character", fixed = "logical"),
         contains = c("sim_gen_virtual", "VIRTUAL"),
         validity = function(object) {
           if(any(object@nCont <= 0)) 
             return("nCont is expected to be larger than 0!")
           if(length(object@nCont) == 1 && object@nCont == 1) 
             warning("nCont is equal to 1, will not be interpreted as proportion!")
           if(!(object@level %in% c("area", "unit", "none"))) 
             return("Supported levels are area, unit and none!")
           if(length(object@nCont) > 1 & (object@level %in% c("area", "none"))) 
             return("A vector of nCont on level area or none can not be interpreted!")
           TRUE
         })

#' class-sim_genCont
#' 
#' @rdname sim_virtual
#' @aliases sim_genCont-class
#' @export
setClass("sim_genCont", contains = "sim_genCont_virtual")

################################################################################

#' class-sim_agg
#' 
#' @rdname sim_virtual 
#' @aliases sim_agg-class
#' @export
setClass("sim_agg", contains = "sim_virtual")

################################################################################

#' class-sim_calc_virtual
#' 
#' @rdname sim_virtual 
#' @aliases sim_calc_virtual-class
#' @export
setClass("sim_calc_virtual", contains = c("sim_virtual", "VIRTUAL"))

#' class-sim_cpopulation
#' 
#' @rdname sim_virtual 
#' @aliases sim_cpopulation-class
#' @export
setClass("sim_cpopulation", contains = c("sim_calc_virtual"))

#' class-sim_csample
#' 
#' @rdname sim_virtual 
#' @aliases sim_csample-class
#' @export
setClass("sim_csample", contains = c("sim_calc_virtual"))

#' class-sim_cagg
#' 
#' @rdname sim_virtual 
#' @aliases sim_cagg-class
#' @export
setClass("sim_cagg", contains = c("sim_calc_virtual"))
