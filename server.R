
library(shiny)
library(ggplot2)

shinyServer(function(input, output) {
   
      output$AgentPlot <- renderPlot({
            AgentsSkill <- as.data.frame(table(sample(c("Expert","Average","New"),
                                    input$Agents,replace = T,
                                    prob = c(0.3,0.5,0.2))))
            names(AgentsSkill) <- c("Expertise","Available")
            plot1 <- ggplot(AgentsSkill,aes(Expertise,Available,fill=Expertise))+
                  geom_bar(stat="identity")+theme_classic()+
                  ggtitle("Staff Type Available")
            plot1
            })
    
            output$distPlot <- renderPlot({
                  Bin <- list()
                  for (j in 1:10){
                        Calls <-  rpois(16,(input$N*abs(rnorm(input$N,0,0.05)))/16)+1
                        # Duration of Calls (Min)
                        D <- vector()
                        D <- sample(5:10,sum(Calls),replace = TRUE)
                        #Total Call load per Period (30 min)
                        d <- vector()
                        for (i in 1:length(Calls)){
                              d[i] <- sum(D[1:Calls[i]])
                              D <- D[-c(1:Calls[i])]
                        }
                        Bin[[j]] <- d
                  }
                  Average <- do.call(cbind,Bin)
                  PeriodAvg <- rowMeans(Average)
                  
            CallVol <- as.data.frame(cbind(Period=seq_along(PeriodAvg),
                                           Volume=PeriodAvg))
            
            plot2 <- ggplot(CallVol,aes(Period,Volume))+
                  geom_line()+
                  geom_hline(yintercept=input$Agents*30,colour="red")+
                  geom_hline(yintercept=mean(CallVol$Volume),colour="Green")+
                  theme_classic()+ggtitle("Call Volume Demand per 30 min Interval")
            
            plot2
      })
      })
