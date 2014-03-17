sim_gen_fe <- function(generator = gen_norm(), const = 100, slope = 1, name = "x") {
  function(sim_base) {
    new("smstp_fe", nDomains = sim_base$nDomains, nUnits = sim_base$nUnits, 
        generator = generator, slope = slope, const = const, name = name)
  }
}

sim_gen_e <- function(generator = gen_norm(), name = "e") {
  function(sim_base) {
    new("smstp_", nDomains = sim_base$nDomains, nUnits = sim_base$nUnits, 
        generator = generator, name = name)
  }
}

sim_gen_ec <- function(generator = gen_norm(mean=0, sd=150), nCont = 0.05, level = "unit", fixed = TRUE, name = "e") {
  function(sim_base) {
    new("smstp_c", nDomains = sim_base$nDomains, nUnits = sim_base$nUnits, generator = generator,
        nCont = nCont, level = level, fixed = fixed, name = name)
  }
}



# wrapper:
sim_gen_re <- function(generator = gen_v_norm(), name = "v") {
  sim_gen_e(generator, name)
}

sim_gen_rec <- function(generator = gen_v_norm(mean=0, sd=40), nCont = 0.05, level = "area", fixed = TRUE, name = "v") {
  sim_gen_ec(generator, nCont, level, fixed, name)
}


# Base:
sim_base_standard <- function(nDomains = 100, nUnits = 100) {
  new("sim_base", list(nDomains = nDomains, nUnits = nUnits))
}
