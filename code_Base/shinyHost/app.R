library(shiny)
library(shinydashboard)
library(shinythemes)
library(dashboardthemes)



header <- dashboardHeader(
  title =  shinyDashboardLogo(
    theme = "purple_gradient",
    boldText = "Classifying whether twitter author spreads hate using supervised learning",
    mainText = "",
    badgeText = "R Studio"
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
              
              # Conclusion Page
              menuItem('Conclusion',
                       icon = icon('bars'),
                       tabName = 'conclusion'
              ),
              
              # References Page
              menuItem('References',
                       icon = icon('external-link-square-alt'),
                       tabName = 'references'
              ),
              
              #Process Notebook Link
              tags$li(
                a(
                  icon("sticky-note"),
                  strong("Process Notebook"),
                  height = 40,
                  href = "https://github.com/anish-singh-07/DataScienceR/tree/main/process_Notebook",
                  title = "",
                  target = "_blank"
                ),
                class = "dropdown"
              ),
              
              #Github Link
              tags$li(
                a(
                  icon("github"),
                  strong("Git Repository"),
                  height = 40,
                  href = "https://github.com/anish-singh-07/DataScienceR",
                  title = "",
                  target = "_blank"
                ),
                class = "dropdown"
              )))

body <- dashboardBody(
  tags$script(HTML("$('body').addClass('fixed');")),
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
  ),
  tabItems(
    tabItem("landing", htmlOutput("homeHtml")),
    tabItem("relatedWork", htmlOutput("relatedWorkHtml")),
    tabItem("dataset", htmlOutput("datasetHtml")),
    tabItem("pre_process", htmlOutput("preProcessingHtml")),
    tabItem("edanalysis", htmlOutput("exploratoryHtml")),
    tabItem("featureEng", htmlOutput("featureEngineeringHtml")),
    tabItem("model_Results", htmlOutput("modelsResultsHtml")),
    tabItem("conclusion", htmlOutput("conclusionHtml")),
    tabItem("references", htmlOutput("referencesHtml"))
  )
)


ui <- tagList(
  
  tags$div(
    dashboardPage(
      header,
      title = "Classifying whether twitter author spreads hate using supervised learning",
      sidebar,
      body
    )
  )
)

server <- shinyServer(function(input,output){
  
  getHomeHtml <- function(){
    return(includeHTML("rmdFiles/home/home.html"))
  }
  
  getRelated_WorkHtml <- function(){
    return(includeHTML("rmdFiles/related_work/related_work.html"))
  }
  
  getDatasetHtml <- function(){
    return(includeHTML("rmdFiles/dataset/dataset.html"))
  }
  
  getPre_ProcessingHtml <- function(){
    return(includeHTML("rmdFiles/pre_processing/pre_processing.html"))
  }
  getExploratoryHtml <- function(){
    return(includeHTML("rmdFiles/exploratory/exploratory.html"))
  }
  
  getFeature_EngineeringHtml <- function(){
    return(includeHTML("rmdFiles/feature_Engineering/feature_Engineering.html"))
  }
  
  getModels_ResultsHtml <- function(){
    return(includeHTML("rmdFiles/models_Results/models_Results.html"))
  }
  
  getConclusionHtml <- function(){
    return(includeHTML("rmdFiles/conclusion/conclusion.html"))
  }
  
  
  getReferencesHtml <- function(){
    return(includeHTML("rmdFiles/references/references.html"))
  }
  
  output$homeHtml<-renderUI({getHomeHtml()})
  output$relatedWorkHtml<-renderUI({getRelated_WorkHtml()})
  output$datasetHtml<-renderUI({getDatasetHtml()})
  output$preProcessingHtml<-renderUI({getPre_ProcessingHtml()})
  output$exploratoryHtml<-renderUI({getExploratoryHtml()})
  output$featureEngineeringHtml<-renderUI({getFeature_EngineeringHtml()})
  output$modelsResultsHtml<-renderUI({getModels_ResultsHtml()})
  output$conclusionHtml<-renderUI({getConclusionHtml()})
  output$referencesHtml<-renderUI({getReferencesHtml()})
  

})

shinyApp(ui, server)
