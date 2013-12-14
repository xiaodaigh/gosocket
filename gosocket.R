require(svSocket)
require(parallel)

cl <- makeCluster(1)
heheh <- function(x) {
  .Last <<- function() {
    svSocket::stopSocketServer(port = 8000+x)  
  }
  svSocket::startSocketServer(port = 8000+x)
}

clusterCall(cl,heheh,1)

con <- socketConnection(port=8001,blocking=FALSE)

system.time(a<-evalServer.nb(con,"z <- rnorm(10^9);",return.res=FALSE))
evalServer.nb(con,"summary(z)")
evalServer.nb(con,"head(z)")

close(con)

ch <- function(x) {
  svSocket::stopSocketServer(port = 6010+x)  
}
clusterCall(cl,ch,1)
stopCluster(cl)

system.time(evalServer(con,"z <- rnorm(10^7)",return.res=TRUE))

go.socket <- function(cl,expr,port = round(runif(1, min = 3000, max = 8000)),non.blocking=TRUE) {
  tmp.code <- function(port) {
    #require(svSocket)
    svSocket::startSocketServer(port = port)
  }
  clusterCall(cl,tmp.code,port)
  con <- socketConnection(port=port,blocking=FALSE)
  evalServer(con,expr,return.res=!non.blocking)
  close(con)
  return(port)
}

cl <- parallel::makeCluster(1)
hehe <- go.socket(cl,expr = "z <- rnorm(10^7)")
con <- socketConnection(port=hehe)
evalServer(con,"head(z)",return.res=TRUE)
stopCluster(cl)

a <- function() {
  .Last <<- function() {
    write.csv("c","c:/temp/exitc.txt")
  }
}
a()
