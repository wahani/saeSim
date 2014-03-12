\name{gen_e_norm}
\alias{gen_e_norm}
\alias{gen_fe_norm}
\alias{gen_v_norm}
\alias{gen_v_sar}
\title{Generates random numbers}
\usage{
gen_e_norm(mean = 0, sd = 1)

gen_fe_norm(mean = 0, sd = 1)

gen_v_norm(mean = 0, sd = 1)

gen_v_sar(mean = 0, sd = 1, rho = 0.5, type = "rook")
}
\arguments{
  \item{mean}{the mean passed to the random number
  generator, for example \link{rnorm}}

  \item{sd}{the standard deviation passed to the random
  number generator, for example \link{rnorm}}

  \item{rho}{the correlation used to create the variance
  covariance matrix for a SAR process}

  \item{type}{either "rook" or "queen". See
  \code{\link[spdep]{cell2nb}} for detials}
}
\value{
All these functions are not meant to be used interactively.
They will all return a function, which will be called
internally with specific arguments. These arguments do not
have to be supplied by the user. The following overview is
made for the sake of completeness: \itemize{ \item
\code{gen_e_norm()}, \code{gen_v_norm()} and
\code{gen_v_sar()} expect: \itemize { \item nDomains the
number of domains \item nUnits the number of units in each
domain } \item \code{gen_fe_norm()}: \itemize{ \item
nDomains, the number of domains \item nUnits, the number of
units in each domain \item const, the intercept or constant
in a linear model \item slope, the slope parameter in a
linear model }

}
}
\description{
This function family is designed to draw random numbers
according to the setting for domains and units in a domain.
fe stands for fixed effects, e for the model error and v
for an additional error component defined on area level
(random effect). These functions are used in combination
with the \code{sim} function family. For example in
\link{sim_fe} one can specify a specific random number
generator and \code{gen_fe_norm} is an appropriate rn
generator for the fixed effects part.
}
\details{
\code{gen_fe_norm} is used to construct a linear model with
one independent variable. The independent variable is drawn
from a normal distribution with given mean and standard
deviation: \deqn{y_{ij} = \beta_0 + x_{ij}\cdot\beta_1}{y =
const + slope*x}

\code{gen_e_norm} can be used to add a model error, e, whch
is normally distributed with given mean and standard
deviation. e will be i.i.d. from a unit-level perspective:
\deqn{y_{ij} = \beta_0 + x_{ij}\cdot\beta_1 + e_{ij}}{y =
const + slope*x + e}

\code{gen_v_norm} and \code{gen_v_sar} will create an
area-level random component. In the case of v_norm, the
error component will be from a normal distribution and
i.i.d. from an area-level perspective (all units in an area
will get the same value, all areas are independent). v_sar
will also come from a normal distribution, but the errors
are correlated. The variance covariance matrix is
constructed for a SAR(1) - spatial/simultanous
autoregressive process. \link[MASS]{mvrnorm} is used for
the random number generation. Both can be used for
something like: \deqn{y_{ij} = \beta_0 + x_{ij}\cdot\beta_1
+ v_i + e_{ij}}{y = const + slope*x + v + e}
}
\seealso{
For examples: \code{\link{sim_fe}}, \code{\link{sim_re}},
\code{\link{sim_rec}}
}

