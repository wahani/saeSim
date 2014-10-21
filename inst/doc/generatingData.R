## ----include=FALSE-------------------------------------------------------
options(markdown.HTML.header = system.file('misc', 'vignette.css', package='knitr'))

## ------------------------------------------------------------------------
library(saeSim)
setup <- sim_base() %>% sim_gen_x() %>% sim_gen_e() %>% sim_gen_v() %>% 
  sim_gen(gen_v_sar(name = "vSp")) %>% sim_resp_eq(y = 100 + x + v + vSp + e)
setup

## ----eval=FALSE----------------------------------------------------------
#  dataList <- sim(setup, R = 500)

## ------------------------------------------------------------------------
contSetup <- setup %>% 
  sim_gen_cont(gen_v_sar(sd = 40, name = "vSp"), nCont = 0.05, type = "area", areaVar = "idD", fixed = TRUE)

## ------------------------------------------------------------------------
sim(base_id(3, 4) %>% sim_gen_x() %>% sim_gen_e() %>% 
      sim_gen_ec(mean = 0, sd = 150, name = "eCont", nCont = c(1, 2, 3)))

