#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
fluidPage(
    title = 'Creating a UI from a loop',
    
    sidebarLayout(
        sidebarPanel(
            # create some select inputs
            lapply(1:5, function(i) {
                selectInput(paste0('a', i), paste0('SelectA', i),
                            choices = sample(LETTERS, 5))
            })
        ),
        
        mainPanel(
            verbatimTextOutput('a_out'),
            
            # UI output
            lapply(1:10, function(i) {
                uiOutput(paste0('b', i))
            })
        )
    )
)
