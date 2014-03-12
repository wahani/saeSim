sim_generate(new("smstp_fe", nDomains = 2, nUnits = c(3, 5), 
                 generator = generator_fe_norm(), slope = 1, const = 2))

dat <- sim(sim_base_standard(nDomains=5, nUnits = 2), sim_fe(), sim_re(),
           sim_rec(nCont = 0.05))


