setClass("sim_base", contains = "list")

setClass("sim_setup", 
         slots = c(base = "sim_base", R = "numeric", simName = "character"), 
         contains = "list")