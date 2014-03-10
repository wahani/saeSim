# generator: function which given the slots of smstp will generate random number according to the specs
setClass("smstp_", 
         slots = c(generator = "function"),
         contains = "smstp")

setClass("smstp_fe", 
         slots = c(const = "numeric", slope = "numeric"),
         contains = "smstp_")