# server.R
library(shiny)
library(shinythemes)  
library(shinyAce)
# Design 2:
renderLogEntry <- function(entry){
  paste0(entry, " - ", date())
}


withConsoleRedirect <- function(containerId, expr) {
  txt <- capture.output(results <- expr, type = "output")
  if (length(txt) > 0) {
    appendTabsetPanel(session, "console", tabPanel("Console", verbatimTextOutput(paste0(txt, "\n"))))
  }
  results
}



shinyServer(function(input, output, session) {
  
  # Ocultar el panel lateral al inicio
  hide("sidebar")
  observeEvent(input$theme_button, {
    showModal(modalDialog(
      title = "Elige un tema",
      shinythemes::themeSelector()
    ))
  })
  
  # Agrega este observador para actualizar el tema del editor
  observe({
    updateAceEditor(
      session,
      "rmd",
      theme = input$theme_code
    )
  })
  # Evaluar el código
  output$knitDoc <- renderUI({
    input$eval
    HTML(knitr::knit2html(text = isolate(input$rmd), quiet = TRUE))
  })
  
  
  
  
  #clear the editor
  observeEvent(input$clear,{
    updateAceEditor(session,'rmd',value = '')
  })
  
  #Open chunk
  observeEvent(input$open_chunk,{
    updateAceEditor(session,'rmd',value = paste(isolate(input$rmd),"\n```{r}\n\n```\n",sep = ''))
  })
  
  #Hotkeys
  
  ## Open chunk hotkey
  observeEvent(input$rmd_open_chunk, {
    # Get the current value of the editor
    old_val <- isolate(input$rmd)
    
    # Define the new chunk
    new_chunk <- "\n```{r}\n\n```\n"
    
    # Insert the new chunk at the end of the current value
    new_val <- paste(old_val, new_chunk, sep = "")
    
    # Update the editor with the new value
    updateAceEditor(session, 'rmd', value = new_val)
  })
  
  ## Open help menu hotkey
  observeEvent(input$rmd_help_key, {
    # Mostrar el menú de ayuda
    showModal(modalDialog(
      title = "Help Menu",
      h2("Hot-Keys"), # Título del menú de ayuda
      "Use the following hot-keys:", # Descripción de los hot-keys
      tags$ul(
        tags$li("Ctrl-Alt-I: Open Chunk"), # Hot-key para abrir un nuevo bloque de código
        tags$li("Ctrl-F: Buscar y Reemplazar"), # Hot-key para guardar el código
        tags$li("F1: Help Menu"), # Hot-key para abrir el menú de ayuda
        tags$li("Ctrl-Z: Undo"), # Hot-key para deshacer la última acción
        tags$li("Ctrl-Y: Redo") # Hot-key para rehacer la última acción
      )
    ))
  })  
  # Agrega estos manejadores de descarga para los botones save_code y save_knit
  output$save_code <- downloadHandler(
    filename = function() {
      paste("code-", Sys.Date(), ".Rmd", sep="")
    },
    content = function(file) {
      writeLines(input$rmd, file)
    }
  )
  
  output$save_knit <- downloadHandler(
    filename = function() {
      paste("knit-", Sys.Date(), ".html", sep="")
    },
    content = function(file) {
      knit2html(text = input$rmd, output = file)
    }
  )
  
  # Toggle sidebar
  observeEvent(input$toggleSidebar, {
    toggle("sidebar")
  })
  
  # Consola al ejecutar el código
  # En tu archivo server.R, reemplaza la función renderPrint para console con esto:
  output$console <- renderPrint({
    input$eval
    # Divide el texto del editor Ace en bloques de código R
    r_chunks <- strsplit(input$rmd, "```\\{r\\}|```")[[1]]
    # Elimina los bloques de texto que no son código R
    r_chunks <- r_chunks[seq(2, length(r_chunks), by = 2)]
    # Ejecuta cada bloque de código R y captura su salida
    console_output <- lapply(r_chunks, function(r_code) {
      output <- capture.output(eval(parse(text = r_code)))
      # Elimina los códigos de escape ANSI y los códigos de control de terminal
      output <- gsub("\033\\[[0-9;]*m", "", output)
      output <- gsub("\r", "", output)
      output
    })
    # Imprime cada salida de consola individualmente
    console_output <- unlist(console_output)
    console_output
  })
  
  })
  
  
  
  
