library(saeSim)
dat <- sim(sim_base_standard(nDomains=3, nUnits = 4), 
           sim_gen_fe(generator = gen_norm(mean=50, sd=20), const=0, slope = 10), 
           sim_gen_e(generator=gen_norm(0, 1)))


sim_setup(sim_base_standard(nDomains = 3, nUnits = 4), sim_gen_fe(), sim_gen_e(), R = 500, simName = "")

sim_setup <- function(base, ..., R = 500, simName = "test", idC = TRUE) {
  # Taking care of the sim_gen-family:
  dots <- list(...)
  ind_fun <- sapply(dots, inherits, what = "function")
  smstp_objects <- lapply(dots[ind_fun], 
                          function(fun) fun(base))
  # Putting everything in a list:
  new("sim_setup", base = base, R = R, simName = simName, idC = idC, c(smstp_objects, dots[!ind_fun]))
}

