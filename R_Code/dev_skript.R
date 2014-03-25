library(saeSim)
library(testthat)

setup <- sim_base_standard() %+% sim_gen_fe() %+% sim_gen_e() %+% sim_gen_re() %+% sim_gen_ec() %+% sim_gen_rec()

autoplot(setup %+% sim_gen_rec())

plot(setup %+% sim_gen_ec())
setup %+% sim_agg()

dat <- sim(setup)[[1]]
summary(lm(y ~ x, data = dat))

sim_lmc() %+% sim_n() %+% sim_N() %+% sim_trueMean() %+% sim_trueVar() %+% sim_sample()

S3Part(setup)



varNames <- character()

cat("\n", setup@simName)
cat("\nNumber runs: ", setup@R)
cat("\nNumber of Domains:", setup@base$nDomains)
cat("\nNumber of Units p.D:", setup@base$nUnits)

cat("\nVariables")
for (sim_obj in setup[is.smstp_(setup)]) {
  cat("\n", sim_obj@name, get("desc", envir = environment(sim_obj@generator)))
}

