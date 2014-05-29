Tools for the simulation of data in the context of small area estimation. They will organize your simulation set-up into phases:
  1. Generating data 
  2. Computing on the generated data
  3. Drawing samples from the data
  4. Computing on the sample
  5. Aggregating the sample
  6. Computing on the aggregates
  7. Repeat 1-6 *R* times

At the moment the tools are only intended to support model-based simulations. Although I am planing to integrate design based simulations. Go to the [homepage](http://wahani.github.io/saeSim/) of this project to find out more.

## Installation
```
library(devtools)
install_github("saeSim", "wahani", subdir="package")
```
