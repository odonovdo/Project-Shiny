
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#
      # Number of Agents
A <- 3
Agents <- sample(letters,A)
# Number of Customers
N <- 8000
# Number of Time Periods (Min) 
C <- 30
T <- 8*60/C
# Probability of a customer Calling 
P <- abs(rnorm(1,0,0.05))
# Calls in across time period
Calls <- rpois(T,(N*P)/T)

# Duration of Calls (Min)
D <- sample(2:10,sum(Calls),replace = TRUE)

d <- vector()
for (i in 1:length(Calls)){
      d[i] <- sum(D[1:Calls[i]])
      D <- D[-c(1:Calls[i])]
}

Agent_Time <- length(Agents)*C    

library(shiny)

shinyServer(function(input, output) {

  output$distPlot <- renderPlot({

    # generate bins based on input$bins from ui.R
    x    <- faithful[, 2]
    bins <- seq(min(x), max(x), length.out = input$bins + 1)

    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'darkgray', border = 'white')

  })

})
