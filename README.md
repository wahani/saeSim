[![Build Status](https://travis-ci.org/wahani/saeSim.png?branch=master)](https://travis-ci.org/wahani/saeSim)
[![CRAN Version](http://www.r-pkg.org/badges/version/saeSim)](http://cran.rstudio.com/web/packages/saeSim)
![](http://cranlogs.r-pkg.org/badges/saeSim)
[![codecov.io](https://codecov.io/github/wahani/saeSim/coverage.svg?branch=master)](https://codecov.io/github/wahani/saeSim?branch=master)

Tools for the simulation of data in the context of small area
estimation. Combine all steps of your simulation - from data generation
over drawing samples to model fitting - in one object. This enables easy
modification and combination of different scenarios. You can store your
results in a folder or start the simulation in parallel.



Two external resources may be of interest in addition to this vignette:

   - [A poster describung the package](https://github.com/wahani/posterUseR2015/blob/master/poster.pdf)
   - [The article introducing the package](http://dx.doi.org/10.17713/ajs.v45i1.89)

## An initial Example

Consider a linear mixed model. It contains two components. A fixed effects part,
and an error component. The error component can be split into a random effects
part and a model error.


```r
library(saeSim)
setup <- sim_base() %>% 
  sim_gen_x() %>% 
  sim_gen_e() %>% 
  sim_gen_v() %>%
  sim_resp_eq(y = 100 + 2 * x + v + e) %>% 
  sim_simName("Doku")
setup
```

```
## # data.frame [10,000 × 6]
##     idD   idU          x         e         v         y
## * <int> <int>      <dbl>     <dbl>     <dbl>     <dbl>
## 1     1     1 -2.5058152 -3.217326 0.2353485  92.00639
## 2     1     2  0.7345733 -4.226103 0.2353485  97.47839
## 3     1     3 -3.3425144 -4.141583 0.2353485  89.40874
## 4     1     4  6.3811232 -4.742241 0.2353485 108.25535
## 5     1     5  1.3180311 -2.001758 0.2353485 100.86965
## 6     1     6 -3.2818735 -2.099955 0.2353485  91.57165
## # ... with 9,994 more rows
```

`sim_base()` is responsible to supply a `data.frame` to which variables can be
added. The default is to create a `data.frame` with indicator variables `idD`
and `idU` (2-level-model), which uniquely identify observations. 'D' stands for
the domain, i.e. the grouping variable. 'U' stands for unit and is the
identifier of single observations within domains. `sim_resp` will add a variable
`y` as response.

The setup itself does not contain the simulated data but the functions to
process the data. To start a simulation use the function `sim`. It will return a
`list` containing `data.frames` as elements:


```r
dataList <- sim(setup, R = 10)
```

You can coerce a simulation setup to a `data.frame` with `as.data.frame`. 


```r
simData <- sim_base() %>% 
  sim_gen_x() %>% 
  sim_gen_e() %>% 
  as.data.frame
simData
```

## Naming and structure

Components in a simulation setup should be added using the pipe operator `%>%`
from magrittr. A component defines 'when' a specific function will be applied in
a chain of functions. To add a component you can use one of: `sim_gen`,
`sim_resp`, `sim_comp_pop`, `sim_sample`, `sim_comp_sample`, `sim_agg` and
`sim_comp_agg`. They all expect a simulation setup as first argument and a
function as second and will take care of the order in which the functions are
called. The reason for this is the following:


```r
setup <- sim_base() %>% 
  sim_gen_x() %>% 
  sim_gen_e() %>% 
  sim_resp_eq(y = 100 + 2 * x + e)

setup1 <- setup %>% sim_sample(sample_fraction(0.05))
setup2 <- setup %>% sim_sample(sample_number(5))
```

You can define a rudimentary scenario and only have to explain how scenarios
differ. You do not have to redefine them. `setup1` and `setup2` only differ in
the way samples are drawn. `sim_sample` will take care, that the sampling will
take place at the appropriate place in the chain of functions no matter how
`setup` was composed.

If you can't remember all function names, use auto-complete. All functions to
add components start with `sim_`. And all functions meant to be used in a given
phase will start with the corresponding prefix, i.e. if you set the sampling
scheme you use `sim_sample` -- all functions to control sampling have the prefix
`sample`.

  
## Exploring the setup

You will want to check your results regularly when working with `sim_setup`
objects. Some methods are supplied to do that:

- `show` - this is the `print` method for S4-Classes. You don't have to call
`show` explicitly. You may have noticed that only a few lines of data are
printed to the console if you evaluate a simulation setup. `show` will print the
`head` of the resulting data of one simulation run.
- `plot` - for visualizing the data
- `autoplot` - Will imitate `smoothScatter` with ggplot2


```r
setup <- sim_base_lmm()
```


```r
plot(setup)
autoplot(setup)
autoplot(setup, "e")
autoplot(setup %>% sim_gen_vc())
```

## sim_gen
### Semi-custom data

saeSim has an interface to standard random number generators in R. If things get
more complex you can always define new generator functions.


```r
base_id(2, 3) %>% 
  sim_gen(gen_generic(rnorm, mean = 5, sd = 10, name = "x", groupVars = "idD"))
```

```
## # data.frame [6 × 3]
##     idD   idU         x
##   <int> <int>     <dbl>
## 1     1     1 -3.477177
## 2     1     2 -3.477177
## 3     1     3 -3.477177
## 4     2     1 13.219727
## 5     2     2 13.219727
## 6     2     3 13.219727
```

You can supply any random number generator to `gen_generic` and since we are in
small area estimation you have an optional group variable to generate
'area-level' variables. Some short cuts for data generation are `sim_gen_x`,
`sim_gen_v` and `sim_gen_e` which add normally distributed variables named 'x',
'e' and 'v' respectively. Also there are some function with the prefix 'gen'
which will be extended in the future.


```r
library(saeSim)
setup <- sim_base() %>% 
  sim_gen_x() %>% # Variable 'x'
  sim_gen_e() %>% # Variable 'e'
  sim_gen_v() %>% # Variable 'v' as a random-effect
  sim_gen(gen_v_sar(name = "vSp")) %>% # random-effect following a SAR(1)
  sim_resp_eq(y = 100 + x + v + vSp + e) # Computing 'y'
setup
```

```
## # data.frame [10,000 × 7]
##     idD   idU         x         e         v       vSp         y
## * <int> <int>     <dbl>     <dbl>     <dbl>     <dbl>     <dbl>
## 1     1     1 -3.261018 -5.797709 -1.293091 0.2919544  89.94014
## 2     1     2  4.256857  4.773686 -1.293091 0.2919544 108.02941
## 3     1     3 -3.071645  1.024299 -1.293091 0.2919544  96.95152
## 4     1     4  5.208898  2.322837 -1.293091 0.2919544 106.53060
## 5     1     5  1.908363  8.533583 -1.293091 0.2919544 109.44081
## 6     1     6 -2.660212  3.759640 -1.293091 0.2919544 100.09829
## # ... with 9,994 more rows
```

### Contaminated data

For contaminated data you can use the same generator functions, however, instead
of using `sim_gen` you use `sim_gen_cont` which will have some extra arguments
to control the contamination. To extend the above setup with a contaminated
spatially correlated error component you can add the following:


```r
contSetup <- setup %>% 
  sim_gen_cont(
    gen_v_sar(sd = 40, name = "vSp"), # defining the model
    nCont = 0.05, # 5 per cent outliers
    type = "area", # whole areas are outliers, i.e. all obs within
    areaVar = "idD", # var name to identify domain
    fixed = TRUE # if in each iteration the same area is an outlier
  )
```

Note that the generator is the same but with a higher standard deviation. The
argument `nCont` controls how much observations are contaminated. Values < 1 are
interpreted as probability. A single number as the number of contaminated units
(can be areas or observations in each area or observations). When given with
`length(nCont) > 1` it will be interpreted as number of contaminated
observations in each area. Use the following example to see how these things
play together:


```r
base_id(3, 4) %>% 
  sim_gen_x() %>% 
  sim_gen_e() %>% 
  sim_gen_ec(mean = 0, sd = 150, name = "eCont", nCont = c(1, 2, 3)) %>%
  as.data.frame
```

```
##    idD idU          x           e      eCont   idC
## 1    1   1  2.1238928  2.85552209    0.00000 FALSE
## 2    1   2  1.8224797 -3.70320125    0.00000 FALSE
## 3    1   3 -0.7466757 -4.63509843    0.00000 FALSE
## 4    1   4  0.2864107 -0.51238608  174.16195  TRUE
## 5    2   1 -4.1711873 -1.64389880    0.00000 FALSE
## 6    2   2 -0.9948926  2.68706944    0.00000 FALSE
## 7    2   3 -4.4030395  0.08884468  131.30190  TRUE
## 8    2   4  1.4103819  0.77040266 -111.81580  TRUE
## 9    3   1 -0.3921937  0.88877112    0.00000 FALSE
## 10   3   2 -5.7884702 -1.54674283   47.70671  TRUE
## 11   3   3 -4.8635870  1.35621664 -306.40766  TRUE
## 12   3   4 -5.7893455  4.26584633  305.57991  TRUE
```

## sim_comp

Here follow some examples how to add components for computation to a
`sim_setup`. Three points can be accessed with

- `sim_comp_pop` - add a computation before sampling
- `sim_comp_sample` - add a computation after sampling
- `sim_comp_agg` - add a computation after aggregation


```r
base_id(2, 3) %>% 
  sim_gen_x() %>% 
  sim_gen_e() %>% 
  sim_gen_ec() %>% 
  sim_resp_eq(y = 100 + x + e) %>%
   # the mean in each domain:
  sim_comp_pop(comp_var(popMean = mean(y)), by = "idD")
```

```
## # data.frame [6 × 7]
##     idD   idU          x         e   idC        y  popMean
## * <int> <int>      <dbl>     <dbl> <lgl>    <dbl>    <dbl>
## 1     1     1  0.5746668 6.6169891 FALSE 107.1917 108.2884
## 2     1     2  3.7688622 0.2257547 FALSE 103.9946 108.2884
## 3     1     3 12.6044689 1.0745909 FALSE 113.6791 108.2884
## 4     2     1  6.6417051 5.0116040 FALSE 111.6533 106.3608
## 5     2     2 -0.8421809 3.4132565 FALSE 102.5711 106.3608
## 6     2     3  4.4991934 0.3587781 FALSE 104.8580 106.3608
```

The function `comp_var` is a wrapper around `dplyr::mutate` so you can add
simple data manipulations. The argument `by` is a little extension and lets you
define operations in the scope of groups identified by a variable in the data.
In this case the mean of the variable 'y' is computed for every group identified
with the variable 'idD'. This is done before sampling, hence the prefix 'pop'
for population.

### Add custom computation functions

By adding computation functions you can extend the functionality to wrap your
whole simulation. This will separate the utility of this package from only
generating data.


```r
comp_linearPredictor <- function(dat) {
  dat$linearPredictor <- lm(y ~ x, dat) %>% predict
  dat
}

sim_base_lm() %>% 
  sim_comp_pop(comp_linearPredictor)
```

```
## # data.frame [10,000 × 6]
##     idD   idU          x          e         y linearPredictor
##   <int> <int>      <dbl>      <dbl>     <dbl>           <dbl>
## 1     1     1 -8.5041814 -0.6369861  90.85883        91.55255
## 2     1     2 -0.7317040  3.0870898 102.35539        99.25294
## 3     1     3  1.1077078  6.9927853 108.10049       101.07530
## 4     1     4  3.8226415  4.3782846 108.20093       103.76505
## 5     1     5  0.6150609 -0.1913978 100.42366       100.58722
## 6     1     6  0.3820305 -3.6001313  96.78190       100.35635
## # ... with 9,994 more rows
```

Or, should this be desirable, directly produce a list of `lm` objects or add
them as attribute to the data. The intended way of writing functions is that
they will return the modified data of class 'data.frame'.


```r
sim_base_lm() %>% 
  sim_comp_pop(function(dat) lm(y ~ x, dat)) %>%
  sim(R = 1)
```

```
## [[1]]
## 
## Call:
## lm(formula = y ~ x, data = dat)
## 
## Coefficients:
## (Intercept)            x  
##    100.0421       0.9872
```

```r
comp_linearModelAsAttr <- function(dat) {
  attr(dat, "linearModel") <- lm(y ~ x, dat)
  dat
}

dat <- sim_base_lm() %>% 
  sim_comp_pop(comp_linearModelAsAttr) %>%
  as.data.frame

attr(dat, "linearModel")
```

```
## 
## Call:
## lm(formula = y ~ x, data = dat)
## 
## Coefficients:
## (Intercept)            x  
##     100.017        1.032
```

If you use any kind of sampling, the 'linearPredictor' can be added after
sampling. This is where small area models are supposed to be applied.


```r
sim_base_lm() %>% 
  sim_sample() %>%
  sim_comp_sample(comp_linearPredictor)
```

```
## # data.frame [500 × 6]
##     idD   idU          x         e         y linearPredictor
## * <int> <int>      <dbl>     <dbl>     <dbl>           <dbl>
## 1     1    98  5.4659572 -1.314283 104.15167       105.74416
## 2     1    27 -0.4615954  8.400955 107.93936        99.67221
## 3     1    47  0.3575909 -2.909916  97.44767       100.51135
## 4     1     5 -6.9000763  3.146235  96.24616        93.07688
## 5     1    35  2.4028935 -4.400480  98.00241       102.60648
## 6     2    50 -1.1866824  2.277745 101.09106        98.92946
## # ... with 494 more rows
```

Should you want to apply area level models, use `sim_comp_agg` instead.


```r
sim_base_lm() %>% 
  sim_sample() %>%
  sim_agg() %>% 
  sim_comp_agg(comp_linearPredictor)
```

```
## # data.frame [100 × 5]
##     idD          x          e         y linearPredictor
## * <dbl>      <dbl>      <dbl>     <dbl>           <dbl>
## 1     1  0.2017418  2.2021169 102.40386       100.14130
## 2     2  0.1026902 -2.5827947  97.51990       100.04071
## 3     3 -2.0286204  2.4880119 100.45939        97.87635
## 4     4  1.5202556 -1.4085423 100.11171       101.48026
## 5     5 -0.6493425  0.4129929  99.76365        99.27702
## 6     6 -1.1355290  1.4469604 100.31143        98.78329
## # ... with 94 more rows
```

## sim_sample

After the data generation you may want to draw a sample from the population. Use
the function `sim_sample()` to add a sampling component to your `sim_setup`.

- `sample_number` - wrapper around `dplyr::sample_n`
- `sample_fraction` - wrapper around `dplyr::sample_frac`



```r
base_id(3, 4) %>% 
  sim_gen_x() %>% 
  sim_sample(sample_number(1L))
```

```
## # data.frame [1 × 3]
##     idD   idU         x
## * <int> <int>     <dbl>
## 1     1     1 -7.727552
```

```r
base_id(3, 4) %>% 
  sim_gen_x() %>% 
  sim_sample(sample_number(1L, groupVars = "idD"))
```

```
## # data.frame [3 × 3]
##     idD   idU          x
## * <int> <int>      <dbl>
## 1     1     2  0.2987786
## 2     2     4  1.6332895
## 3     3     4 -1.8714885
```


```r
# simple random sampling:
sim_base_lm() %>% sim_sample(sample_number(size = 10L))
```

```
## # data.frame [10 × 5]
##     idD   idU          x         e         y
## * <int> <int>      <dbl>     <dbl>     <dbl>
## 1    37    63 -0.9764352 -2.664431  96.35913
## 2    59    79 -1.1394150  4.377856 103.23844
## 3     7    19  4.9665615 -2.242667 102.72389
## 4    28    36  2.0034506  4.488453 106.49190
## 5    94    47  5.8358881 -2.685873 103.15002
## 6    46    59  6.1064004 -3.749871 102.35653
## # ... with 4 more rows
```

```r
sim_base_lm() %>% sim_sample(sample_fraction(size = 0.05))
```

```
## # data.frame [500 × 5]
##     idD   idU          x          e         y
## * <int> <int>      <dbl>      <dbl>     <dbl>
## 1    65    24 -0.5381244  2.3337188 101.79559
## 2    21    10  2.8677617 -4.8659246  98.00184
## 3    95    71 -1.0059852  1.8020448 100.79606
## 4     7    49  4.7651294 -0.5667315 104.19840
## 5    93    68  7.6016742  1.8567419 109.45842
## 6    94    56  7.0459706  2.7041548 109.75013
## # ... with 494 more rows
```

```r
# srs in each domain/cluster
sim_base_lm() %>% sim_sample(sample_number(size = 10L, groupVars = "idD"))
```

```
## # data.frame [1,000 × 5]
##     idD   idU         x         e         y
## * <int> <int>     <dbl>     <dbl>     <dbl>
## 1     1    26 -1.899145 -1.798466  96.30239
## 2     1    49  9.347001  3.793833 113.14083
## 3     1    95 -6.712577  5.975365  99.26279
## 4     1    41  1.570111 -5.399290  96.17082
## 5     1    42 -8.543439 -1.208584  90.24798
## 6     1     3  1.488561  1.478788 102.96735
## # ... with 994 more rows
```

```r
sim_base_lm() %>% sim_sample(sample_fraction(size = 0.05, groupVars = "idD"))
```

```
## # data.frame [500 × 5]
##     idD   idU           x         e         y
## * <int> <int>       <dbl>     <dbl>     <dbl>
## 1     1    49  5.44806880  2.943329 108.39140
## 2     1    12  0.09825671 -2.761338  97.33692
## 3     1    19 -0.24713583  1.671805 101.42467
## 4     1     5 -5.92866120  1.099122  95.17046
## 5     1    45  4.51519676 -8.224511  96.29069
## 6     2    32  0.09869877  6.233193 106.33189
## # ... with 494 more rows
```
