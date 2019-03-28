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
## # Description: data.frame [10,000 × 6]
##     idD   idU      x     e     v     y
## * <int> <int>  <dbl> <dbl> <dbl> <dbl>
## 1     1     1 -2.51  -3.22 0.235  92.0
## 2     1     2  0.735 -4.23 0.235  97.5
## 3     1     3 -3.34  -4.14 0.235  89.4
## 4     1     4  6.38  -4.74 0.235 108. 
## 5     1     5  1.32  -2.00 0.235 101. 
## 6     1     6 -3.28  -2.10 0.235  91.6
## # … with 9,994 more rows
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
## # Description: data.frame [6 × 3]
##     idD   idU      x
##   <int> <int>  <dbl>
## 1     1     1  -3.48
## 2     1     2  -3.48
## 3     1     3  -3.48
## 4     2     1  13.2 
## 5     2     2  13.2 
## 6     2     3  13.2
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
## # Description: data.frame [10,000 × 7]
##     idD   idU     x     e     v     vSp     y
## * <int> <int> <dbl> <dbl> <dbl>   <dbl> <dbl>
## 1     1     1 -3.26 -5.80 -1.29 0.00300  89.7
## 2     1     2  4.26  4.77 -1.29 0.00300 108. 
## 3     1     3 -3.07  1.02 -1.29 0.00300  96.7
## 4     1     4  5.21  2.32 -1.29 0.00300 106. 
## 5     1     5  1.91  8.53 -1.29 0.00300 109. 
## 6     1     6 -2.66  3.76 -1.29 0.00300  99.8
## # … with 9,994 more rows
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
## # Description: data.frame [6 × 7]
##     idD   idU       x     e idC       y popMean
## * <int> <int>   <dbl> <dbl> <lgl> <dbl>   <dbl>
## 1     1     1   0.575 6.62  FALSE  107.    108.
## 2     1     2   3.77  0.226 FALSE  104.    108.
## 3     1     3  12.6   1.07  FALSE  114.    108.
## 4     2     1   6.64  5.01  FALSE  112.    106.
## 5     2     2  -0.842 3.41  FALSE  103.    106.
## 6     2     3   4.50  0.359 FALSE  105.    106.
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
## # Description: data.frame [10,000 × 6]
##     idD   idU      x      e     y linearPredictor
##   <int> <int>  <dbl>  <dbl> <dbl>           <dbl>
## 1     1     1 -8.50  -0.637  90.9            91.6
## 2     1     2 -0.732  3.09  102.             99.3
## 3     1     3  1.11   6.99  108.            101. 
## 4     1     4  3.82   4.38  108.            104. 
## 5     1     5  0.615 -0.191 100.            101. 
## 6     1     6  0.382 -3.60   96.8           100. 
## # … with 9,994 more rows
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
## # Description: data.frame [500 × 6]
##     idD   idU      x     e     y linearPredictor
## * <int> <int>  <dbl> <dbl> <dbl>           <dbl>
## 1     1    98  5.47  -1.31 104.            106. 
## 2     1    27 -0.462  8.40 108.             99.7
## 3     1    47  0.358 -2.91  97.4           101. 
## 4     1     5 -6.90   3.15  96.2            93.1
## 5     1    35  2.40  -4.40  98.0           103. 
## 6     2    50 -1.19   2.28 101.             98.9
## # … with 494 more rows
```

Should you want to apply area level models, use `sim_comp_agg` instead.


```r
sim_base_lm() %>% 
  sim_sample() %>%
  sim_agg() %>% 
  sim_comp_agg(comp_linearPredictor)
```

```
## # Description: data.frame [100 × 5]
##     idD      x      e     y linearPredictor
## * <dbl>  <dbl>  <dbl> <dbl>           <dbl>
## 1     1  0.202  2.20  102.            100. 
## 2     2  0.103 -2.58   97.5           100. 
## 3     3 -2.03   2.49  100.             97.9
## 4     4  1.52  -1.41  100.            101. 
## 5     5 -0.649  0.413  99.8            99.3
## 6     6 -1.14   1.45  100.             98.8
## # … with 94 more rows
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
## # Description: data.frame [1 × 3]
##     idD   idU     x
##   <int> <int> <dbl>
## 1     1     1 -7.73
```

```r
base_id(3, 4) %>% 
  sim_gen_x() %>% 
  sim_sample(sample_number(1L, groupVars = "idD"))
```

```
## # Description: data.frame [3 × 3]
##     idD   idU      x
## * <int> <int>  <dbl>
## 1     1     2  0.299
## 2     2     4  1.63 
## 3     3     4 -1.87
```


```r
# simple random sampling:
sim_base_lm() %>% sim_sample(sample_number(size = 10L))
```

```
## # Description: data.frame [10 × 5]
##     idD   idU      x     e     y
##   <int> <int>  <dbl> <dbl> <dbl>
## 1    37    63 -0.976 -2.66  96.4
## 2    59    79 -1.14   4.38 103. 
## 3     7    19  4.97  -2.24 103. 
## 4    28    36  2.00   4.49 106. 
## 5    94    47  5.84  -2.69 103. 
## 6    46    59  6.11  -3.75 102. 
## # … with 4 more rows
```

```r
sim_base_lm() %>% sim_sample(sample_fraction(size = 0.05))
```

```
## # Description: data.frame [500 × 5]
##     idD   idU      x      e     y
##   <int> <int>  <dbl>  <dbl> <dbl>
## 1    65    24 -0.538  2.33  102. 
## 2    21    10  2.87  -4.87   98.0
## 3    95    71 -1.01   1.80  101. 
## 4     7    49  4.77  -0.567 104. 
## 5    93    68  7.60   1.86  109. 
## 6    94    56  7.05   2.70  110. 
## # … with 494 more rows
```

```r
# srs in each domain/cluster
sim_base_lm() %>% sim_sample(sample_number(size = 10L, groupVars = "idD"))
```

```
## # Description: data.frame [1,000 × 5]
##     idD   idU     x     e     y
## * <int> <int> <dbl> <dbl> <dbl>
## 1     1    26 -1.90 -1.80  96.3
## 2     1    49  9.35  3.79 113. 
## 3     1    95 -6.71  5.98  99.3
## 4     1    41  1.57 -5.40  96.2
## 5     1    42 -8.54 -1.21  90.2
## 6     1     3  1.49  1.48 103. 
## # … with 994 more rows
```

```r
sim_base_lm() %>% sim_sample(sample_fraction(size = 0.05, groupVars = "idD"))
```

```
## # Description: data.frame [500 × 5]
##     idD   idU       x     e     y
## * <int> <int>   <dbl> <dbl> <dbl>
## 1     1    49  5.45    2.94 108. 
## 2     1    12  0.0983 -2.76  97.3
## 3     1    19 -0.247   1.67 101. 
## 4     1     5 -5.93    1.10  95.2
## 5     1    45  4.52   -8.22  96.3
## 6     2    32  0.0987  6.23 106. 
## # … with 494 more rows
```
