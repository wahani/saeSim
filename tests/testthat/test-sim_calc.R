context("sim_calc")
test_that("sim_calc and calc_var", {
  setup <- sim_base_standard(nDomains=5, nUnits = 10) %>% 
    sim_gen_fe(generator = gen_norm(mean=50, sd=20, name = "x")) %>%
    sim_gen_e(generator=gen_norm(0, 1)) %>%
    sim_gen_ec() %>%
    sim_sample(sample_csrs(size=5)) %>%
    sim_resp(resp_eq(y = 10 * x + e))
  
  dat <- setup %>% 
    sim_calc(calc_var("y", funList = list("mean" = mean, "var" = var), 
                      exclude = "idC", newName = "pop")) %>%
    sim_calc(calc_var(varName = "y", funList = list("length" = length), newName = "N")) %>% 
    sim_calc(calc_var(varName = "y", funList = list("length" = length), newName = "n"), level = "sample") %>% 
    sim_calc(calc_var(varName = "y", funList = list("length" = length)), level = "sample") %>% 
    sim_calc(calc_var(varName = "y", funList = list(max)), level = "sample") %>% 
    as.data.frame
  
  calc_lm <- function(dat) {
    dat$linearPredictor <- predict(lm(y ~ x, data = dat))
    dat
  }
  
  dat1 <- sim(setup %>% sim_agg() %>% sim_calc(calc_lm, level="agg"))[[1]]
  
  expect_that(nrow(dat), equals(25))
  expect_that(all(c("popMean", "popVar", "N", "n", "yLength", "y1") %in% names(dat)), is_true())
  expect_that(unique(dat$n), equals(5))
  expect_that(unique(dat$N), equals(10))
  expect_that(dat1$linearPredictor, is_equivalent_to(predict(lm(y ~ x, data = dat1))))
})

test_that("calc_var length(varName) > 1", {
  setup <- sim_lm()
  set.seed(1)
  dat1 <- as.data.frame(setup %>% sim_calc(calc_var(varName=c("x", "y"))))
  set.seed(1)
  dat2 <- as.data.frame(setup %>% sim_calc(calc_var(varName=c("x", "y"), 
                                                    newName = "pop")))
  set.seed(1)
  dat3 <- as.data.frame(
    setup %>% 
      sim_calc(
        calc_var(varName=c("x", "y"), 
                 funList = list(mean), newName = c("newName1", "newName2"))))
  
  datList <- sim(setup %>% sim_calc(calc_var(varName=c("x", "y"))), R = 2)
  
  expect_true(all(c("xMean", "xVar", "yMean", "yVar") %in% names(dat1)))
  expect_false(all(dat1$xMean == dat1$yMean))
  expect_true(all(c("popMean", "popVar") %in% names(dat2)))
  expect_true(all(dat1$yMean == dat2$popMean))
  expect_true(all(c("newName1", "newName2") %in% names(dat3)))
  expect_true(all(dat1$xMean == dat3$newName1))
  expect_true(all(dat1$yMean == dat3$newName2))
  expect_true(all(Reduce(f=`%in%`, lapply(datList, names))))
})