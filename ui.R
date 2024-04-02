# ui.R
library(shinyAce)
library(shiny)
library(markdown)
library(knitr)
library(dplyr)
library(shinyjs)
library(shinythemes)  
# Design 1 
shinyUI(
  fluidPage(
    useShinyjs(),  
    div(id = "sidebar",
        sidebarPanel(
          h2("Opciones"),
          actionButton("theme_button", "Elige un tema"),  
          selectInput('theme_code', 'Tema editor', choices = themes, selected = 'ambiance'),
          downloadButton('save_code', 'Guardar codigo', icon = icon('save')),
          downloadButton('save_knit', 'Guardar knitr', icon = icon('save')),
        )
    ),
    mainPanel(
      actionButton("toggleSidebar", "Opciones"),
      h1("Shiny Ace knitr Example"),
      fluidRow(
        column(
          12,
          h2("Source R-Markdown"),
          verbatimTextOutput("log"),
          aceEditor("rmd", mode = "markdown", value = init,
                    hotkeys = list(
                      open_chunk = 'Ctrl-Alt-I',
                      save_code = "Ctrl-S",
                      help_key = "F1"
                    ),
                    autoComplete = "live",
                    ),
          
          actionButton("eval", "Run", icon = icon('play')),
          actionButton('clear', 'Clear', icon = icon('eraser')),
          actionButton("open_chunk", "Insert Chunk", icon = icon('plus')),
        ),
        column(
          12,
          h1("Output"),
          htmlOutput("knitDoc")
        )
      )
    )
  )
)
