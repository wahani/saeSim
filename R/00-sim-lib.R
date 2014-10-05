# Imports of packages:
#' @import dplyr
#' @import methods
#' @import ggplot2
#' @import parallel
#' @export %>%

################################################################################

setClass("sim_virtual",
         slots = c(fun = "function"),
         contains = "VIRTUAL")

################################################################################

setClass("sim_id_virtual", 
#          slots = c(nDomains = "numeric", nUnits = "numeric"),
         contains = c("sim_virtual", "VIRTUAL"), 
#          prototype = prototype(nDomains = 1, nUnits = 1),
#          validity = function(object) {
#            nDomains <- slot(object, "nDomains")
#            nUnits <- slot(object, "nUnits")
#            checkTemp <- function(x) {
#              if (length(x) == 1) return(TRUE)
#              if (length(x) != nDomains) stop("The number of units in each area and the number of sample sizes are expected to be a scalar or a vector with the length of the number of domains!") 
#            }
#            if(length(nDomains) > 1) stop("The number of domains is expected to be a scalar.")
#            checkTemp(nUnits)
#          })
)
setClass("sim_sample", contains = "sim_id_virtual")

setClass("sim_gen_virtual",
         contains = c("sim_id_virtual", "VIRTUAL"))

################################################################################

setClass("sim_gen", contains = "sim_gen_virtual")

setClass("sim_genCont_virtual",
         contains = c("sim_gen_virtual", "VIRTUAL"))

setClass("sim_genCont", contains = "sim_genCont_virtual")

################################################################################

setClass("sim_resp", contains = "sim_virtual")

################################################################################

setClass("sim_agg", contains = "sim_virtual")

################################################################################

setClass("sim_calc_virtual", contains = c("sim_virtual", "VIRTUAL"))

setClass("sim_cpopulation", contains = c("sim_calc_virtual"))

setClass("sim_csample", contains = c("sim_calc_virtual"))

setClass("sim_cagg", contains = c("sim_calc_virtual"))
