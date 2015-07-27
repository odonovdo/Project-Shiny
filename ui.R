
library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Call Centre Metrics"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      sliderInput("Agents",
                  "Number of Agents:",
                  min = 1,
                  max = 15,
                  value = 5),
      sliderInput("N",
                  "Number of Customers:",
                  min = 100,
                  max = 15000,
                  value = 5000)),
      

    mainPanel(
      plotOutput("distPlot"),
      plotOutput("AgentPlot")
      
    )
  )
))
