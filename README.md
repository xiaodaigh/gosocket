gosocket
========
Allows for simple go-routine like execution of code (as in syntax but NOT in lightweight-ness) in a non-blocking manner on socket server.

# Install
```r
install.packages("devtools") #if not already installed
devtools::install_github("AnalytixWare/gosocket")
```

# Usage
```r
library(gosocket)
system.time(gs <- go.socket("z <- rnorm(10^8)")) # go.socket is non-blocking the rest of the code will execute almost immedidately
print("Don't have to wait for it to finish") 
evalServer.nb(gs$con,"summary(z)") # to retrieve the results; this is blocking
print("The above you have to wait for!")
close.go.socket(gs) # good practise to close the go.socket
```
