#directory paths paths
dataset_path_train = "datasets/dataset_original/training/"
truth_txt_path = "datasets/dataset_original/training/truth.txt"
en_train_path = "datasets/dataset_original/training/en/"
dataset_path_test = "datasets/dataset_original/test/"
test_txt_path = "datasets/dataset_original/test/en.txt"
en_test_path = "datasets/dataset_original/test/en/"
output_dir_path_pre = "datasets/dataset_working/pre_processed_files/"
setwd('D:/HP_Win10_OneDrive/Study/OVGU/University/Summer-2021/DSR/Github/DataScienceR') # change path accordingly 

#import libraries
library(dplyr)
#install.packages('xml2')
library(xml2)
library(stringr)

#------ training truth file 
train_truth<-read.table(truth_txt_path, header = FALSE, sep = ":") # target file 
train_truth<- train_truth[ -c(2:3) ] # removing symbols ':::' ,as these are extra columns 
colnames(train_truth)<-c('id','target') # naming columns as id and target 
train_truth<-train_truth[order(train_truth$id),] # sorting the ids 

#------ test truth file 
test_truth<-read.table(test_txt_path, header = FALSE, sep = ":") # target file 
test_truth<- test_truth[ -c(2:3) ] # removing symbols ':::' ,as these are extra columns 
colnames(test_truth)<-c('id','target') # naming columns as id and target 
test_truth<-test_truth[order(test_truth$id),] # sorting the ids 



#create a list of the files from your target directory
train_file_list <- list.files(path=en_train_path, pattern="*.xml", full.names=FALSE)
test_file_list <- list.files(path=en_test_path, pattern="*.xml", full.names=FALSE)

train_dataset <- data.frame()
test_dataset <- data.frame()

#Training
for (i in 1:length(train_file_list)){
  temp_data <- read_xml(paste(en_train_path, train_file_list[i], sep="")) #each file will be read in, 
  temp<-xml_text(xml_find_all(temp_data, "//document"))
  train_dataset <- rbind(train_dataset, temp) #for each iteration, bind the new data to the building dataset
}

#Testing
for (i in 1:length(test_file_list)){
  temp_data <- read_xml(paste(en_test_path, test_file_list[i], sep="")) #each file will be read in, 
  temp<-xml_text(xml_find_all(temp_data, "//document"))
  test_dataset <- rbind(test_dataset, temp) #for each iteration, bind the new data to the building dataset
}

# remove extra .xml written to id column , making of id same as of truth table '(for joining)
train_id<-str_replace(train_file_list, ".xml$", '')
test_id<-str_replace(test_file_list, ".xml$", '')

#bind target and instances 
train_dataset<-cbind(train_id,train_dataset)
test_dataset<-cbind(test_id,test_dataset)

# naming all columns of dataset 
#train dataset
colnames(train_dataset)[1]<-'id'
col_names<-paste0(c("tweet"),1:100)
colnames(train_dataset)[2:101]<-col_names
train_dataset<-train_dataset[order(train_dataset$id),]

#test dataset
colnames(test_dataset)[1]<-'id'
col_names<-paste0(c("tweet"),1:100)
colnames(test_dataset)[2:101]<-col_names
test_dataset<-test_dataset[order(test_dataset$id),]

# Joining truth with instances 
train_data<-inner_join(train_truth,train_dataset)
test_data<-inner_join(test_truth,test_dataset)
#write_csv(dataset,'tweets.csv')
#write_csv(truth,'target.csv')
library(readr)
write_csv(train_data, paste(output_dir_path_pre, "train_dataset_pre1.csv", sep = ""))
write_csv(test_data, paste(output_dir_path_pre, "test_dataset_pre1.csv", sep = ""))

