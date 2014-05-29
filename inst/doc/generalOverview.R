## ----include=FALSE-------------------------------------------------------
options(markdown.HTML.header = system.file('misc', 'vignette.css', package='knitr'))

## ----eval=FALSE----------------------------------------------------------
#  setup <- sim_setup(sim_base_standard(), sim_gen_fe(), sim_gen_e(), R = 500,
#                     simName = "Doku")

## ----eval=FALSE----------------------------------------------------------
#  setup <- sim_base_standard() %+% sim_gen_fe() %+% sim_gen_e()

## ----eval=FALSE----------------------------------------------------------
#  dataList <- sim(setup)

## ----eval=FALSE----------------------------------------------------------
#  simData <- sim(sim_base_standard(), sim_gen_fe(), sim_gen_e())

## ----eval=FALSE----------------------------------------------------------
#  setup <- setup %+% sim_gen_rec() %+% sim_gen_ec()
#  anotherSetup <- sim_setup(sim_base_standard(), R = 5)
#  setup <- setup %+% anotherSetup

## ------------------------------------------------------------------------
library(saeSim)
setup <- sim_setup(sim_base_standard(), sim_gen_fe(), sim_gen_e(), sim_gen_re(), sim_gen_re(gen_v_sar(), "vSp"))
# This will result in the same set-up:
setup <- sim_lmm() %+% sim_gen_re(gen_v_sar(), "vSp")

## ----eval=FALSE----------------------------------------------------------
#  dataList <- sim(setup)

## ------------------------------------------------------------------------
contSetup <- setup %+% 
  sim_gen_rec(gen_v_sar(sd = 40), nCont = 0.05, level = "area", fixed = TRUE, 
              name = "vSp")

## ------------------------------------------------------------------------
sim(sim_base_standard(3, 4), 
    sim_gen_fe(), sim_gen_e(), 
    sim_gen_ec(nCont = c(1, 2, 3), level = "unit", name = "eCont"))

## ------------------------------------------------------------------------
sim(sim_base_standard(3, 4), sim_gen_fe(), sim_sample(sample_srs(1L)))
sim(sim_base_standard(3, 4), sim_gen_fe(), sim_sample(sample_csrs(1L)))

## ----eval=FALSE----------------------------------------------------------
#  # simple random sampling:
#  setup %+% sim_sample(sample_srs(size = 10L))
#  setup %+% sim_sample(sample_srs(size = 0.05))
#  # srs in each domain/cluster
#  setup %+% sim_sample(sample_csrs(size = 10L))
#  setup %+% sim_sample(sample_csrs(size = rep(10L, 100)))
#  setup %+% sim_sample(sample_csrs(size = 0.05))

## ------------------------------------------------------------------------
sim_setup(setup, sim_agg())

## ------------------------------------------------------------------------
sim(sim_base_standard(3, 4), sim_gen_fe(), sim_gen_e(), sim_gen_ec(), 
    sim_calc(calc_var(varName = "y", funList = list(mean = mean, var = var), 
                      exclude = "idC", by = "idD"), level = "population"))
sim(sim_base_standard(3, 4), sim_gen_fe(), sim_gen_e(), sim_gen_ec(), 
    sim_calc(calc_var(varName = "y", funList = list(mean = mean, var = var), 
                      exclude = NULL, by = "idD"), level = "population"))
setup %+% sim_calc(calc_var(varName = "y", funList = list(length), newName = "N"), 
                   level = "population")
setup %+% 
  sim_sample() %+%
  sim_calc(calc_var(varName = "y", funList = list(length), newName = "n"), 
           level = "sample")

## ------------------------------------------------------------------------
sim(sim_base_standard(3, 4), sim_gen_fe(), sim_gen_e(), sim_gen_ec(), sim_popMean())

## ------------------------------------------------------------------------
setup
plot(setup)
autoplot(setup)
autoplot(setup, "e")

## ------------------------------------------------------------------------
autoplot(setup %+% sim_gen_rec())

