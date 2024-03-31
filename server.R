# server.R
library(shiny)
library(shinythemes)  # Asegúrate de tener esta línea

renderLogEntry <- function(entry){
  paste0(entry, " - ", date())
}

shinyServer(function(input, output, session) {
  
  observeEvent(input$theme_button, {
    showModal(modalDialog(
      title = "Elige un tema",
      shinythemes::themeSelector()
    ))
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
  vals <- reactiveValues(log = "")
  observeEvent(input$rmd_run_key, {
    vals$log <- paste(vals$log, renderLogEntry("Run Key"), sep = "\n")
  })
  
  observeEvent(input$rmd_run_key, {
    js$triggerEval()
  })
  
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
})
