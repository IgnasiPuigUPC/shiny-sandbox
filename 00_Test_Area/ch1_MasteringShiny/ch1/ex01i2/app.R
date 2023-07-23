#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    title = "Gimme your name",

    # input slot for name 
    textInput(inputId = 'name', label = 'Give me your name'),
    
    # print greeting
    textOutput(outputId = 'greeting')
    
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$greeting <- renderText(expr = {paste('Hello ', input$name, '!', sep ='')})
}

# Run the application 
shinyApp(ui = ui, server = server)
