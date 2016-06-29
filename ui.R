library(ggplot2)
library(dplyr)
library(shiny)
library(reshape2)



# Define UI for application that draws a histogram
ui <- shinyUI(fluidPage(
   
   # Application title
   titlePanel("A Taylor Rule Calculator:"),
   p("This page calculates the recommended federal funds rate using the",
     a("Taylor rule:",href="https://en.wikipedia.org/wiki/Taylor_rule"),
     pre("N=I+E+i(T-I)+o(log(P)-log(O))"),
     "with data fetched from ",
     a("FRED",href="https://fred.stlouisfed.org/"), 
     "and plotted below:"
     ),
   plotOutput('plot'),
   hr(),
   fluidRow(
       column(4,
              numericInput('E',"Equilibrium Interest Rate (E):",3,0,10,.1, '200px'),
              numericInput('T', "Target Inflation Rate (T):", 2,0,12,.1, '200px'),
              numericInput('i', "Inflation Coefficient (i):", .5, 0,2,.01, '200px'),
              numericInput('o',"Output coefficient (o):",.5, 0,2,.01, '200px')
       ),
       column(4,
           dateRangeInput('dr',"Date Range:", 
                          start=min(S$Date),
                          end=max(S$Date),
                          min=min(S$Date),
                          max=max(S$Date),
                          startview='year'),
           checkboxInput("dispF","Display Past Funds rate? (F):"),
           checkboxInput("dispI", "Display Past Interest Rate? (I):"),
           checkboxInput("dispG", "Display Past GDP gap? (G):")
       )
   )
))
