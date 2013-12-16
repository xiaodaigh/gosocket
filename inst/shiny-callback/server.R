#install.packages(c("devtools","svSockets")) # if not already installed
#devtools::install_github("gosocket","analytixware") # if not already installed
#devtools::install_github("shinysky","analytixware") # if not already installed

library(shiny)
library(shinysky)
library(gosocket)

# Define server logic required to generate and plot a random distribution
shinyServer(function(input, output,session) {
  
  call.back.register <- list(go.sockets = list(),call.back.func = list())
  
  a <- reactiveTimer(session=session)
  
  # a reactive timer to watch the call.back.register
  observe({
    a() 
    #print("periodic checking if file exsits")
    
    if(length(call.back.register$go.sockets) == 1) {
      #browser()
      gs <- call.back.register$go.sockets[[1]]
      if(file.exists(gs$tmp.f)) {
       # browser()
          call.back.register$go.sockets[[1]] <<- NULL      
          f <- call.back.register$call.back.func[[1]]
          call.back.register$call.back.func[[1]] <<- NULL
          f()        
          showshinyalert("alert2","The callback has been called!",session,"success")
        }
      }
  })
  
  
  # add a callback when the button is clicked
  observe({
    if(input$btn  == 0) return()
    
    tmp.f <- gsub("\\","/",tempfile(),fixed=TRUE)
    code <- sprintf("write(1,file='%s')",tmp.f)
    gs <- go.socket(sprintf("Sys.sleep(30);%s",code))
    #gs <- go.socket(sprintf("%s",code))
    gs$tmp.f <- tmp.f
    
    
    showshinyalert("alert1","It is sleeping for 30 seconds in another process! But this is not blocked! When it wakes up it will trigger another alert",session,"success")
    l <- length(call.back.register$go.sockets) + 1        
    call.back.register$go.sockets[l] <<- list(gs)
    call.back.register$call.back.func[l] <<- list(f = function() {print("call back successful")})
  })
  
  output$distPlot <- renderPlot({    
    # generate an rnorm distribution and plot it
    dist <- rnorm(input$obs)
    hist(dist)
  })
})