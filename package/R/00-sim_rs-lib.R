#' @export
setClass("sim_rs", contains = "data.frame")

#setClass("sim_rs_fe", contains = "sim_rs")
#' @export
setClass("sim_rs_c", contains = "sim_rs")

#
#' @export
setClass("sim_base", contains = "list")
#' @export
setClass("sim_setup", 
         slots = c(base = "sim_base", R = "numeric", simName = "character", 
                   idC = "logical"), contains = "list")