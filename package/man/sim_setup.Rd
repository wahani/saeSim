\name{sim_setup}
\alias{sim_setup}
\title{Construct a simulation set-up}
\usage{
sim_setup(base = sim_base_standard(), ...)
}
\arguments{
  \item{base}{a object constructed by the \code{sim_base_*}
  family}

  \item{...}{arguments passed to methods}

  \item{R}{the number of desired repetitions in the
  simulation}

  \item{simName}{the name of the simulation. It is simply
  added as character to the data}

  \item{idC}{\code{TRUE}: for contaminated data in the
  returned data one indicator variable for contaminated
  domains is used; called \code{idC}. \code{FALSE}: several
  indicator variables are returned}
}
\value{
An objects of class \code{sim_setup}. Should be used in
conjunction with methods for this class.
}
\description{
This function is used to construct a new simulation set-up.
There are several ways to work with it. Please see the
examples and documentation.
}
\seealso{
\code{\link{sim}}
}

