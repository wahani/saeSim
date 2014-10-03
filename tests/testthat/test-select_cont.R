context("select_cont")
test_that(desc="select_cont", {
  dat1 <- sim_base(base_id(nDomains=5, nUnits = 2)) %>% sim_gen_e() %>% as.data.frame
  expect_that(sum(select_cont(dat1, 1L, "unit", TRUE)$e == 0), equals(5))
  expect_that(sum(select_cont(dat1, 1L, "unit", FALSE)$e == 0), equals(5))
  expect_that(sum(select_cont(dat1, 1L, "area", TRUE)$e == 0), equals(8))
  expect_that(sum(select_cont(dat1, 1L, "area", FALSE)$e == 0), equals(8))
  expect_that(sum(select_cont(dat1, 1L, "none", TRUE)$e == 0), equals(9))
  expect_that(sum(select_cont(dat1, 1L, "none", FALSE)$e == 0), equals(9))
  expect_that(sum(select_cont(dat1, 0.5, "unit", TRUE)$e == 0), equals(5))
  expect_that(sum(select_cont(dat1, 0.5, "area", TRUE)$e == 0), equals(4))
  expect_that(sum(select_cont(dat1, 0.5, "none", TRUE)$e == 0), equals(5))
  
  dat2 <- sim_base(base_id(nDomains=5, nUnits = 1:5)) %>% sim_gen_e() %>% as.data.frame
  expect_that(sum(select_cont(dat2, 1L, "unit", TRUE)$e == 0), equals(10))
  expect_that(sum(select_cont(dat2, 1L, "unit", FALSE)$e == 0), equals(10))
  expect_that(sum(select_cont(dat2, 1L, "area", TRUE)$e == 0), equals(10))
  #expect_that(sum(select_cont(dat2, 1L, "area", FALSE)$e == 0), equals(10)) this result is random
  expect_that(sum(select_cont(dat2, 1L, "none", TRUE)$e == 0), equals(14))
  expect_that(sum(select_cont(dat2, 1L, "none", FALSE)$e == 0), equals(14))
})