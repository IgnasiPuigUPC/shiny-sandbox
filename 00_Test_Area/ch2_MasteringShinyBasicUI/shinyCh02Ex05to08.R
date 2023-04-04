library(shiny)
library(DT)

ui <- fluidPage(
  plotOutput("plot", width = "400px"),
  dataTableOutput("table1"),
  DTOutput("table2"),
  verbatimTextOutput('lm')
)
server <- function(input, output, session) {
  output$table1 <- renderDataTable(mtcars, 
                                   options = list(pageLength = 5, 
                                                  searching = FALSE,
                                                  ordering = FALSE))
  output$table2 <- renderDT(mtcars, 
                            options = list(pageLength = 5,
                                           ordering = FALSE))
  output$plot <- renderPlot(plot(1:5), 
                            res = 96, width = 700, height = 300,
                            alt = 'Plot of points')
  output$lm <- renderPrint(str(lm(mpg ~ wt, data = mtcars)))
}

shinyApp(ui, server)