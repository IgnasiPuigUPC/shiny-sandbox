# This app creates a zip file with the following structure:
# file2.txt
# dir1/file1.txt

# All actions are performed in one file.

# The procedure does change the working directory to tempdir() at the beginning of the server. 
# While this procedure works when running at once it fails when running at debuggin mode

library(shiny)

ui <- fluidPage(
  
  h1('File 1'),
  
  fluidRow(
    
    column(width = 4, 
           textInput(inputId = 'file1',
                     label = 'First file name',
                     value = 'file1'),
           offset = 1),
    
    column(width = 4,
           textInput(inputId = 'file1Content',
                     label = 'First file content',
                     value = 'text to include in file 1'),
           offset = 1)
    ),    
  
  h1('File 2'),
  
  fluidRow(

    column(width = 4,
           textInput(inputId = 'file2',
                     label = 'Second file name',
                     value = 'file2'),
           offset = 1),
    
    column(width = 4,
           textInput(inputId = 'file2Content',
                     label = 'Second file content',
                     value = 'text to include in file 2'),
           offset = 1)
  ),
  
  h1('Zip file'),
  
  fluidRow(
    
    column(width = 4,
           textInput(inputId = 'zipName',
                     label = 'Zip file name',
                     value = 'zipIgnasi'),
           offset = 1),
    
    br(),

    column(width = 2,
           downloadButton(outputId = 'zipCreate',
                          label = 'Create zip'),
           offset = 1)
  )

  
)

server <- function(input, output, session) {
  
  output$zipCreate <- downloadHandler(
    
    filename = function() {
      paste(input$zipName, "_", format(Sys.time(), "%Y%m%d"), ".zip", sep = "")
    },
    
    content = function(file) {
      
      cat(file = stderr(), paste(paste('Working directory:', getwd()), paste('Temp directory:', tempdir()), sep = '\n'), 
          collapse = '\n')
      
      #file 1
      
      #create file1 subdirectory. If it exists it removes it first. This avoids including old files from an existing directory 
      #that later become part of the zip
      
      lwd <- getwd()
      setwd(tempdir())
      cat(file = stderr(), paste(paste('New working directory:', getwd())))
      
      dir.create(file.path('dir1'))
      
      #fill and save file1
      fileName1 <- paste(input$file1, '.txt', sep ='')
      fileConn <- file(file.path('dir1',fileName1))
      writeLines(input$file1Content, fileConn)
      close(fileConn)
      
      #fill and save file2
      fileName2 <- paste(input$file2, '.txt', sep = '')
      fileConn <- file(file.path(fileName2))
      writeLines(input$file2Content, fileConn)
      close(fileConn)

      #create zip file
      
      zip::zip(zipfile = file,
               files = c(file.path(fileName2), file.path('dir1',fileName1)),
               mode = 'mirror',
               include_directories = TRUE,
               recurse = TRUE)
      
      setwd(lwd)

    }
  )
  
}

shinyApp(ui, server)
