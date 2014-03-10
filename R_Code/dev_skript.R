sim_generate(new("smstp_fe", nDomains = 2, nUnits = c(3, 5), 
                 generator = generator_fe_norm(), slope = 1, const = 2))

sim(sim_base_standard(), sim_fe(), sim_fe(), sim_e())
