sim_fe <- function(generator = generator_fe_norm(), const = 100, slope = 1) {
  function(sim_base) {
    new("smstp_fe", nDomains = sim_base$nDomains, nUnits = sim_base$nUnits, 
        generator = generator, slope = slope, const = const)
  }
}

sim_e <- function(generator = generator_e_norm()) {
  function(sim_base) {
    new("smstp_", nDomains = sim_base$nDomains, nUnits = sim_base$nUnits, 
        generator = generator)
  }
}