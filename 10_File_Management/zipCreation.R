# This app creates a zip file with the following structure:
# file2.txt
# dir1/file1.txt

# All actions are performed in one file.

# hem de provar de treure els setwd i getwd emprant el camí d'amagatzematge 

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
      
      dirToSave <- file.path(tempdir(), 'dir1') 
        
      if(dir.exists(dirToSave)) {
        
        cat(file = stderr(), paste('Files in tempdir:\n', 
                                   paste(list.files(path = dirToSave, all.files = TRUE, full.names = TRUE), collapse ='\n')), 
            collapse = '\n')
        
        cat(file = stderr(), paste('Directories before removing dir1:\n', 
                                   paste(list.dirs(path = tempdir()), collapse = '\n ')), 
            collapse = '\n')
        # file.remove(list.files(path = dirToSave, all.files = TRUE, full.names = TRUE))
        unlink(dirToSave, recursive = TRUE)
        cat(file = stderr(), paste('Directories after removing dir1:\n', 
                                   paste(list.dirs(path = tempdir()), collapse = '\n ')), 
            collapse = '\n')
      }
      
      dir.create(dirToSave)
      
      #fill and save file1
      fileName1 <- paste(input$file1, '.txt', sep ='')
      fileConn <- file(file.path(dirToSave, fileName1))
      writeLines(input$file1Content, fileConn)
      close(fileConn)
      
      #fill and save file2
      fileName2 <- paste(input$file2, '.txt', sep = '')
      fileConn <- file(file.path(tempdir(), fileName2))
      writeLines(input$file2Content, fileConn)
      close(fileConn)

      #create zip file
      
      if (dir.exists('dir1')) {
        
        unlink('dir1', recursive = T)
        dir.create('dir1')
        
      }
      
      file.rename(from = file.path(dirToSave, fileName1), to = file.path('dir1',fileName1))
      file.rename(from = file.path(tempdir(), fileName2), to = fileName2)

      zip(zipfile = file, 
          files = c(file.path(tempdir(), fileName2), file.path(tempdir(), 'dir1',fileName1)))

    }
  )
  
}

shinyApp(ui, server)
