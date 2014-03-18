context("sim_setup")
test_that("sim_setup", {
  tmp <- sim_setup(sim_base_standard(nDomains = 3, nUnits = 4), sim_gen_fe(), sim_gen_e(), R = 500, simName = "")
  
  expect_that(length(tmp), equals(2))
  expect_that(all(is.smstp(tmp)), is_true())
})
