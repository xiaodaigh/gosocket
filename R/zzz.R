.onLoad <- function(libname, pkgname) {
    require(shiny)    
}

.onAttach <- function(libname, pkgname) {
    require(parallel)
    require(svSocket)
} 