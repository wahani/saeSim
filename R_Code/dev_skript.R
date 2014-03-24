library(saeSim)
library(testthat)

setup <- sim_base_standard() %+% sim_gen_fe() %+% sim_gen_e() %+% sim_agg()

autoplot(setup %+% sim_gen_rec())

plot(setup %+% sim_gen_ec())
setup %+% sim_agg()

