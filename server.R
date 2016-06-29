library(ggplot2)
library(dplyr)
library(shiny)
library(reshape2)

# econ.rds is created by the separate fetch.R script. 
S<-readRDS('econ.rds')

# N = I + E + i(T – I) + o(log(P) – log(O))
# N = Suggested Nominal Interest Rate (o)
# I = Current Inflation (F)
# E = The Equilibrium Real Interest Rate (i)
# i = Inflation Coefficient (i)
# T = Target Inflation Rate (i)
# o = Output Coefficient (i)
# P = Potential Output (F)
# O = Current Output (F)
# 
# Generally, it was suggested that i = o = 0.5, and E = T = 2 (as in 2%).
# Fred equivalent series. 
# O = GDPC1 (2009 dollars)
# P = GDPPOT  (2009 dollars)
# I = (CPI - (CPI_{-12}))/CPI Using consumer CPI monthly. CPIAUCSL
# i = .5 input 0..2
# o = .5 input 0..2
# T = 2 input 0..12
# E = 2 input 0..6
# We also pull and display:
# F = FEDFUNDS
# Taylor's original paper used GDP deflator instead of CPI differential. 

server <- shinyServer(function(input, output) {
   output$plot <- renderPlot({
       
       S$N <- S$I + input$E + input$i * ( input$T-S$I) + 100*input$o*(log(S$P)-log(S$O))
       tdf <- data.frame(Date=S$Date, N=S$N)
       if(input$dispF){
           tdf$F<-S$F
       }
       if(input$dispI){
           tdf$I<-S$I
       }
       if(input$dispG){
           tdf$G<-100*(log(S$P)-log(S$O))
       }
       m<-melt(tdf,id='Date')
       g<-ggplot(m,aes(x=Date,y=value,color=variable))+geom_line()+ylab('Rate (%)')
       # With a dorky user dateRangeInput can give us a negative range, which sucks.
       g <- g+xlim(min(input$dr[1],input$dr[2]-1), input$dr[2])
    g
   })
})

# Run the application 
shinyApp(ui = ui, server = server)
