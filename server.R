
library(shiny)
library(ggplot2)

shinyServer(function(input, output) {
      
      AgentsSkill <- reactive({
            Agents <- as.data.frame(rbind(c("Experienced",input$NoE,1.0),
                                          c("Average",input$NoA,0.8),
                                          c("Novice",input$NoN,0.6)))
            names(Agents) <- c("Expertise","Available","Competency")
            Agents[,2:3] <- lapply(Agents[,2:3],function(x)as.numeric(as.character(x)))
            transform(Agents,Productivity =(Available* Competency))
      })
      
      CallSimul <- reactive({
            Bin <- list()
            CallDur <- list()
            for (j in 1:15){
                  Calls <-  rpois(16,(input$N*abs(rnorm(input$N,0,                                                        as.numeric(input$p)/100)))/16)
                  # Duration of Calls (Min)
                  D <- vector()
                  D <- sample(10:30,sum(Calls),replace = TRUE)
                  
                  #Total Call load per Period (30 min)
                  d <- vector()
                  for (i in 1:length(Calls)){
                        d[i] <- sum(D[1:Calls[i]])
                        D <- D[-c(1:Calls[i])]
                  }
                  Bin[[j]] <- d
            }
                  do.call(cbind,Bin)
                  })
      
      output$AgentPlot <- renderPlot({
            
            plot1 <- ggplot(AgentsSkill(),aes(Expertise,Available,fill=Expertise))+
                  geom_bar(stat="identity")+theme_classic()+
                  ggtitle("Staff Type Available")
            plot1
      })
      
      output$distPlot <- renderPlot({
            
            PeriodAvg <- rowMeans(CallSimul(),na.rm = TRUE)
            
            CallVol <- as.data.frame(cbind(Period=seq_along(PeriodAvg),
                                           Volume=PeriodAvg))
            Data <- AgentsSkill()
            StaffSkill <- sum(Data[,2]*Data[,3],na.rm = T)
            
            plot2 <- ggplot(CallVol,aes(Period,Volume))+
                  geom_line()+
                  geom_hline(y=StaffSkill*30,color="red")+
                  ylim(0,NA)+
                  theme_classic()+
                  ggtitle("Demand vs Capacity (per 30 min Intervals)")
            plot2
      })
      
      output$summary <- renderPrint({
            summary(rowMeans(CallSimul(),na.rm = TRUE)/sum((AgentsSkill()[,4]*30)))
      })
      output$table <- renderTable({
            StaffAv <- AgentsSkill()
            StaffAv[,c(1,4)]
            })
      output$ProdPlot <- renderPlot({
            StaffAv <- AgentsSkill()
           barplot(StaffAv[,4]*30)
      })
      
      
      
      
})
