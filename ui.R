library(shinyAce)
library(shiny)
library(markdown)
library(knitr)
library(dplyr)
library(shinyjs)  # Añade esta línea

shinyUI(
  fluidPage(
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
)
