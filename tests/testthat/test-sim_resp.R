context("sim_response")
test_that("Construction of response works correctly", {
  result1 <- sim_base_standard() %&% sim_gen_fe() %&% sim_resp(resp_eq(y = 100 + x))
  result2 <- sim_base_standard() %&% sim_gen_fe() %&% sim_resp(resp_eq(y = 10 + 0 * x))
  result3 <- sim_base_standard() %&% sim_gen_fe() %&% sim_resp(resp_eq(y = 0 + 0 * x))
  dat <- sim_lmc() %>% as.data.frame
  
  expect_equal(as.numeric(coefficients(lm(y ~ x, data = result1))), c(100, 1))
  expect_equal(as.numeric(coefficients(lm(y ~ x, data = result2))), c(10, 0))
  expect_equal(as.numeric(coefficients(lm(y ~ x, data = result3))), c(0, 0))
  expect_equal(100 + dat$x + dat$e, dat$y)
})