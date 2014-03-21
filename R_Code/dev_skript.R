library(saeSim)
library(testthat)

dat <- sim(sim_base_standard(), 
           sim_gen_fe(generator = gen_norm(mean=50, sd=20), const=0, slope = 10), 
           sim_gen_e(generator=gen_norm(0, 1)), 
           sim_gen_ec())


setup <- sim_base_standard() %+% sim_gen_e() %+% sim_gen_fe() %+% sim_calc(calc_var(c(N = "y"), funNames="length"))

autoplot(setup %+% sim_gen_ec())
plot(setup %+% sim_gen_rec())


