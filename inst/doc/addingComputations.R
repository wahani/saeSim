## ----include=FALSE-------------------------------------------------------
options(markdown.HTML.header = system.file('misc', 'vignette.css', package='knitr'))

## ------------------------------------------------------------------------
library(saeSim)
base_id(2, 3) %>% sim_gen_fe() %>% sim_gen_e() %>% sim_gen_ec() %>% 
  sim_resp_eq(y = 100 + x + e) %>%
  sim_comp_pop(comp_var(popMean = mean(y)), by = "idD")

sim_base_lm() %>% sim_comp_N()

sim_base_lm() %>% 
  sim_sample() %>%
  sim_comp_n()

