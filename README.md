gosocket
========
Allows for simple go-routine like execution of code in a non-blocking manner on socket server

# Install
install.packages("devtools") #if not already installed
devtools::install_github("gosocket","AnalytixWare")

# Usage
'''
system.time(gs <- go.socket("z <- rnorm(10^3)"))
print("Don't have to wait for it to finish")
evalServer.nb(gs$con,"summary(z)") # to retrieve the results
print("The above you have to wait for!")
close.go.socket(gs) # go practise to close the go.socket
'''
