# server.R

library(shiny)
library(shinythemes)  

# Función para renderizar las entradas del log
renderLogEntry <- function(entry) {
  paste0(entry, " - ", date())
}


shinyServer(function(input, output, session) {
  
  # Ocultar el panel lateral al inicio
  hide("sidebar")
  
  # Manejar el clic en el botón de elegir tema
  observeEvent(input$theme_button, {
    showModal(modalDialog(
      title = "Elige un tema",
      shinythemes::themeSelector()
    ))
  })
  
  # Actualizar el tema del editor
  observe({
    updateAceEditor(
      session,
      "rmd",
      theme = input$theme_code
    )
  })
  
  # Renderizar el documento markdown convertido a HTML
  output$knitDoc <- renderUI({
    if (!identical(input$save_knit, NA)) {
      return()
    }
    input$eval
    HTML(knitr::knit2html(text = isolate(input$rmd), quiet = TRUE))
  })
  
  # Limpiar el contenido del editor
  observeEvent(input$clear, {
    updateAceEditor(session,'rmd',value = '')
  })
  
  # Abrir un nuevo bloque de código en el editor
  observeEvent(input$open_chunk, {
    updateAceEditor(session,'rmd',value = paste(isolate(input$rmd),"\n```{r}\n\n```\n",sep = ''))
  })
  
  # Manipular los eventos de hotkeys
  observeEvent(input$rmd, {
    if (input$rmd_open_chunk == "openChunkKeyPressed") {
      updateAceEditor(session,'rmd',value = paste(isolate(input$rmd),"\n```{r}\n\n```\n",sep = ''))
    } else if (input$rmd_help_key == "helpMenuKeyPressed") {
      showModal(modalDialog(
        title = "Help Menu",
        h2("Hot-Keys"), # Título del menú de ayuda
        "Use the following hot-keys:", # Descripción de los hot-keys
        tags$ul(
          tags$li("Ctrl-Alt-I: Open Chunk"), # Hot-key para abrir un nuevo bloque de código
          tags$li("Ctrl-F: Search & Replace"), # Hot-key para buscar y reemplazar
          tags$li("F1: Help Menu"), # Hot-key para abrir el menú de ayuda
          tags$li("Ctrl-Z: Undo"), # Hot-key para deshacer la última acción
          tags$li("Ctrl-Y: Redo") # Hot-key para rehacer la última acción
        )
      ))
    }
  })
  
  # Descargar el código markdown
  output$save_code <- downloadHandler(
    filename = function() {
      paste("code-", Sys.Date(), ".Rmd", sep="")
    },
    content = function(file) {
      writeLines(input$rmd, file)
    }
  )
  
  # Guardar el archivo markdown convertido a HTML
  output$save_knit <- downloadHandler(
    filename = function() {
      paste("knit-", Sys.Date(), ".html", sep="")
    },
    content = function(file) {
      knit2html(text = input$rmd, output = file)
    }
  )
  
  # Alternar visibilidad del panel lateral
  observeEvent(input$toggleSidebar, {
    toggle("sidebar")
  })
  
  # Consola en vivo
  observeEvent(input$console, {
    shinyjs::html("console", input$console)
  })
  
})