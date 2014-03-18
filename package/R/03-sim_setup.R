sim_setup <- function(base, ..., R = 500, simName = "test", idC = TRUE) {
  # Taking care of the sim_gen-family:
  dots <- list(...)
  if (class(dots[[1]]) == "list") dots <- dots[[1]]  
  ind_fun <- sapply(dots, inherits, what = "function")
  smstp_objects <- lapply(dots[ind_fun], 
                          function(fun) fun(base))
  # Putting everything in a list:
  new("sim_setup", base = base, R = R, simName = simName, idC = idC, c(smstp_objects, dots[!ind_fun]))
}