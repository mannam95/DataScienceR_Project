#------ truth file 
setwd('/Users/ramancheema/Documents/Data Sci R - Project') # change path accordinly 
truth<-read.table("data/training/truth.txt", header = FALSE, sep = ":") # target file 
truth<- truth[ -c(2:3) ] # removing symbols ':::' ,as these are extra columns 
colnames(truth)<-c('id','target') # naming columns as id and target 
truth<-truth[order(truth$id),] # sorting the ids 

# ----- tweets 

#install.packages('xml2')
library(xml2)
setwd("/Users/ramancheema/Documents/Data Sci R - Project/data/training/en") #change path accordinly 
#create a list of the files from your target directory
file_list <- list.files(pattern="*.xml", full.names=FALSE)

dataset <- data.frame()

for (i in 1:length(file_list)){
  temp_data <- read_xml(file_list[i]) #each file will be read in, 
  temp<-xml_text(xml_find_all(temp_data, "//document"))
  dataset <- rbind(dataset, temp) #for each iteration, bind the new data to the building dataset
}

# remove extra .xml written to id column , making of id same as of truth table '(for joining)
library(stringr)
id<-str_replace(file_list, ".xml$", '')

#bind target and instances 
dataset<-cbind(id,dataset)

# naming all columns of dataset 
colnames(dataset)[1]<-'id'
col_names<-paste0(c("tweet"),1:100)
colnames(dataset)[2:101]<-col_names
dataset<-dataset[order(dataset$id),]

# Joining truth with instances 
library(dplyr)
data<-inner_join(truth,dataset)
#write_csv(dataset,'tweets.csv')
#write_csv(truth,'target.csv')
library(readr)
write_csv(data,'dataset.csv')

