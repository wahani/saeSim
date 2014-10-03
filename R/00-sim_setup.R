setClass("sim_setup", 
         slots = c(base = "data.frame", simName = "character"), 
         contains = "list")