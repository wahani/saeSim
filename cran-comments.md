## Test environments
* ubuntu (on travis-ci), R 3.2.4
* win-builder (devel and release)
* local ubuntu (14.10), R 3.2.5

## R CMD check results
There were no ERRORs or WARNINGs

I received the following Note:

* checking CRAN incoming feasibility ... NOTE
Maintainer: 'Sebastian Warnholz <Sebastian.Warnholz@fu-berlin.de>'

License components with restrictions and base license permitting such:
  MIT + file LICENSE
File 'LICENSE':
  YEAR: 2016
  COPYRIGHT HOLDER: Sebastian Warnholz

which I believe is due to a change in the license.

## Downstream dependencies
To the best of my knowledge there are no reverse dependencies to check.