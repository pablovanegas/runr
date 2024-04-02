library(shiny)
library(shinythemes)
library(shinyWidgets)
library(shinydashboard)

## Dashboard

ui <- fluidPage(
  titlePanel("Mi App Shiny"),
  theme = shinytheme("flatly"),
  shinydashboard::dashboardPage(
    header = dashboardHeader(title = "Dashboard Example"),
    sidebar = dashboardSidebar(
      sidebarMenu(
        id = "tabs",
        menuItem("Help", tabName = "help", icon = icon("question")),
        menuItem("Themes", tabName = "themes", icon = icon("paint-brush"),
                 menuSubItem("Application Theme", tabName = "application_theme"),
                 menuSubItem("Editor Theme", tabName = "editor_theme")),
        menuItem("Save", icon = icon("th"), tabName = "save",
                 menuSubItem("Save rmd", tabName = "save_rmd"),
                 menuSubItem("Save knitr", tabName = "save_knirt")),
        menuItem("About", icon = icon("bar-chart-o"), tabName = "about",
                 menuSubItem("Support:", tabName = "support"),
                 menuSubItem("Source Code", tabName = "source_code"))
      )
    ),
    body = dashboardBody(
      tabItems(
        tabItem("save_rmd",
                fluidPage(
                  titlePanel("Guardar Código RMD"),
                  h2("Opciones"),
                  actionButton("theme_button", "Elige un tema"),
                  selectInput('theme_code', 'Tema editor', choices = themes, selected = 'ambiance'),
                  downloadButton('save_code', 'Guardar código', icon = icon('save'))
                )
        ),
        tabItem("save_knirt",
                fluidPage(
                  titlePanel("Guardar Documento Knitr"),
                  h2("Archivo Markdown"),
                  verbatimTextOutput("log"),
                  aceEditor("rmd", mode = "markdown", value = NULL,
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
        tabItem("application_theme",
                fluidPage(
                  titlePanel("Tema de Aplicación"),
                  h2("Selecciona un tema"),
                  actionButton("change_theme", "Cambiar Temática")
                )
        ),
        tabItem("editor_theme",
                fluidPage(
                  titlePanel("Tema Editor"),
                  h2("Selecciona un tema"),
                  selectInput('theme_code', 'Tema editor', choices = themes, selected = 'ambiance')
                )
        )
      ),
      bookmarkButton()
    )
  )
)