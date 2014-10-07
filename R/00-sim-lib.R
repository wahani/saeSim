# Imports of packages:
#' @import dplyr
#' @import methods
#' @import ggplot2
#' @import parallel

################################################################################

setClass("sim_fun",
         slots = c(order = "numeric"),
         contains = "function")

################################################################################

setClass("sim_setup", 
         slots = c(base = "data.frame", simName = "character"), 
         contains = "list")