context("sim_agg")
test_that("Basic functionality", {
  setup <- sim_setup(sim_base_standard(), R=1) %+% sim_gen_e() %+% sim_gen_fe() %+% 
    sim_calc(calc_var("y", funList=list("length" = length), newName="N")) %+% sim_agg() %+%
    sim_calc(calc_var("y", funList = list("make_factor" = function(x) factor("a"), 
                                          "make_character" = function(x) "b")))
  
  dat <- sim(setup)[[1]]
  expect_that(nrow(dat), equals(100))
  expect_that(dat$idU, is_a("NULL"))
  expect_that(dat$idD, is_a("numeric"))
  expect_that(dat$e, is_a("numeric"))
  expect_that(dat$x, is_a("numeric"))
  expect_that(dat$y, is_a("numeric"))
  expect_that(dat$N, is_a("numeric"))
  expect_that(dat$yMake_factor, is_a("factor"))
  expect_that(dat$yMake_character, is_a("character"))
  expect_that(dat$idR, is_a("integer"))
  expect_that(dat$simName, is_a("character"))
  
})