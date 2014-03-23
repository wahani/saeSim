\name{sim_calc}
\alias{sim_calc}
\title{Add new variables}
\usage{
sim_calc(calcFun = calc_var(), level = "population")
}
\arguments{
  \item{calcFun}{a function used for calculation, see
  \code{\link{calc_var}}}

  \item{level}{character given the level on which the
  variable is to be calculated. One in
  \code{c("population", "sample")}}
}
\description{
These functions can be used for adding new variables to the
data.
}
\examples{
sim_base_standard() \%+\% sim_gen_fe() \%+\% sim_calc()
}

