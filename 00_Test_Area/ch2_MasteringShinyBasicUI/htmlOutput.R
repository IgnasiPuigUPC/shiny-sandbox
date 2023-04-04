library(shiny)

ui <- fluidPage(
  textOutput("text"),
  htmlOutput("code")
)
server <- function(input, output, session) {
  output$text <- renderText({ 
    "Hello friend!" 
  })
  output$code <- renderUI({ 
    div(HTML('<h1 style = \'color:blue\')>Color blue</h1>'))
  })
}

shinyApp(ui, server)