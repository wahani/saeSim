## saeSim
[![Build Status](https://travis-ci.org/wahani/saeSim.png?branch=master)](https://travis-ci.org/wahani/saeSim)

Tools for the simulation of data in the context of small area estimation. Go to the [homepage](http://wahani.github.io/saeSim/) of this project to find out more and read the vignette.

## Installation

The package is actively developed. Please report bugs, troubles and discussion as [issue on GitHub](https://github.com/wahani/saeSim/issues). You can install the latest version from the [repository on GitHub](https://www.github.com/wahani/saeSim):


```r
library(devtools)
install_github("wahani/saeSim")
```

or from CRAN:


```r
install.packages("saeSim")
```


```
## Version on CRAN: 0.6.0 
## Development Version: 0.6.6 
## 
## Updates in package NEWS-file since last release to CRAN:
## 
## Changes in version 0.6.6:
## 
##     o   new argument, overwrite, for function sim
## 
## Changes in version 0.6.5:
## 
##     o   new signature for function sim
## 
##     o   parallel back-end has changed to parallelMap
## 
##     o   new functions: sample_cluster_fraction and sample_cluster_number
## 
## Changes in version 0.6.4:
## 
##     o   Rewrite of the summary method
## 
##     o   New function sim_gen_generic
## 
## Changes in version 0.6.3:
## 
##     o   Bugfixes in sim_gen for contamination and sim_gen_eq to preserve attributes of data.frame
## 
##     o   The show method was updated and is more consistent
## 
##     o   Bugfix in as.data.frame: will now always return a data.frame
## 
## Changes in version 0.6.2:
## 
##     o   New sampling function sample_numbers - vectorized sample_number
## 
## Changes in version 0.6.1:
## 
##     o   Updated version of the vignette
```

