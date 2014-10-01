context("sim_generate")
test_that("sim_generate for smstp_fe", code={
  test_out <- sim(sim_base_standard(nDomains = 2, nUnits = c(3, 5)),
                  sim_gen_fe())
  
  expect_that(length(test_out), equals(3))
  expect_that(nrow(test_out), equals(8))
  expect_that(max(test_out$idU), equals(5))
  expect_that(max(test_out$idD), equals(2))
})

test_that("sim_gen", code={
  setup1 <- sim_base_standard() %&% 
    sim_gen(gen_norm(0, 4, name = "x"), const = 100) %&% 
    sim_gen(gen_norm(0, 4, "e")) %&% 
    sim_gen(gen_norm(0, 150, "e"), nCont = 0.05, level = "unit", fixed = TRUE)
  setup2 <- sim_base_standard() %&% sim_gen_fe() %&% sim_gen_e() %&% sim_gen_ec()
  
  set.seed(1)
  result1 <- sim(setup1, R = 1)
  set.seed(1)
  result2 <- sim(setup2, R = 1)
  
  expect_that(result2, equals(result1))
})

test_that("gen_generic", {
  # Generator itself
  dat1 <- gen_generic(runif, level = "domain", name = "x")(make_id(5, 2))
  dat2 <- gen_generic(runif, level = "unit", name = "x")(make_id(5, 2))
  expect_is(dat1, "data.frame")
  expect_equal(nrow(dat1), 10)
  expect_equal(dat1[1, "x"], dat1[2, "x"])
  expect_equal(unique(dat2["x"]), dat2["x"])
  expect_error(gen_generic(runif, level = "")(5, 2, "x"))
  
  # In a set-up
  set.seed(1)
  dat1 <- sim(sim_base_standard(), 
      sim_gen(gen_generic(rnorm, mean = 0, sd = 4, name="e")),
      sim_gen(gen_generic(rnorm, mean = 0, sd = 1, level = "domain", name="v")))
  set.seed(1)
  dat2 <- sim(sim_base_standard(), 
              sim_gen_e(),
              sim_gen_re())
  expect_equal(dat1, dat2)
})

test_that("adding variables works correctly", {
  result1 <- sim(sim_base_standard(), sim_gen_fe())
  result2 <- sim(sim_base_standard(), sim_gen_fe(const = 10, slope = 0))
  result3 <- sim(sim_base_standard(), sim_gen_fe(const = 0, slope = 0))
  dat <- sim_lmc() %>% as.data.frame
  expect_that(as.numeric(coefficients(lm(y ~ x, data = result1))), equals(c(100, 1)))
  expect_that(as.numeric(coefficients(lm(y ~ x, data = result2))), equals(c(10, 0)))
  expect_that(as.numeric(coefficients(lm(y ~ x, data = result3))), equals(c(0, 0)))
  expect_equal(100 + dat$x + dat$e, dat$y)
})