\name{sim_gen_fe}
\alias{sim_gen_e}
\alias{sim_gen_ec}
\alias{sim_gen_fe}
\alias{sim_gen_re}
\alias{sim_gen_rec}
\title{Add generated data}
\usage{
sim_gen_fe(generator = gen_norm(0, 4), const = 100, slope = 1,
  name = "x")

sim_gen_e(generator = gen_norm(0, 4), name = "e")

sim_gen_ec(generator = gen_norm(mean = 0, sd = 150), nCont = 0.05,
  level = "unit", fixed = TRUE, name = "e")

sim_gen_re(generator = gen_v_norm(), name = "v")

sim_gen_rec(generator = gen_v_norm(mean = 0, sd = 40), nCont = 0.05,
  level = "area", fixed = TRUE, name = "v")
}
\arguments{
  \item{generator}{generator function used to generate
  random numbers}

  \item{const}{constant/intercept in a fixed effects part}

  \item{slope}{slope in a fixed effects part}

  \item{name}{variable name used in the resulting
  \code{data.frame}}

  \item{level}{"unit", "area" or "none" - is the whole area
  contaminated, units inside an area or random observations
  in the data}

  \item{nCont}{gives the number of contaminated
  observations. Values between 0 and 1 will be trated as
  proportion. If length is larger 1, the expected length is
  the number of domains, you can specify something else in
  each domain. Integers are expected in that cas - numeric
  will be converted to integer}
}
\value{
These functions are not designed to be used interactively
but added to a setup. See examples
}
\description{
These functions can be used to add data to a setup. The
terminology comes from mixed models.
}
\examples{
# Data setup for a mixed model
sim_base_standard() \%+\% sim_gen_fe() \%+\% sim_gen_re \%+\% sim_gen_e()
# Adding contamination in the model error
sim_base_standard() \%+\% sim_gen_fe() \%+\% sim_gen_re \%+\% sim_gen_e() \%+\% sim_gen_ec()
}
\seealso{
\code{\link{gen_norm}}, \code{\link{gen_v_norm}},
\code{\link{gen_v_sar}}
}

