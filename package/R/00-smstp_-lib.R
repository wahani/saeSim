# generator: function which given the slots of smstp will generate random number according to the specs
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