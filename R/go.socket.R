#' go.socket
#' 
#' Execute a non-blocking routine on a socket-server.
#' 
#' @param code The code you want to execute in character string fomrat
#'   
#' @return Three componenet: 1) cluster A cluster running the socket server; 2)
#'   con A connection to the soncket server; 3) socket a port to the socket
#' @export
go.socket <- function(code,port = round(runif(1, min = 3000, max = 8000))) {  
  #browser()
  cl <- makeCluster(1)
  tmp <- function(x) {
    .Last <<- function() {
      svSocket::stopSocketServer(port = x)  
    }
    svSocket::startSocketServer(port = x)
    return(TRUE)
  }
  
  clusterCall(cl,tmp,x = port)
  con <- socketConnection(port=port)
  #browser()
  evalServer.nb(con,paste0(code,";NULL"),blocking=FALSE)  
  return(list(cluster = cl, con =con, port = port))
}

#options(debug.Socket = TRUE)
#gs <- go.socket("write.csv('a',file='c:/temp/h.txt');NULL")
#evalServer(gs$con,"write.csv(1,file='c:/temp/h.txt');NULL")
#esvSocket::startSocketServer(port = 8201,procfun =processSocket1)
# gs <- go.socket("svSocket::sendSocketClients('gfsfsdfsfsdfsdf',serverport=8888)",port=8888)
# readLines(gs$con)
# readLines(gs$con)
# close.go.socket(gs)
