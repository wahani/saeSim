context("sim_base")
test_that("sim_base_data", {
  data(diamonds, envir=environment(), package = "ggplot2")
  diamonds <- diamonds[1:1000, ]
  diamonds["clusterVariable"] <- 1:nrow(diamonds)
  setup <- sim_base_data(data=diamonds, "clusterVariable")
  dat <- sim(setup %+% sim_gen_e(), R = 1)[[1]]
  expect_equal(nrow(dat), 1000)
  expect_equal(names(dat), c(c("idD", "idU"), names(diamonds), c("e", "idR", "simName")))
})