#files and directory paths
csvLocation_train = "datasets/dataset_working/feature_extraction/train_data_custom.csv"
csvLocation_test = "datasets/dataset_working/feature_extraction/test_data_custom.csv"
output_Path1 = "datasets/dataset_working/model_results/model_eval_authors.csv"
output_Path2 = "datasets/dataset_working/model_results/model_eval_tweets.csv"
setwd('C:/Users/SrinathMannam/Desktop/Github/DataScienceR') # change path accordingly 

#import libraries
#install.packages("tree")
require(tree)
#install.packages("dplyr")
library(dplyr)
library(caret)
library(tidyverse)
#install.packages("rpart.plot")
library(rpart)
library(rpart.plot)
source("code_Base/models/reuse_functions.R")

#Read the features extracted
features_Data_train <- read.csv(file = csvLocation_train)
features_Data_test <- read.csv(file = csvLocation_test)

data_train <- features_Data_train
data_test <- features_Data_test

#model fitting
fit <- rpart(Custom_Target~., data = data_train[!(names(data_train) %in% c('Author_Id', 'X', 'Target'))], method = 'class')
rpart.plot(fit, extra = 106)

pred_test <- predict(fit, data_test[!(names(data_test) %in% c('Author_Id', 'X', 'Target'))], type = 'class')

#print(paste('Confusion Matrix based on all tweet level by Decision Tree Model'))
eval_df <- evaluation_Metric(features_Data_test$Custom_Target, pred_test, "Decision Tree")
#write to a csv file
write_csv(eval_df, output_Path2)

eval_df <- return_accuracy(pred_test, "Decision Tree:")
#write to a csv file
write_csv(eval_df, output_Path1)