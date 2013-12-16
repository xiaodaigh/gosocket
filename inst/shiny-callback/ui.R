library(shiny)
library(shinysky)

# Define UI for application that plots random distributions 
shinyUI(basicPage(
     actionButton("btn","Click me to run callback",style.class="danger")     
     ,shinyalert("alert1")
     ,shinyalert("alert2")
     ,sliderInput("obs", 
                 "Number of observations:", 
                 min = 1,
                 max = 1000, 
                 value = 500)
    ,plotOutput("distPlot")
        
  )
)