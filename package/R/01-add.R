setGeneric("add", function(dat1, dat2) standardGeneric("add"))

setMethod("add", c(dat1 = "sim_rs", dat2 = "sim_rs"), 
          function(dat1, dat2) {
            # variable_set without id vars
            vars <- names(dat1)[!grepl("id", names(dat1))]
            vars_cum <- vars[vars %in% names(dat2)]
            vars_add <- vars[!(vars %in% names(dat2))]
            
            # cumulate results
            dat1[vars_cum] <- dat1[vars_cum] + dat2[vars_cum]
            # add new variables
            dat1[vars_add] <- dat2[vars_add]
            dat1
          })

setMethod("add", c(dat1 = "sim_rs_fe", dat2 = "sim_rs_fe"), 
          function(dat1, dat2) {
            left_join(dat1, dat2, by = names(dat1)[grepl("id", names(dat1))])
          })

setMethod("add", c(dat1 = "sim_rs", dat2 = "missing"), 
          function(dat1, dat2) {
            dat1
          })