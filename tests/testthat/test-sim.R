context("sim")
test_that("Method for base", {
  dat <- sim(sim_base_standard(nDomains=3, nUnits = 4), 
             # Fixed-Effects: drawn from N(50, 20^2), b0 = 0, slope = 10
             sim_gen_fe(generator = gen_norm(mean=50, sd=20, name = "x")), 
             # Model-Error: e ~ N(0, 1)
             sim_gen_e(generator=gen_norm(0, 1)),
             # Random-Intercept: v ~ N(0, 1)
             sim_gen_re(gen_v_norm(0, 1)),
             # Correlated random-effect following a SAR(1)
             sim_gen_re(gen_v_sar(mean=0, sd=2, rho=0.5, type="rook", name = "v_sp")),
             # Adding outliers in each error-component:
             # 5% in each area,at least 1, those with highest ID:
             sim_gen_ec(gen_norm(sd = 150), nCont=0.05, level="unit", fixed=TRUE),
             # 5% of the areas, at least 1, those with highest ID
             sim_gen_rec(gen_v_norm(sd = 50), nCont=0.05, level="area", fixed=TRUE),
             # 2 Areas, randomly chosen
             sim_gen_rec(gen_v_sar(sd = 50, name = "v_sp"), nCont=2, level="area", fixed=FALSE),
             # 1 in area1, 2 in area2, 1 in area3
             sim_gen_rec(gen_norm(mean = 10, sd = 1), nCont = c(1, 2, 1), level = "unit", fixed = TRUE),
             # 2 outliers, somewhere...
             sim_gen_rec(gen_norm(mean = 10, sd = 1), nCont = 2, level = "none", fixed = FALSE)
  )
  
  expect_that(nrow(dat), equals(12))
  expect_that(ncol(dat), equals(7))
  expect_that(all(c("idU", "idD") %in% names(dat)), is_true())
  
})

test_that("Method for sim_setup", {
  setup <- sim_setup(sim_base_standard(nDomains = 4, nUnits = 3), 
                     sim_gen_fe(), sim_gen_e(), R = 500, simName = "test")
  datList <- sim(setup)
  
  expect_that(length(datList), equals(500))
  expect_that(max(rbind_all(datList)$idR), equals(500))
  expect_that(all(rbind_all(datList)$simName == "test"), is_true())
  
})