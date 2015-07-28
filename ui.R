
library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Example of Call Arrival rates for a Call Centre"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      sliderInput("N",
                  "Number of Customers:",
                  min = 100,
                  max = 15000,
                  value = 5000,step = 250,
                  animate = TRUE),
      
      numericInput("NoA","No. Average Staff",
                   1,
                   min=0,max=9,step = 1),
      
      numericInput("NoE","No. Experienced Staff",
                   1,
                   min=0,max=9,step = 1),
      numericInput("NoN","No. Novice Staff",
                   1,
                   min=0,max=9,step = 1),
      
      selectInput("p","Probability of a Customer Calling %",c(0.1,0.5,1,5,10),selected = 1),
      submitButton("Update View")),
      
    mainPanel(
          tabsetPanel(
                tabPanel("Plot", plotOutput("distPlot",width = "100%"), 
                         plotOutput("AgentPlot",width = "80%")), 
                tabPanel("Summary", verbatimTextOutput("summary")), 
                tabPanel("Table", tableOutput("table"),plotOutput("ProdPlot"))
          )
    )
   
  )
))
