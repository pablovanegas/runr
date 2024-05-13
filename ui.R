library(shiny)
library(shinyAce)
library(shinyjs)
library(shinythemes)
# ui.R
#Design 1:
ui <- shinyUI(
  tagList(
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "styles.css"),
      tags$script(src = "script.js")
    ),
    tags$div(
      fluidPage(
        useShinyjs(),  
        div(id = "sidebar",
            sidebarPanel(
              h2("Opciones"),
              actionButton("theme_button", "Elige un tema"),  
              selectInput('theme_code', 'Tema editor', choices = getAceThemes(), selected = 'ambiance'),
              downloadButton('save_code', 'Guardar codigo', icon = icon('save')),
              downloadButton('save_knit', 'Guardar knitr', icon = icon('save')),
              tags$a(href = "https://github.com/pablovanegas/runr", target = "_blank", class = "btn btn-default shiny-bound-input", "Ver Código Fuente"),
              tags$a(href = "https://github.com/pablovanegas/runr", target = "_blank", class = "btn btn-default shiny-bound-input", "YALM generator") )
        ),#
        mainPanel(
          actionButton("toggleSidebar", "Opciones"),
          h1("Simple R"),
          tags$div(
            class = "row",
            tags$div(
              class = "col-md-12", # Cuadrado 1
              h2("Tu codigo: "),
              verbatimTextOutput("log"),
              aceEditor("rmd", mode = "markdown", value = init,
                        hotkeys = list(
                          open_chunk = 'Ctrl-Alt-I',
                          save_code = "Ctrl-S",
                          help_key = "F1"
                        ),
                        autoComplete = "live"),
              actionButton("eval", "Run", icon = icon('play')),
              actionButton('clear', 'Clear', icon = icon('eraser')),
              actionButton("open_chunk", "Insert Chunk", icon = icon('plus'))
            )
          ),
          tags$div(
            class = "row",
            tags$div(
              class = "col-md-12", # Cuadrado 2
              h1("Resultado: "),
              htmlOutput("knitDoc")
            )
          )
        )
      )
    )
  )
)
