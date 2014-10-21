## ----include=FALSE-------------------------------------------------------
options(markdown.HTML.header = system.file('misc', 'vignette.css', package='knitr'))

## ------------------------------------------------------------------------
library(saeSim)
setup <- sim_base() %>% sim_gen_x() %>% sim_gen_e() %>% 
  sim_resp_eq(y = 100 + 2 * x + e) %>% sim_simName("Doku")
setup

## ----eval=FALSE----------------------------------------------------------
#  dataList <- sim(setup, R = 10)

## ----eval=FALSE----------------------------------------------------------
#  simData <- sim_base() %>% sim_gen_x() %>% sim_gen_e() %>% as.data.frame

## ------------------------------------------------------------------------
sim_base_lm() %>% sim_agg()

## ------------------------------------------------------------------------
setup <- sim_base_lmm()
plot(setup)
library(ggplot2)
autoplot(setup)
autoplot(setup, "e")

## ------------------------------------------------------------------------
autoplot(setup %>% sim_gen_vc())

