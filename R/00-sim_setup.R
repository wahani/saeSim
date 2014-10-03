setClass("sim_base", contains = "list")

setClass("sim_setup", 
         slots = c(base = "sim_base", simName = "character"), 
         contains = "list")