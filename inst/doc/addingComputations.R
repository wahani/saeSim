## ----include=FALSE-------------------------------------------------------
options(markdown.HTML.header = system.file('misc', 'vignette.css', package='knitr'))
set.seed(1)

## ------------------------------------------------------------------------
library(saeSim)
base_id(2, 3) %>% sim_gen_x() %>% sim_gen_e() %>% sim_gen_ec() %>% 
  sim_resp_eq(y = 100 + x + e) %>%
  sim_comp_pop(comp_var(popMean = mean(y)), by = "idD")


## ------------------------------------------------------------------------
sim_base_lm() %>% 
  sim_comp_N() %>% 
  sim_comp_popMean() %>% 
  sim_comp_popVar() %>%
  sim_sample() %>% 
  sim_comp_n()

## ------------------------------------------------------------------------
comp_linearPredictor <- function(dat) {
  dat$linearPredictor <- lm(y ~ x, dat) %>% predict
  dat
}

sim_base_lm() %>% 
  sim_comp_pop(comp_linearPredictor)

## ------------------------------------------------------------------------
sim_base_lm() %>% 
  sim_comp_pop(function(dat) lm(y ~ x, dat)) %>%
  sim(R = 1)

comp_linearModelAsAttr <- function(dat) {
  attr(dat, "linearModel") <- lm(y ~ x, dat)
  dat
}

dat <- sim_base_lm() %>% 
  sim_comp_pop(comp_linearModelAsAttr) %>%
  as.data.frame

attr(dat, "linearModel")

