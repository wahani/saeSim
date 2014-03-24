<!--
%\VignetteEngine{knitr::knitr}
%\VignetteIndexEntry{sim_setup elements}
-->



# Demo for simulation setup

The procedure is as follows:
- Choose the number of domains and units
- Choose which elements to include in the data
- Choose which elements are contaminated
- Compute new variables if necessary
- Draw a sample
- Compute new variables on the sample if necessary
- Aggregate the data if you do not use unit level data

Basic setup:


```r
.libPaths("../../../libWin")
library(saeSim)
```

```
## Loading required package: dplyr
## 
## Attaching package: 'dplyr'
## 
## Die folgenden Objekte sind maskiert from 'package:stats':
## 
##     filter, lag
## 
## Die folgenden Objekte sind maskiert from 'package:base':
## 
##     intersect, setdiff, setequal, union
## 
## Loading required package: spdep
## Loading required package: sp
## Loading required package: Matrix
## Loading required package: ggplot2
```

```r
setup <- sim_setup(sim_base_standard(nDomains = 100, nUnits = 100), R = 100, 
    simName = "demo", idC = TRUE)
```


Choose elements:

```r
setup <- setup %+% sim_gen_fe(gen_norm(100, 10), const = 100, slope = 2, name = "x") %+% 
    sim_gen_e(gen_norm(0, 4), name = "e") %+% sim_gen_re(gen_v_norm(0, 1), name = "v")
```


Add contamination (using defaults):

```r
setup <- setup %+% sim_gen_ec() %+% sim_gen_rec()
```


Adding more variables. The `level` argument will be used to determine when to compute the variable. The level "sample" means that the computation will be done after the sampling.

```r
setup <- setup %+% sim_calc(calc_var(varName = c(N = "y"), funNames = "length", 
    exclude = NULL), level = "population") %+% sim_calc(calc_var(c(n = "y"), 
    "length"), level = "sample")
```


Draw a sample:

```r
setup <- setup %+% sim_sample()
```


Then aggregate everything (area-level information):

```r
setup <- setup %+% sim_agg()
```


Show what's going on:

```r
setup
```

```
##   idD      x       e        v     y   idC   N n
## 1   1  98.99 -1.3742  0.39297 396.0 FALSE 100 5
## 2   2  95.78 -0.2594 -0.01323 387.1 FALSE 100 5
## 3   3  90.52 -1.2939 -0.07911 370.2 FALSE 100 5
## 4   4  98.07  0.1669 -1.29376 393.1 FALSE 100 5
## 5   5 100.23 -1.3559  1.31311 400.6 FALSE 100 5
## 6   6 101.33  2.0847  0.76613 406.8 FALSE 100 5
```

```r
plot(setup)
```

```
## KernSmooth 2.23 loaded
## Copyright M. P. Wand 1997-2009
```

![plot of chunk unnamed-chunk-8](figure/unnamed-chunk-8.png) 




