context("sim_calc")
test_that("sim_calc and calc_var", {
  setup <- sim_setup(sim_base_standard(nDomains=5, nUnits = 10), 
                     sim_gen_fe(generator = gen_norm(mean=50, sd=20), const=0, slope = 10), 
                     sim_gen_e(generator=gen_norm(0, 1)), 
                     sim_gen_ec(),
                     sim_sample(sample_csrs(size=5)), R = 1)
  
  dat <- sim(setup %&% 
               sim_calc(calc_var("y", funList = list("mean" = mean, "var" = var), 
                                 exclude = "idC", newName = "pop")) %&%
               sim_calc(calc_var(varName = "y", funList = list("length" = length), newName = "N")) %&% 
               sim_calc(calc_var(varName = "y", funList = list("length" = length), newName = "n"), level = "sample") %&% 
               sim_calc(calc_var(varName = "y", funList = list("length" = length)), level = "sample") %&% 
               sim_calc(calc_var(varName = "y", funList = list(max)), level = "sample"))[[1]]
  
  calc_lm <- function(dat) {
    dat$linearPredictor <- predict(lm(y ~ x, data = dat))
    dat
  }
  
  dat1 <- sim(setup %&% sim_agg() %&% sim_calc(calc_lm, level="agg"))[[1]]
  
  expect_that(nrow(dat), equals(25))
  expect_that(all(c("popMean", "popVar", "N", "n", "yLength", "y1") %in% names(dat)), is_true())
  expect_that(unique(dat$n), equals(5))
  expect_that(unique(dat$N), equals(10))
  expect_that(dat1$linearPredictor, is_equivalent_to(predict(lm(y ~ x, data = dat1))))
})
