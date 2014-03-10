sim_generate(new("smstp_fe", nDomains = 2, nUnits = c(3, 5), nSample = 2, 
                 generator = generator_fe_norm(), slope = 1, const = 2))

sim(sim_base_standard(nDomains = 2, nUnits = c(3, 5)), 
    sim_fe(generator = generator_fe_norm(), slope = 1, const = 2),
    sim_fe(generator = generator_fe_norm(), slope = 1, const = 2))
