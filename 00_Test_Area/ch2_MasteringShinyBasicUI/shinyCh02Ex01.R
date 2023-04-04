library(shiny)

ui <- fluidPage(
  
  fluidRow(column(width = 4,
                  textInput('name','', value = 'Enter your name')),
           column(width = 4,
                  sliderInput('dateRAnge','When should we deliver?',
                              min = as.Date('2020/09/16'), max = as.Date('2020/09/23'), 
                              value = as.Date('2020/09/17'), timeFormat = '%d/%b/%y')),
           column(width = 4,
                  sliderInput('dateRAnge','When should we deliver?',
                              min = as.Date('2020/09/16'), max = as.Date('2020/09/23'), 
                              value = c(as.Date('2020/09/17'), as.Date('2020/09/19')),
                              timeFormat = '%d/%b/%y',
                              dragRange = T))),
  fluidRow(column(width = 4,
                  textInput('name','', value = 'Enter your name')),
           column(width = 4,
                  sliderInput('dateRAnge','When should we deliver?',
                              min = as.Date('2020/09/16'), max = as.Date('2020/09/23'), 
                              value = as.Date('2020/09/17'), timeFormat = '%d/%b/%y')),
           column(width = 4,
                  sliderInput('dateRAnge','When should we deliver?',
                              min = as.Date('2020/09/16'), max = as.Date('2020/09/23'), 
                              value = c(as.Date('2020/09/17'), as.Date('2020/09/19')),
                              timeFormat = '%d/%b/%y',
                              dragRange = T)))
  
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)