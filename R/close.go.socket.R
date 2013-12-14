#' close.go.socket
#' 
#' Close a goschoket connection create from go.socket
#' 
#' @param gs The list returned from go.socket
#'   
#' @export
close.go.socket <- function(gs) {
  close(gs$con)
  stopCluster(gs$cl)
}
