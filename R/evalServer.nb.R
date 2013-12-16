#' Non-blocking Socket Server evaluation
#' 
#' This allows a non-blocking evaluation of code on the server
#' 
#' @param con A connection
#'   
#' @return If blocking is FALSE it always returns the string 
#'   '___non-blocking___' otherwise it will return whatever was evaluated
#' @export
evalServer.nb <- function (con, expr, blocking = TRUE)  {
  
  readLines(con)  
  x <- expr
  #browser()
  if(blocking) {    
    cat("..Last.value <- try(eval(parse(text = \"", x, "\"))); .f <- file(); dump(\"..Last.value\", file = .f); flush(.f); seek(.f, 0); cat(\"\\n<<<startflag>>>\", gsub(\"<pointer: [0-9a-fx]+>\", \"NULL\", readLines(.f)), \"<<<endflag>>>\\n\", sep = \"\\n\"); close(.f); rm(.f, ..Last.value); flush.console()\n", 
        file = con, sep = "")  
    objdump <- ""
    endloc <- NULL
    while (!length(endloc)) {
      obj <- readLines(con, n = 1000, warn = FALSE)
      if (!length(obj)) {
        Sys.sleep(0.01)        
        next
      }
      endloc <- grep("<<<endflag>>>", obj)
      if (length(endloc)) 
        obj <- obj[0:(endloc[length(endloc)] - 1)]
      objdump <- c(objdump, obj)
    }
    startloc <- grep("<<<startflag>>>", objdump)
    if (!length(startloc)) 
      stop("Unable to find <<<startflag>>>")
    objdump <- objdump[-(1:startloc[length(startloc)])]
    nospace <- grep("[^ ]$", objdump)
    nospace <- nospace[nospace < length(objdump)]
    for (i in rev(nospace)) {
      objdump[i] <- paste(objdump[i], objdump[i + 1], sep = "")
      objdump[i + 1] <- ""
    }
    objcon <- textConnection(objdump)
    on.exit(close(objcon))
    source(objcon, local = TRUE, echo = FALSE, verbose = FALSE)
    return(..Last.value)
  } else {
    #cat("..Last.value <- try(eval(parse(text = \"", x, "\"))); .f <- file(); dump(\"..Last.value\", file = .f); flush(.f); seek(.f, 0); cat(\"\\n<<<startflag>>>\", gsub(\"<pointer: [0-9a-fx]+>\", \"NULL\", readLines(.f)), \"<<<endflag>>>\\n\", sep = \"\\n\"); close(.f); rm(.f, ..Last.value); flush.console()\n", file = con, sep = "")  
    cat("..Last.value <- try(eval(parse(text = \"", x, "\")));  rm(..Last.value); flush.console()\n", file = con, sep = "")  
    #cat("..Last.value <- try(eval(parse(text = \"", x, "\")));  flush.console()\n", file = con, sep = "")  
    return('___non-blocking___') 
  }  
}