devtools::document()
devtools::install()
devtools::build_vignettes()

knitr::knit("vignettes/Introduction.Rmd", "README.md")

batches <- c(
  "[![Build Status](https://travis-ci.org/wahani/saeSim.png?branch=master)](https://travis-ci.org/wahani/saeSim)",
  "[![CRAN Version](http://www.r-pkg.org/badges/version/saeSim)](http://cran.rstudio.com/web/packages/saeSim)",
  "![](http://cranlogs.r-pkg.org/badges/saeSim)",
  "[![codecov.io](https://codecov.io/github/wahani/saeSim/coverage.svg?branch=master)](https://codecov.io/github/wahani/saeSim?branch=master)",
  ""
)

readme <- readLines("README.md")
readme <- c(batches, readme[-(1:10)])
writeLines(readme, "README.md")
