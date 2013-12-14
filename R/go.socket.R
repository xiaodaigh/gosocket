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
  evalServer.nb(con,code,return.res=FALSE)
  return(list(cluster = cl, con =con, port = port))
}
