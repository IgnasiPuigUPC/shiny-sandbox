#
# The number of textInput and their labels is dinamycally created via lapply 
#

library(shiny)

ui <- fluidPage(
    
    h1('Foor loop test'),
    br(),
    
 
    column (4, title = 'Foor loop UI',
            numericInput(inputId = "select",
                         label = "Select no of rows:",
                         value = 5)
        ),
    
    fluidRow(),
    
    column(4, uiOutput(outputId = 'ui1')),
    column(4, uiOutput(outputId = 'ui2')),
    column(4, uiOutput(outputId = 'ui3'))
    
    # column(4, 
    #        lapply(1:5, 
    #               function(i) {
    #                   textInput(inputId = paste0('conc',i),
    #                             label = paste('concentration',i, sep =' '))}
    #        )
    # ),
    # 
    # column(4, 
    #        lapply(1:5, 
    #               function(i) {
    #                   textInput(inputId = paste0('units',i),
    #                             label = paste('units',i, sep =' '))}
    #        )
    # )
    
    # column(4, uiOutput(outputId = "ui2")),
    # column(4, uiOutput(outputId = "ui3"))
    
    # dashboardBody(column(4, uiOutput("ui1")),
    #               column(4, uiOutput("ui2")),
    #               column(4, uiOutput("ui3")))
)

server <- function(input, output) {
    
    output$ui1 <- renderUI({
        req(input$select)

        lapply(1:input$select, function(i) {
               renderUI(
                    textInput(inputId = paste0('test',i),
                              label = paste('test',i, sep =' '))
                )
        })
    })

    output$ui2 <- renderUI({
        req(input$select)
        
        lapply(1:input$select, function(i) {
            renderUI(
                textInput(inputId = paste0('conc',i),
                          label = paste('concentration',i, sep =' '))
            )
        })
    })
    
    output$ui3 <- renderUI({
        req(input$select)
        
        lapply(1:input$select, function(i) {
            renderUI(
                textInput(inputId = paste0('unit',i),
                          label = paste('units',i, sep =' '))
            )
        })
    })
}

shinyApp(ui = ui, server = server)