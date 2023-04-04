library(shiny)

ui <- fluidPage(
  
  fluidRow(column(width = 3,
                  textInput('name','', value = 'Enter your name')),
           column(width = 3,
                  sliderInput('dateRAnge','When should we deliver?',
                              min = as.Date('2020/09/16'), max = as.Date('2020/09/23'), 
                              value = as.Date('2020/09/17'), timeFormat = '%d/%b/%y')),
           column(width = 3,
                  sliderInput('dateRAnge','When should we deliver?',
                              min = as.Date('2020/09/16'), max = as.Date('2020/09/23'), 
                              value = c(as.Date('2020/09/17'), as.Date('2020/09/19')),
                              timeFormat = '%d/%b/%y',
                              dragRange = T)),
           column(width = 3,
                  sliderInput('zero2hund','Zero to Hundred slider', 
                              min = 0, max = 100, value = 50, step = 5,
                              animate = TRUE))),
  
  fluidRow(column(4,
                  selectInput("name", "Names to chose", 
                              choices = list('Man' = c('Antoni','Pere','Joan'),
                                             'Woman' = c('Maria','Blanca','Paula')))),
           column(6,
                  uiOutput('choice')))
  
)

server <- function(input, output, session) {
  
  output$choice <- renderUI(h1(input$name))
  
}

shinyApp(ui, server)