# smstp_
setClass("smstp_", 
         slots = c(generator = "function", name = "character"),
         contains = "smstp")

setClass("smstp_fe", 
         slots = c(const = "numeric", slope = "numeric"),
         contains = "smstp_")

setClass("smstp_c", 
         slots = c(nCont = "numeric", level = "character", fixed = "logical"),
         contains = "smstp_", validity = function(object) {
           if(any(object@nCont <= 0)) stop("nCont is expected to be larger than 0!")
           if(length(object@nCont) == 1 && object@nCont == 1) warning("nCont is equal to 1, will not be interpreted as proportion!")
           if(!(object@level %in% c("area", "unit", "none"))) stop("Supported levels are area, unit and none!")
           if(length(object@nCont) > 1 & (object@level %in% c("area", "none"))) stop("A vector of nCont on level area or none can not be interpreted!")
           TRUE
         })

# smstp_sample
setClass("smstp_sample", 
         slots = c(smplFun = "function"),
         contains = "smstp")

# smstp_calc
setClass("smstp_calc", 
         slots = c(calcFun = "function", name = "character"),
         contains = "smstp")

setClass("smstp_cpopulation",
         contains = "smstp_calc")

setClass("smstp_csample",
         contains = "smstp_calc")

setClass("smstp_cresult",
         contains = "smstp_calc")