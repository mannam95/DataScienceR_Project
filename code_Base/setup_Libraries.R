requiredPackages <- c(
  "tidyverse",
  "ROCR",           
  "PRROC",          
  "treemapify",     
  "plotly",         
  "syuzhet",        
  "tm",             
  "NLP",           
  "rpart.plot",     
  "rpart",          
  "forcats",        
  "stringr",        
  "purrr",          
  "readr",          
  "tidyr",          
  "tibble",         
  "tidyverse",      
  "caret",          
  "ggplot2",        
  "lattice",        
  "dplyr",          
  "tree",          
  "shinyjs",        
  "shinythemes",    
  "dashboardthemes",
  "rmarkdown",      
  "shinydashboard", 
  "shiny",          
  "here",           
  "stats",          
  "graphics",       
  "grDevices",      
  "utils",          
  "datasets",       
  "methods",        
  "base" 
)

checkPackages <- function(RequiredPackages) {
  missingPackages <- RequiredPackages[!(RequiredPackages %in% installed.packages()[, "Package"])]
  if (length(missingPackages))
    install.packages(missingPackages, dependencies = TRUE)
  sapply(RequiredPackages, library, character.only = TRUE)
}

checkPackages(requiredPackages)