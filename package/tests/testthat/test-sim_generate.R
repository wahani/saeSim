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

test_that("sim_gen", code={
  setup1 <- sim_base_standard() %+% 
    sim_gen(gen_norm(0, 4), const = 100, name = "x") %+% 
    sim_gen(gen_norm(0, 4), name = "e") %+% 
    sim_gen(gen_norm(0, 150), name = "e", nCont = 0.05, level = "unit", fixed = TRUE)
  setup2 <- sim_base_standard() %+% sim_gen_fe() %+% sim_gen_e() %+% sim_gen_ec()
  
  set.seed(1)
  result1 <- sim(setup1, R = 1)
  set.seed(1)
  result2 <- sim(setup2, R = 1)
  
  expect_that(result2, equals(result1))
})
