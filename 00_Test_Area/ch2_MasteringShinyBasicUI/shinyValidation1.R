#
# Validate text input as to be numeric
#
# using shinyFeedback package to validate that a text input is always numeric
#

library(shiny)
library(shinyFeedback)

ui <- fluidPage(
  
  shinyFeedback::useShinyFeedback(),
  textInput('number','Enter number', value = 10),
  textOutput("half")
  
)

server <- function(input, output, session) {
  
  half <- reactive({
    if(!is.na(as.numeric(input$number))){
      shinyFeedback::hideFeedback('number')
      return(as.numeric(input$number) / 2)
    }else{
      shinyFeedback::feedbackDanger('number', TRUE, "Please enter a numeric value")
      return('Not numeric input')
    }
  })

  output$half <- renderText(half())
  
}

shinyApp(ui, server)