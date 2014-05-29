context("%&%")
test_that("basic functionality", {
  setup <- sim_setup(sim_base_standard(nDomains = 10, nUnits = 100), sim_gen_e(), R = 1)
  setup1 <- sim_setup(sim_base_standard(nDomains = 10, nUnits = 10), sim_gen_fe(), R = 1)
  
  expect_that(dim(sim(setup %&% sim_gen_re())[[1]]), equals(c(1000, 7)))
  expect_that(dim(sim(setup1 %&% setup %&% sim_gen_ec())[[1]]), equals(c(100, 8)))
})
