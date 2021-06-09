#directory paths paths
dataset_path = "dataset_original/training/"
truth_txt_path = "dataset_original/training/truth.txt"
en_train_path = "dataset_original/training/en/"
output_dir_path_pre1 = "dataset_working/pre_processed_files/"
setwd('D:/HP_Win10_OneDrive/Study/OVGU/University/Summer-2021/DSR/Github/DataSciR') # change path accordingly 


#------ truth file 
truth<-read.table(truth_txt_path, header = FALSE, sep = ":") # target file 
truth<- truth[ -c(2:3) ] # removing symbols ':::' ,as these are extra columns 
colnames(truth)<-c('id','target') # naming columns as id and target 
truth<-truth[order(truth$id),] # sorting the ids

# ----- tweets 

#install.packages('xml2')
library(xml2)
#create a list of the files from your target directory
file_list <- list.files(path=en_train_path, pattern="*.xml", full.names=FALSE)

dataset <- data.frame()

for (i in 1:length(file_list)){
  temp_data <- read_xml(paste(en_train_path, file_list[i], sep="")) #each file will be read in, 
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
write_csv(data, paste(output_dir_path_pre1, "dataset_pre1.csv", sep = ""))

