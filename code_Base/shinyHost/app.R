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
    tabItem("landing", htmlOutput("homeHtml")),
    tabItem("relatedWork", htmlOutput("relatedWorkHtml")),
    tabItem("dataset", htmlOutput("datasetHtml")),
    tabItem("pre_process", htmlOutput("preProcessingHtml")),
    tabItem("edanalysis", htmlOutput("exploratoryHtml")),
    tabItem("featureEng", htmlOutput("featureEngineeringHtml")),
    tabItem("model_Results", htmlOutput("modelsResultsHtml")),
    tabItem("references", htmlOutput("referencesHtml"))
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
  output$referencesHtml<-renderUI({getReferencesHtml()})
})

shinyApp(ui, server)
