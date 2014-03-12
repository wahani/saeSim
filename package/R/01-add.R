setGeneric("add", function(dat1, dat2) standardGeneric("add"))

setMethod("add", c(dat1 = "sim_rs", dat2 = "sim_rs"), 
          function(dat1, dat2) {            
            # variable_set without id vars
            vars <- names(dat1)[!grepl("id", names(dat1))]
            vars_cum <- vars[vars %in% names(dat2)]
            vars_add <- names(dat2)[!(names(dat2) %in% names(dat1))]
            
            # sort the variables
            dat1 <- arrange(dat1, idD, idU)
            dat2 <- arrange(dat2, idD, idU)
            
            # cumulate results
            dat1[vars_cum] <- dat1[vars_cum] + dat2[vars_cum]
            # add new variables
            dat1[vars_add] <- dat2[vars_add]
            new("sim_rs", dat1)
          })

setMethod("add", c(dat1 = "sim_rs_fe", dat2 = "sim_rs_fe"), 
          function(dat1, dat2) {
            dat1 <- left_join(dat1, dat2, by = names(dat1)[grepl("id", names(dat1))])
            new("sim_rs_fe", as.data.frame(dat1))
          })

setMethod("add", c(dat1 = "sim_rs", dat2 = "missing"), 
          function(dat1, dat2) {
            new("sim_rs", dat1)
          })

setMethod("add", c(dat1 = "sim_rs_c", dat2 = "sim_rs_c"), 
          function(dat1, dat2) {
            dat <- add(new("sim_rs", S3Part(dat1)), new("sim_rs", S3Part(dat2)))
            suppressWarnings({
              dat[paste("idC", sum(grepl("idC", names(dat))), sep = "")] <- dat2$idC
            })
            new("sim_rs", dat)
          })

setMethod("add", c(dat1 = "sim_rs", dat2 = "sim_rs_c"), 
          function(dat1, dat2) {
            if (any(grepl("idC", names(dat1)))) return(add(new("sim_rs_c", S3Part(dat1)), dat2))
            # else
            add(dat1, new("sim_rs", S3Part(dat2)))
          })

