context("sim_generate")
test_that("sim_generate for smstp_fe", code={
  test_out <- sim(new("sim_gen", nDomains = 2, nUnits = c(3, 5),
                      fun = gen_norm(), 
                      slope = 1, const = 2, name = "x"))
  
  expect_that(length(test_out), equals(4))
  expect_that(nrow(test_out), equals(8))
  expect_that(max(test_out$idU), equals(5))
  expect_that(max(test_out$idD), equals(2))
})

