library(shiny)
library(shinythemes)
library(shinyWidgets)
library(shinydashboard)

ui <- fluidPage(
  titlePanel("Mi App Shiny"),
  theme = shinytheme("flatly"),
  shinydashboard::dashboardPage(
    header = dashboardHeader(title = "Opciones"),
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
        menuItem("About", tabName = "about",
                 menuSubItem("Support:", tabName = "support"),
                 menuSubItem("Source Code", tabName = "source_code"))
      )
    ),
    body = dashboardBody(
      mainPanel(
        h1("Shiny Ace knitr Example"),
        fluidRow(
          column(
            12,
            h2("Source R-Markdown"),
            verbatimTextOutput("log"),
            aceEditor("rmd", mode = "markdown",value = init, 
                      hotkeys = list(
                        open_chunk = 'Ctrl-Alt-I',
                        save_code = 'Ctrl-S',
                        help_key = 'F1'
                      ),
                      autoComplete = "live")
          ),
          column(
            12,
            h1("Output"),
            htmlOutput("knitDoc")
          )
        )
      )
    )
  , skin  = "black")
)