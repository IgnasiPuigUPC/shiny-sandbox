library(shiny)

df <- lapply(1:10, FUN = function(i) rnorm(sample(10,1)))

ui <- fluidPage(
  
  numericInput('no','Enter value to range', val = 2),
  htmlOutput('vals')
  
)

server <- function(input, output, session) {
  
  values <- reactive(df[[input$no]])
  maxMin <- reactive(range(values(), na.rm = TRUE))
  output$vals <- renderUI(h3(paste('[',paste(round(maxMin(),2), collapse =', '),']', sep ='')))
  
  
}

shinyApp(ui, server)