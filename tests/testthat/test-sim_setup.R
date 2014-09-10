context("sim_setup")
test_that("sim_setup", {
  tmp <- sim_setup(sim_base_standard(nDomains = 3, nUnits = 4), sim_gen_fe(), 
                   sim_gen_e(), R = 500, simName = "")
  
  expect_that(length(tmp), equals(2))
  expect_that(all(is.sim_gen_virtual(tmp)), is_true())
})

test_that("methods equal", {
  setup <- sim_base_standard() %&% sim_gen_fe() %&% sim_gen_e() %&% sim_agg()
  cat("\n")
  expect_that(show({set.seed(1);sim_setup(setup, sim_sample())}), equals(show({set.seed(1);setup %&% sim_sample()})))
})

context("sim_setup-methods")
test_that("as.data.frame", {
  setup <- sim_lm()
  dat <- as.data.frame(setup)
  expect_is(dat, class="data.frame")
  expect_equal(nrow(dat), 10000)
  expect_true(all(names(dat) %in% c("idD", "idU", "y", "x", "e")))
})

test_that("autoplot", {
  expect_warning(autoplot(sim_lm(), x = "z"))
  expect_warning(autoplot(sim_lm(), y = "k"))
})

test_that("Id construction for not simulated data.frames", {
  dat <- data.frame(id = 1:10, x = rnorm(10))
  dat1 <- dat %>% sim_base_data("id") %>% as.data.frame
  dat2 <- dat %>% sim_setup(domainID = "id") %>% as.data.frame
  resultList <- sim_setup(dat, R = 10, simName = "testthat", domainID = "id") %>% sim
  
  expect_equal(dat1, dat2)
  expect_equal(length(resultList), 10)
  expect_true(all(names(resultList[[2]]) %in% c("idD", "idU", "idR", "simName", "x", "id")))
})

test_that("sim_setup sorts its content", {
  setup <- sim_setup(sim_base_standard(3, 3), sim_agg(), sim_sample(), sim_n(), sim_N(), sim_gen_re(), sim_gen_fe())
  expect_true(inherits(setup[[1]], "sim_gen"))
  expect_true(inherits(setup[[2]], "sim_gen"))
  expect_true(inherits(setup[[3]], "sim_cpopulation"))
  expect_true(inherits(setup[[4]], "sim_sample"))
  expect_true(inherits(setup[[5]], "sim_csample"))
  expect_true(inherits(setup[[6]], "sim_agg"))
})