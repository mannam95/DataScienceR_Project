#files and directory paths
csvLocation_train = "datasets/dataset_working/feature_extraction/train_data_custom.csv"
csvLocation_test = "datasets/dataset_working/feature_extraction/test_data_custom.csv"
output_Path1 = "datasets/dataset_working/model_results/model_eval_authors.csv"
output_Path2 = "datasets/dataset_working/model_results/model_eval_tweets.csv"
setwd('C:/Users/SrinathMannam/Desktop/Github/DataScienceR') # change path accordingly 

#install.packages("naivebayes")
library(naivebayes)
library(dplyr)
#install.packages("e1071")
library(e1071)
library(rpart)
library(tidyverse)
source("code_Base/models/reuse_functions.R")

#Read the old evaluation metrics
if(file.exists(output_Path1)){
  curr_eval__authors_df <- read.csv(file = output_Path1)
} else {
  curr_eval__authors_df <- data.frame(matrix(ncol=5,nrow=0, dimnames=list(NULL, c("Model", "Accuracy", "Precision", "Recall", "F1_Score"))))
}
if(file.exists(output_Path2)){
  curr_eval__tweets_df <- read.csv(file = output_Path2)
} else {
  curr_eval__tweets_df <- data.frame(matrix(ncol=5,nrow=0, dimnames=list(NULL, c("Model", "Accuracy", "Precision", "Recall", "F1_Score"))))
}

#Read the features extracted
features_Data_train <- read.csv(file = csvLocation_train)
features_Data_test <- read.csv(file = csvLocation_test)

data_train <- features_Data_train
data_test <- features_Data_test


#Naive Bayes Model
nb_model <- naiveBayes(Custom_Target~., data=data_train[!(names(data_train) %in% c('Author_Id', 'X', 'Target'))])
nb_model_pred <- predict(nb_model, data_test[!(names(data_test) %in% c('Author_Id', 'X', 'Target'))], type="class")
table_mat <- table(nb_model_pred, data_test$Custom_Target,dnn=c("Prediction","Actual"))
accuracy_Test <- sum(diag(table_mat)) / sum(table_mat)

eval_df <- evaluation_Metric(features_Data_test$Custom_Target, nb_model_pred, "Naive Bayes")
#write to a csv file
write_csv(rbind(curr_eval__tweets_df, eval_df), output_Path2)

eval_df <- return_accuracy(nb_model_pred, "Naive Bayes")
#write to a csv file
write_csv(rbind(curr_eval__authors_df, eval_df), output_Path1)