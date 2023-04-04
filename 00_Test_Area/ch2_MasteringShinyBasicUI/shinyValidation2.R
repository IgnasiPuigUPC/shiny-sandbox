#
# Validate text input as to be numeric
#
# using shinyFeedback package to validate that a text input is always numeric
#

library(shiny)
library(shinyFeedback)

ui <- fluidPage(
  shinyFeedback::useShinyFeedback(),
  numericInput("n", "n", value = 10),
  textOutput("half")
)

server <- function(input, output, session) {
  half <- reactive({
    even <- input$n %% 2 == 0
    shinyFeedback::feedbackWarning("n", !even, "Please select an even number")
    input$n / 2    
  })
  
  output$half <- renderText(half())
}

shinyApp(ui, server)