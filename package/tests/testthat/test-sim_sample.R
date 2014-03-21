context("sim_sample")
test_that("Basic sampling functionality", {
  dat <- sim(sim_base_standard(nDomains=3, nUnits = 4), 
             sim_gen_fe(generator = gen_norm(mean=50, sd=20), const=0, slope = 10), 
             sim_gen_e(generator=gen_norm(0, 1)))
  
  expect_that(nrow(dat[sample_sampleWrapper(12L, 5)(),]), equals(5))
  expect_that(nrow(dat[sample_srs(size = 0.05)(3, 4),]), equals(1))
  expect_that(nrow(dat[sample_srs(size = 5L)(3, 4),]), equals(5))
  expect_that(nrow(dat[sample_csrs(size = 2L)(3, 4), ]), equals(6))
  expect_that(nrow(dat[sample_csrs(size = c(1L, 2L, 4L))(3, 4), ]), equals(7))
  expect_that(nrow(dat[sample_csrs(size = 0.05)(3, 4), ]), equals(3))
})

test_that("sim method is applying the sampling functions correctly",
{
  setup <- sim_setup(sim_base_standard(nDomains=3, nUnits = 10), 
                     sim_gen_fe(generator = gen_norm(mean=50, sd=20)), R = 1)
  
  expect_that(nrow(sim(setup %+% sim_sample())[[1]]), equals(15))
  expect_that(nrow(sim(setup %+% sim_sample(sample_sampleWrapper(30L, 5)))[[1]]), equals(5))
  expect_that(nrow(sim(setup %+% sim_sample(sample_srs(0.05)))[[1]]), equals(2))
  expect_that(nrow(sim(setup %+% sim_sample(sample_srs(5L)))[[1]]), equals(5))
  expect_that(nrow(sim(setup %+% sim_sample(sample_csrs(c(1L, 2L, 4L))))[[1]]), equals(7))
})
