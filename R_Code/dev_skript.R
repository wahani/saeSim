library(saeSim)
library(testthat)

setup <- sim_base_standard() %+% sim_gen_fe() %+% sim_gen_e()

autoplot(setup %+% sim_gen_rec())

plot(setup %+% sim_gen_ec())
setup %+% sim_agg()

dat <- sim(setup)[[1]]
summary(lm(y ~ x, data = dat))


sim_lmc() %+% sim_n() %+% sim_N() %+% sim_trueMean() %+% sim_trueVar() %+% sim_sample()

