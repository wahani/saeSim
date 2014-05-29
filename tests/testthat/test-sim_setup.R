context("sim_setup")
test_that("sim_setup", {
  tmp <- sim_setup(sim_base_standard(nDomains = 3, nUnits = 4), sim_gen_fe(), sim_gen_e(), R = 500, simName = "")
  
  expect_that(length(tmp), equals(2))
  expect_that(all(is.sim_gen_virtual(tmp)), is_true())
})

test_that("methods equal", {
  setup <- sim_base_standard() %+% sim_gen_fe() %+% sim_gen_e() %+% sim_agg()
  cat("\n Show methods, sorry for that:\n")
  expect_that(show({set.seed(1);sim_setup(setup, sim_sample())}), equals(show({set.seed(1);setup %+% sim_sample()})))
  cat("\n")
})

context("sim_setup-methods")
test_that("as.data.frame", {
  setup <- sim_lm()
  dat <- as.data.frame(setup)
  expect_is(dat, class="data.frame")
  expect_equal(nrow(dat), 10000)
  expect_true(all(names(dat) %in% c("idD", "idU", "y", "x", "e")))
})