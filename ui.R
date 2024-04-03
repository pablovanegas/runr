# ui.R
shinyUI(
  tagList(
    tags$div(
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
          tags$div(
            class = "row",
            tags$div(
              class = "col-md-12", # Cuadrado 1
              h2("Source R-Markdown"),
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
              h1("Knirt Completo"),
              htmlOutput("knitDoc")
            )
          )
        )
      )
    )
  )
)
