context("sim_sample")
test_that("Attributes are preserved", {
  setup <- sim_base(base_id(nDomains=3, nUnits = 4)) %>%
    sim_gen_fe(generator = gen_norm(mean=50, sd=20, name = "x")) %>%
    sim_gen_e(generator=gen_norm(0, 1, name = "e")) %>% 
    sim_comp_pop(function(dat) {attr(dat, "x") <- 2; dat})
  
  setup %>% sim_sample(sample_csrs()) %>% as.data.frame %>% attr("x") %>% expect_equal(2)
  setup %>% sim_sample(sample_srs()) %>% as.data.frame %>% attr("x") %>% expect_equal(2)
  
})

test_that("Basic sampling functionality", {
  setup <- sim_base(base_id(nDomains=3, nUnits = 4))
  
  # 1
  setup %>% sim_sample(sample_sampleWrapper(12L, 5)) %>% as.data.frame %>% 
    nrow %>% expect_that(equals(5))
  # 2
  setup %>% sim_sample(sample_srs(size = 0.05)) %>% as.data.frame %>% 
    nrow %>% expect_that(equals(1))
  # 3
  setup %>% sim_sample(sample_srs(size = 5L)) %>% as.data.frame %>% 
    nrow %>% expect_that(equals(5))
  # 4
  setup %>% sim_sample(sample_csrs(size = 2L)) %>% as.data.frame %>% 
    nrow %>% expect_that(equals(6))
  # 5
  setup %>% sim_sample(sample_csrs(size = c(1L, 2L, 4L))) %>% as.data.frame %>% 
    nrow %>% expect_that(equals(7))
  # 6
  setup %>% sim_sample(sample_csrs(size = 0.05)) %>% as.data.frame %>% 
    nrow %>% expect_that(equals(3))
})

test_that("sim method is applying the sampling functions correctly", {
  setup <- sim_base(base_id(nDomains=3, nUnits = 10)) %>%
    sim_gen_fe(generator = gen_norm(mean=50, sd=20, name = "x"))
  
  expect_that(nrow(sim(setup %>% sim_sample())[[1]]), equals(15))
  expect_that(nrow(sim(setup %>% sim_sample(sample_sampleWrapper(30L, 5)))[[1]]), equals(5))
  expect_that(nrow(sim(setup %>% sim_sample(sample_srs(0.05)))[[1]]), equals(2))
  expect_that(nrow(sim(setup %>% sim_sample(sample_srs(5L)))[[1]]), equals(5))
  expect_that(nrow(sim(setup %>% sim_sample(sample_csrs(c(1L, 2L, 4L))))[[1]]), equals(7))
})

test_that("sample_srs() can handle integer and numeric", {
  setup <- sim_base() %>% sim_gen_fe()
  result1 <- sim(setup %>% sim_sample(sample_srs(1)), R = 1)[[1]]
  result2 <- sim(setup %>% sim_sample(sample_srs(0.5)), R = 1)[[1]]
  result3 <- sim(setup %>% sim_sample(sample_srs(5.5)), R = 1)[[1]]
  result4 <- sim(setup %>% sim_sample(sample_srs(1L)), R = 1)[[1]]
  expect_that(nrow(result1), equals(1))
  expect_that(nrow(result2), equals(5000))
  expect_that(nrow(result3), equals(5))
  expect_that(nrow(result4), equals(1))
})

test_that("sample_csrs is working with numeric input and length > 1", {
  setup <- sim_base(base_id(10, 10)) %>% sim_gen_fe()
  
  expect_equal(sum(c(2,5,4,2,4,2,3,4,2,4)), 
               setup %>% sim_sample(sample_csrs(size=c(2,5,4,2,4,2,3,4,2,4))) %>%
                 as.data.frame %>% nrow)
  expect_error(setup %>% sim_sample(sample_csrs(size=c(2,5,4,2,4,2,3,4,2))) %>% 
                 as.data.frame)
})