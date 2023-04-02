library(shiny)
library(ggplot2)

datasets <- c("economics", "faithfuld", "seals")

ui <- fluidPage(
  selectInput("dataset", "Dataset", choices = datasets),
  verbatimTextOutput("summary"),
  plotOutput("plot") #bug3
)

server <- function(input, output, session) {
  dataset <- reactive({
    get(input$dataset, "package:ggplot2")
  })
  output$summary <- renderPrint({ #bug2
    summary(dataset())
  })
  output$plot <- renderPlot({
    plot(dataset()) #bug1
  }, res = 96)
}

shinyApp(ui, server)