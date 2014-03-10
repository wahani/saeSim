setClass("sim_rs", contains = "data.frame")
setClass("sim_rs_fe", contains = "sim_rs")

# 
setClass("sim_base", contains = "list")
# generator functions:
sim_base_standard <- function(nDomains = 100, nUnits = 100) {
  new("sim_base", list(nDomains = nDomains, nUnits = nUnits))
}
