#
# selectInput boxes created dinamycally based on the countries selected
#

library(shiny)

ui <- fluidPage(
    
    h1('Foor loop test'),
    br(),
    
    title = 'Foor loop UI',
        selectInput(
            inputId = "select",
            label = "Select countries:",
            choices = c("CH", "JP", "GER"),
            multiple = TRUE),
    
    column(4, uiOutput(outputId = "ui1")),
    column(4, uiOutput(outputId = "ui2")),
    column(4, uiOutput(outputId = "ui3"))
    
    # dashboardBody(column(4, uiOutput("ui1")),
    #               column(4, uiOutput("ui2")),
    #               column(4, uiOutput("ui3")))
)

server <- function(input, output) {
    
    output$ui1 <- renderUI({
        req(input$select)

        lapply(seq_along(input$select), function(i) {
            # fluidRow(
                renderUI(p(input$select[i]))
            # )
        })
    })

    output$ui2 <- renderUI({
        req(input$select)

        lapply(seq_along(input$select), function(i) {
            fluidRow(
                renderUI(
                    textInput(inputId = 'entry',
                              label = input$select[i],
                              value = input$select[i])
                )
            )
        })
    })

    output$ui3 <- renderUI({
        req(input$select)
        
        lapply(seq_along(input$select), function(i) {
            fluidRow(
                renderUI(
                    textInput(inputId = 'entry',
                              label = input$select[i],
                              value = input$select[i])
                )
            )
        })
    })
}

shinyApp(ui = ui, server = server)