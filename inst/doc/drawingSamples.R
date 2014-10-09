## ----include=FALSE-------------------------------------------------------
options(markdown.HTML.header = system.file('misc', 'vignette.css', package='knitr'))

## ------------------------------------------------------------------------
library(saeSim)
base_id(3, 4) %>% sim_gen_fe() %>% sim_sample(sample_number(1L))
base_id(3, 4) %>% sim_gen_fe() %>% sim_sample(sample_number(1L, groupVars = "idD"))

## ----eval=FALSE----------------------------------------------------------
#  # simple random sampling:
#  sim_base_lm() %>% sim_sample(sample_number(size = 10L))
#  sim_base_lm() %>% sim_sample(sample_fraction(size = 0.05))
#  # srs in each domain/cluster
#  sim_base_lm() %>% sim_sample(sample_number(size = 10L, goupVars = "idD"))
#  sim_base_lm() %>% sim_sample(sample_fraction(size = 0.05, groupVars = "idD"))

