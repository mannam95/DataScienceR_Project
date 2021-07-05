library(shiny)
library(shinydashboard)



header <- dashboardHeader(
  title = "Simple tabs",
  tags$li(
    a(
      icon("sticky-note"),
      strong("Process Notebook"),
      height = 40,
      href = "https://github.com/anish-singh-07/DataScienceR",
      title = "",
      target = "_blank"
    ),
    class = "dropdown"
  ),
  tags$li(
    a(
      icon("github"),
      strong("About US"),
      height = 40,
      href = "https://github.com/anish-singh-07/DataScienceR",
      title = "",
      target = "_blank"
    ),
    class = "dropdown"
  )
)

sidebar <- dashboardSidebar(
  sidebarMenu(id = 'sidebarmenu',
              # Landing Page
              menuItem("Home", tabName = "landing", icon = icon("home")),
              
              # Related Work page
              menuItem('Related Work', tabName = "relatedWork", icon = icon('book-reader')),
              
              # Dataset Page
              menuItem('Dataset',
                       icon = icon('database'),
                       tabName = 'dataset'
              ),
              
              # Pre Processing Page
              menuItem('Pre Processing',
                       icon = icon('file-medical-alt'),
                       tabName = 'pre_process'
              ),
              
              # Exploratory Data Analysis Page
              menuItem('Exploratory Data Analysis',
                       icon = icon('diagnoses'),
                       tabName = 'edanalysis'
              ),
              
              # Feature Engineering Page
              menuItem('Feature Engineering',
                       icon = icon('jenkins'),
                       tabName = 'featureEng'
              ),
              
              # Models & Results Page
              menuItem('Models & Results',
                       icon = icon('battle-net'),
                       tabName = 'model_Results'
              ), 
              
              # References Page
              menuItem('References',
                       icon = icon('external-link-square-alt'),
                       tabName = 'references'
              )))

body <- dashboardBody(
  tags$script(HTML("$('body').addClass('fixed');")),
  tags$script(HTML("$('body').css('background-color','#ecf0f5');")),
  tabItems(
    tabItem("landing", includeHTML("rmdFiles/home/home.html")),
    tabItem("relatedWork", includeHTML("rmdFiles/related_work/related_work.html")),
    tabItem("dataset", includeHTML("rmdFiles/dataset/dataset.html")),
    tabItem("pre_process", includeHTML("rmdFiles/pre_processing/pre_processing.html")),
    tabItem("edanalysis", includeHTML("rmdFiles/exploratory/exploratory.html")),
    tabItem("featureEng", includeHTML("rmdFiles/feature_Engineering/feature_Engineering.html")),
    tabItem("model_Results", includeHTML("rmdFiles/models_Results/models_Results.html")),
    tabItem("references", includeHTML("rmdFiles/references/references.html"))
  )
)


ui <- tagList(
  
  tags$div(
    dashboardPage(
      header,
      sidebar,
      body
    )
  )
)

server <- shinyServer(function(input,output){})

shinyApp(ui, server)
