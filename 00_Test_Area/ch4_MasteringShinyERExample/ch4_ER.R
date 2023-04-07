# libraries

library(shiny)
library(vroom)
library(tidyverse)

# loading data

injuries <- vroom::vroom("neiss/injuries.tsv.gz")
products <- vroom::vroom("neiss/products.tsv")
population <- vroom::vroom("neiss/population.tsv")

# utils

# name vector of product titles as selectInput shows names and reports back contents
prodCodes <- setNames(products$prod_code, products$title)

# functions

# given an ordered table shows up to numGrup rows and the remaining in others
topSumm <- function(data2cut, numGrup = 5) {
  data2cut$n <- round(data2cut$n,0)
  return(rbind(data2cut[1:numGrup,],
               c('Others', sum(data2cut$n[(numGrup+1):nrow(data2cut)]))))
}

ui <- fluidPage(
  
  fluidRow(column(width = 4,
                  selectInput('product','Product', choices = prodCodes))),
  
  fluidRow(column(width = 4,
                  tableOutput('loc')),
           column(width = 4,
                  tableOutput('bodyPart')),
           column(width = 4, 
                  tableOutput('diag'))),
  
  fluidRow(column(width = 8,
                  offset = 2,
                  plotOutput('plotNorm')))
  
)

server <- function(input, output, session) {
  
  selected <- reactive({injuries[injuries$prod_code == input$product,]})
  
  output$loc <- renderTable(topSumm(selected() %>% count(location, wt = weight, sort = TRUE)),
                            align = NULL,
                            width = '100%')
  output$bodyPart <- renderTable(topSumm(selected() %>% count(body_part, wt = weight, sort = TRUE)),
                                 align = NULL,
                                 width = '100%')
  output$diag <- renderTable(topSumm(selected() %>% count(diag, wt = weight, sort = TRUE)),
                             align = NULL,
                             width = '100%')
  
  summary <- reactive({selected() %>% 
                      count(age, sex, wt = weight) %>%
                      left_join(population, by = c("age", "sex")) %>% 
                      mutate(rate = n / population * 1e4)})
  output$plotNorm <- renderPlot({summary() %>% 
                                ggplot(aes(age, rate, colour = sex)) + 
                                geom_line(na.rm = TRUE) + 
                                labs(y = "Injuries per 10,000 people")},
                                res = 96)
  
}

shinyApp(ui, server)