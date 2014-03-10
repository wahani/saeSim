sim_fe <- function(generator = generator_fe_norm(), slope = 1, const = 2) {
  function(sim_base) {
    new("smstp_fe", nDomains = sim_base$nDomains, nUnits = sim_base$nUnits, 
        generator = generator, slope = 1, const = 100)
  }
}