sim_agg <- function(aggFun = agg_standard()) {
  new("smstp_agg", aggFun = aggFun)
}