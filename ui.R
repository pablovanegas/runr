# ui.R
library(shinyAce)
library(shiny)
library(markdown)
library(knitr)
library(dplyr)
library(shinyjs)
library(shinythemes)  # Añade esta línea

shinyUI(
  fluidPage(
    useShinyjs(),  # Añade esta línea
    sidebarLayout(
      sidebarPanel(
        h2("Test"),
        h3("Aqui esta el sidebar"),
        actionButton("theme_button", "Elige un tema"),  # Añade esta línea
      ),
      mainPanel(
        h1("Shiny Ace knitr Example"),
        fluidRow(
          column(
            6,
            h2("Source R-Markdown"),
            verbatimTextOutput("log"),
            aceEditor("rmd", mode = "markdown", value = init,
                      hotkeys = list(
                        open_chunk = 'Ctrl-Alt-I',
                        help_key = "F1",
                        run_key = list(
                          win = "Ctrl-R|Ctrl-Shift-Enter",
                          mac = "CMD-ENTER|CMD-SHIFT-ENTER"
                        )
                      )),
            
            actionButton("eval", "Run", icon = icon('play')),
            actionButton('clear', 'Clear', icon = icon('eraser')),
            actionButton("open_chunk", "Insert Chunk", icon = icon('plus')),
          ),
          column(
            6,
            h2("Knitted Output"),
            htmlOutput("knitDoc")
          )
        )
      )
    ),
    # Añade este modal para el selector de temas
    shiny::modalDialog(
      shinythemes::themeSelector(),
      title = "Elige un tema",
      easyClose = TRUE,
      footer = NULL
    )
  )
)
