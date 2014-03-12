sim_fe <- function(generator = gen_fe_norm(), const = 100, slope = 1) {
  function(sim_base) {
    new("smstp_fe", nDomains = sim_base$nDomains, nUnits = sim_base$nUnits, 
        generator = generator, slope = slope, const = const)
  }
}

sim_re <- function(generator = gen_e_norm()) {
  function(sim_base) {
    new("smstp_", nDomains = sim_base$nDomains, nUnits = sim_base$nUnits, 
        generator = generator)
  }
}

sim_rec <- function(generator = gen_e_norm(mean=0, sd=150), nCont = 0.05, level = "unit", fixed = TRUE) {
  function(sim_base) {
    new("smstp_c", nDomains = sim_base$nDomains, nUnits = sim_base$nUnits, generator = generator,
        nCont = nCont, level = level, fixed = fixed)
  }
}

sim_base_standard <- function(nDomains = 100, nUnits = 100) {
  new("sim_base", list(nDomains = nDomains, nUnits = nUnits))
}

sim_rec <- function(generator = gen_e_norm(), nCont = 0.05, level = "unit", fixed = TRUE) {
  function(sim_base) {
    new("smstp_c", nDomains = sim_base$nDomains, nUnits = sim_base$nUnits, generator = generator,
        nCont = nCont, level = level, fixed = fixed)
  }
}