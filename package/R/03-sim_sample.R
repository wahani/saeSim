sim_sample <- function(smplFun = sample_csrs(size=5L)) {
  new("smstp_sample", smplFun = smplFun)
}
