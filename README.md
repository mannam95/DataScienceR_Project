# Classifying whether twitter author spreads hate using supervised learning

## Online Setup

[https://srinath-m.shinyapps.io/shinyHost](https://srinath-m.shinyapps.io/shinyHost)

## Process Notebook

[https://mannam95.github.io/DataScienceR_Project/](https://mannam95.github.io/DataScienceR_Project/)

## Project screencast

[https://www.youtube.com/watch?v=_cLzOaIdFXE](https://www.youtube.com/watch?v=_cLzOaIdFXE)

## Offline Version
These instructions will get you a copy of this project running on your local machine for development and testing purposes

### Prerequisites

1. Access to the Twitter Dataset [Link](https://pan.webis.de/clef21/pan21-web/author-profiling.html)
2. [R](https://cran.rstudio.com/) (>=4.0.0)
3. [RStudio](https://www.rstudio.com/products/rstudio/download/) (>=1.4)
4. on Windows: [Rtools](https://cran.r-project.org/bin/windows/Rtools/)

### Installing

* Clone the repository or download and unzip it.    
* Make sure that all the files are present in following folder and in the following similar structure.  

```
DataScienceR(Parent Folder)
    code_Base  
            preprocessFiles
              read_data.R
              Text_preprocessing.R
            feature_Extraction
            exploratory_data_analysis
            models
    datasets  
            dataset_original
            dataset_working
    Plots
    process_Notebook
    project_Proposal
    README.md
```


### Further Instructions:
* Run the setup_Libraries.R file mentioned in the code_Base folder for installing all the packages.
* In order to be able to view only the report created by us, you can navigate to "process_Notebook" folder and run the "Process_notebook_dwr.Rmd" file to generate "Process_notebook_dwr.html" and open this html file in any browser(Chrome etc.) for viewing the report.
* Change the directory paths in all .R files accordingly.
* First run read_data.R file and Text_preprocessing in "preprocessFiles" folder.R respectively. All the xml files will be converted here. 
* Second run the Sentiments_Extract.R and followed by CombineFeatures.R in feature_Extraction folder. All the features will be extracted and combined together
* For data visualization run files in the exploratory data analysis folder.
* Models can be trained in the "models" folder.

### Contributors
* **Anish Singh**
* **Priyanka Singh**
* **Ramanpreet Kaur**
* **Srinath Mannam**
