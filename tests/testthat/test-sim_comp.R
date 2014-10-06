context("sim_comp")
test_that("sim_calc and calc_var", {
  setup <- sim_base(base_id(nDomains=5, nUnits = 10)) %>% 
    sim_gen_fe(generator = gen_norm(mean=50, sd=20, name = "x")) %>%
    sim_gen_e(generator=gen_norm(0, 1)) %>%
    sim_gen_ec() %>%
    sim_sample(sample_number(size=5, groupVars = "idD")) %>%
    sim_resp(resp_eq(y = 10 * x + e))
  
  dat <- setup %>% 
    sim_comp_popMean() %>% sim_comp_popVar %>% sim_comp_N() %>%
    sim_comp_n() %>% 
    as.data.frame
  
  calc_lm <- function(dat) {
    dat$linearPredictor <- predict(lm(y ~ x, data = dat))
    dat
  }
  
  dat1 <- sim(setup %>% sim_agg() %>% sim_comp_agg(calc_lm))[[1]]
  
  expect_that(nrow(dat), equals(25))
  expect_that(all(c("popMean", "popVar", "N", "n") %in% names(dat)), is_true())
  expect_that(unique(dat$n), equals(5))
  expect_that(unique(dat$N), equals(10))
  expect_that(dat1$linearPredictor, is_equivalent_to(predict(lm(y ~ x, data = dat1))))
})