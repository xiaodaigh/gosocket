

evalServer.nb <- function (con, expr, send = NULL, return.res = TRUE)  {

  x <- substitute(expr)
  if (!missing(send) && (length(x) != 1 || mode(x) != "name")) 
    stop("When send is supplied, expr must be a target variable name (unquoted) on the server to assign the result of the send expr to.")
  if (!is.character(x)) 
    x <- deparse(x)
  rl.tmp <- readLines(con)
  if (missing(send)) {
    if(return.res) {
      cat("..Last.value <- try(eval(parse(text = \"", x, "\"))); .f <- file(); dump(\"..Last.value\", file = .f); flush(.f); seek(.f, 0); cat(\"\\n<<<startflag>>>\", gsub(\"<pointer: [0-9a-fx]+>\", \"NULL\", readLines(.f)), \"<<<endflag>>>\\n\", sep = \"\\n\"); close(.f); rm(.f, ..Last.value); flush.console()\n", 
          file = con, sep = "")
    } else {
      cat("..Last.value <- try(eval(parse(text = \"", x, "\"))); ", 
          file = con, sep = "")
    }
  }
  else {
#     .f <- file()
#     on.exit(close(.f))
#     ..Last.value <- send
#     dump("..Last.value", file <- .f)
#     flush(.f)
#     seek(.f, 0)
#     cat(readLines(.f), ";", x, " <- ..Last.value; rm(..Last.value); cat(\"\\n<<<endflag>>>\\n\"); flush.console()\n", 
#         file = con, sep = "")
  }
  if(return.res) {
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
    if (!missing(send)) {
      if (!all(objdump == "")) 
        stop(objdump)
      return(TRUE)
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
    return(TRUE) 
  }
}