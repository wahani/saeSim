context("base_id: ")
test_that("base_id", {
  expect_equal(base_id(3, c(1, 2, 3)), data.frame(idD = c(1, 2, 2, 3, 3, 3), idU = c(1, 1, 2, 1, 2, 3)))
  expect_equal(base_id(3, 1), data.frame(idD = c(1, 2, 3)))
})