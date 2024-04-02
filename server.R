# server.R
library(shiny)
library(shinythemes)  
# Design 2:
renderLogEntry <- function(entry){
  paste0(entry, " - ", date())
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
  
  #Consola en vivo
  console <- function(message) {
    shinyjs::html("console", message)
  }
  observeEvent(input$console, {
    console(input$console)
  })
})
