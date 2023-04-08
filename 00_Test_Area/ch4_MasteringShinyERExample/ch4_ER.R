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
  
  fluidRow(column(width = 8,
                  selectInput('product','Product', 
                              choices = prodCodes,
                              width = '100%')),
           column(width = 4,
                  selectInput('yAxis','Graph Type', 
                              choices = setNames(object = c('absolute','relative'),
                                                 nm = c('Count of events','Frequency of events')),
                              selected = 'relative'))),
  
  fluidRow(column(width = 4,
                  tableOutput('loc')),
           column(width = 4,
                  tableOutput('bodyPart')),
           column(width = 4, 
                  tableOutput('diag'))),
  
  fluidRow(column(width = 8,
                  offset = 2,
                  plotOutput('plotNorm'))),
  
  h4('Narrative browser'),
  
  fluidRow(column(width = 2,
                  actionButton('forward','Forward', width = '100%'),
                  actionButton('backward','Backward', width = '100%')),
           column(width = 10,
                  textOutput('counter'),
                  textOutput('story')))
  
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
  
  summary <- reactive({if (input$yAxis == 'absolute') {
                           return(list(toPlot = selected() %>% count(age, sex, wt = weight, name = 'rate'),
                                       title = 'Count of events',
                                       yLegend = 'counts'))
                       } else {
                           return(list(toPlot = selected() %>% 
                                                  count(age, sex, wt = weight) %>%
                                                  left_join(population, by = c("age", "sex")) %>% 
                                                  mutate(rate = n / population * 1e4),
                                       title = 'Frequency of events',
                                       yLegend = 'Injuries per 10,000 people'))
                       }
                    })
    
  output$plotNorm <- renderPlot({summary()$toPlot %>%
                                 ggplot(aes(age, rate, colour = sex)) +
                                 geom_line(na.rm = TRUE) +
                                 labs(title = summary()[[2]],
                                      y = summary()$yLegend)},
                                res = 96)
  
  counter <- reactiveVal(value = 1)
  observeEvent(eventExpr = input$product,
               handlerExpr = {counter(1)})
  observeEvent(eventExpr = input$forward,
               handlerExpr = {if (counter() == (nrow(selected())))
                                counter(1)
                              else
                                counter(counter() + 1)})
  observeEvent(eventExpr = input$backward,
               handlerExpr = {if (counter() == 1)
                                counter(nrow(selected()))
                              else
                                counter(counter() - 1)})
  output$counter <- renderText(counter())
  output$story <- renderText(selected()$narrative[counter()])
  
}

shinyApp(ui, server)