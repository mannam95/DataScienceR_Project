# Classifying whether twitter author spreads hate using supervised learning

## Online usage will not work as of now, since the application is not hosted, Please test only for offline

## Getting Started
These instructions will get you a copy of this project running on your local machine for development and testing purposes

### Prerequisites

* In order to run the project first r studio needs to be installed

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
    project_Proposal
    README.md
```


### Offline Usage:
* Change the directory paths in all .R files accordingly.
* First run read_data.R file and Text_preprocessing in "preprocessFiles" folder.R respectively. All the xml files will be converted here. 
* Second run the Sentiments_Extract.R and followed by CombineFeatures.R in feature_Extraction folder. All the features will be extracted and combined together
* FOr data visualization run files in the exploratory data analysis folder.
* Models can be trained in the "models" folder.

### Contributors
* **Anish Singh**
* **Priyanka Singh**
* **Ramanpreet Kaur**
* **Srinath Mannam**
