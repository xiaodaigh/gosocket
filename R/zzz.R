.onLoad <- function(libname, pkgname) {
    require(parallel)
    require(svSocket)    
}

.onAttach <- function(libname, pkgname) {
    require(parallel)
    require(svSocket)
} 