library(saeSim)

dat <- sim(sim_base_standard(nDomains=3, nUnits = 4), 
           sim_gen_fe(generator = gen_norm(mean=50, sd=20), const=0, slope = 10), 
           sim_gen_e(generator=gen_norm(0, 1)))

setup <- sim_setup(sim_base_standard(nDomains = 100, nUnits = 100), 
                   sim_gen_fe(), sim_gen_e(), sim_gen_rec(), R = 500, simName = "test")


autoplot(setup)

plot(setup, "x")


