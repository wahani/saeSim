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

The package is still under development. Please report bugs, troubles and discussion as [issue on GitHub](https://github.com/wahani/saeSim/issues). You can install the latest version from the [repository on GitHub](https://www.github.com/wahani/saeSim):

```
library(devtools)
install_github("wahani/saeSim")
```

## Key Features

- Functions to simulate data in the context of small area estimation
- Data from linear mixed models with and without contamination
  - Other model classes should be possible
- Separation between the set-up and the actual simulation - you can specify the simulation without generating the data - then if you need the data, you can run the function `sim()` on the set-up object
  - It is possible to modify the simulation set-up. You can add components with `%&%`
  - Use the `plot` and `autoplot` functions on the set-up object to get some scatter-plot like graphics
- It is possible to generate populations, draw samples and aggregate for area level information (all in one step)
  - The sample_* allow you to control the sampling process
  - Also you can compute statistics on the population, the sample and the aggregate.
  - For area level information, you can easily aggregate the sample or population.
