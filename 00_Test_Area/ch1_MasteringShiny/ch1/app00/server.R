server <- function(input, output, session) {

  dataset <- reactive({
	  get(input$dataset)
  })

  output$summary <- renderPrint(expr = {
    summary(dataset())
  })
  
  output$table <- renderTable(expr = {
    dataset()
  })
}