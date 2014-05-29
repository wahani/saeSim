context("make_id: ")
test_that("make_id", {
  expect_that(make_id(3, c(1, 2, 3)), equals(make_id(3, list(1, 2, 3))))
})