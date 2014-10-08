## ----include=FALSE-------------------------------------------------------
options(markdown.HTML.header = system.file('misc', 'vignette.css', package='knitr'))

## ------------------------------------------------------------------------
library(saeSim)
setup <- sim_base() %>% sim_gen_fe() %>% sim_gen_e() %>% sim_gen_re() %>% sim_gen_re(gen_v_sar(name = "vSp"))
# This will result in the same set-up:
setup <- sim_base_lmm() %>% sim_gen_re(gen_v_sar(name = "vSp"))

## ----eval=FALSE----------------------------------------------------------
#  dataList <- sim(setup)

## ------------------------------------------------------------------------
contSetup <- setup %>% 
  sim_gen_rec(gen_v_sar(sd = 40, name = "vSp"), nCont = 0.05, type = "area", areaVar = "idD", fixed = TRUE)

## ------------------------------------------------------------------------
sim(base_id(3, 4) %>% sim_gen_fe() %>% sim_gen_e() %>% 
      sim_gen_ec(gen_norm(mean = 0, sd = 150, name = "eCont"), 
                 nCont = c(1, 2, 3)))

