## ----include=FALSE-------------------------------------------------------
options(markdown.HTML.header = system.file('misc', 'vignette.css', package='knitr'))

## ------------------------------------------------------------------------
library(saeSim)
setup <- sim_base() %>% sim_gen_fe() %>% sim_gen_e() %>% 
  sim_resp_eq(y = 100 + 2 * x + e) %>% sim_simName("Doku")

## ----eval=FALSE----------------------------------------------------------
#  dataList <- sim(setup)

## ----eval=FALSE----------------------------------------------------------
#  simData <- sim(sim_base(), sim_gen_fe(), sim_gen_e())

## ----eval=FALSE----------------------------------------------------------
#  setup <- setup %>% sim_gen_rec() %>% sim_gen_ec()
#  anotherSetup <- sim_base()
#  # setup <- setup %>% anotherSetup

## ------------------------------------------------------------------------
sim_base_lm() %>% sim_agg()

## ------------------------------------------------------------------------
setup <- sim_base_lmm()
plot(setup)
library(ggplot2)
autoplot(setup)
autoplot(setup, "e")

## ------------------------------------------------------------------------
autoplot(setup %>% sim_gen_rec())

