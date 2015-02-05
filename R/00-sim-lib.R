################################################################################

setClass("sim_fun",
         slots = c(order = "numeric"),
         contains = "function")

################################################################################

setClass("sim_setup", 
         slots = c(base = "data.frame", simName = "character"), 
         contains = "list")