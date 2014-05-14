# Imports of packages:
#' @import dplyr
#' @import methods

################################################################################

setClass("sim_virtual",
         slots = c(fun = "function"),
         contains = "VIRTUAL")

################################################################################

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

setClass("sim_sample", contains = "sim_id_virtual")

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

setClass("sim_gen", contains = "sim_gen_virtual")

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

setClass("sim_genCont", contains = "sim_genCont_virtual")

################################################################################

setClass("sim_agg", contains = "sim_virtual")

################################################################################

setClass("sim_calc_virtual", contains = c("sim_virtual", "VIRTUAL"))

setClass("sim_cpopulation", contains = c("sim_calc_virtual"))

setClass("sim_csample", contains = c("sim_calc_virtual"))

setClass("sim_cagg", contains = c("sim_calc_virtual"))
