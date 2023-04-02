#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

selectInput("dataset", label = "Dataset", choices = ls("package:datasets"))

ui <- fluidPage(
  
  textInput("name", "What's your name?"),
  textOutput("greeting")
  
)

server <- function(input, output, session) {
  
  output$greeting <- renderText({
    paste0("Hello ", input$name)
  })
  
}

shinyApp(ui, server)
