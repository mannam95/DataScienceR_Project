#files and directory paths
csvLocation_train = "datasets/dataset_working/feature_extraction/train_data_custom.csv"
csvLocation_test = "datasets/dataset_working/feature_extraction/test_data_custom.csv"
output_Path1 = "datasets/dataset_working/model_results/model_eval_authors.csv"
output_Path2 = "datasets/dataset_working/model_results/model_eval_tweets.csv"
setwd('C:/Users/SrinathMannam/Desktop/Github/DataScienceR') # change path accordingly 

#import libraries
#install.packages("dplyr")
library(dplyr)
library(plyr)
library(readr)
#install.packages("caret")
#install.packages("stringi", type="binary")
library(caret)
library(ggplot2)
#install.packages("repr")
library(repr)
#install.packages("glmnet")
library(glmnet)
library(tidyverse)
source("code_Base/models/reuse_functions.R")

#Read the features extracted
features_Data_train <- read.csv(file = csvLocation_train)
features_Data_test <- read.csv(file = csvLocation_test)

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

data_train <- features_Data_train
x_train = as.matrix(data_train[!(names(data_train) %in% c('Author_Id', 'X', 'Target', 'Custom_Target'))])
y_train = data_train$Custom_Target
data_test <- features_Data_test
x_test = as.matrix(data_test[!(names(data_test) %in% c('Author_Id', 'X', 'Target', 'Custom_Target'))])
y_test = data_test$Custom_Target


#Logistic Regression
logisticModel <- glm(Custom_Target~., data=data_train[!(names(data_train) %in% c('Author_Id', 'X', 'Target'))], family = binomial)
probabilities <- logisticModel %>% predict(data_test[!(names(data_test) %in% c('Author_Id', 'X', 'Target', 'Custom_Target'))], type = "response")
predicted_df <- ifelse(probabilities >= 0.5, 1, 0)

eval_df_1 <- evaluation_Metric(y_test, predicted_df, "Logsitic Regression")
#write to a csv file
write_csv(rbind(curr_eval__tweets_df, eval_df_1), output_Path2)

eval_df_2 <- return_accuracy(predicted_df, "Logsitic Regression")
#write to a csv file
write_csv(rbind(curr_eval__authors_df, eval_df_2), output_Path1)


#LASSO
cv.lasso <- cv.glmnet(x_train, y_train, alpha = 1, family = "binomial")
lassoModel <- glmnet(x_train, y_train, alpha = 1, family = "binomial", lambda = cv.lasso$lambda.min)
lasso_probabilities <- lassoModel %>% predict(newx = x_test)
lasso_predicted_df <- ifelse(lasso_probabilities >= 0.5, 1, 0)

eval_df_3 <- evaluation_Metric(y_test, lasso_predicted_df, "LASSO")
#write to a csv file
write_csv(rbind(curr_eval__tweets_df, eval_df_1, eval_df_3), output_Path2)

eval_df_4 <- return_accuracy(lasso_predicted_df, "LASSO")
#write to a csv file
write_csv(rbind(curr_eval__authors_df, eval_df_2, eval_df_4), output_Path1)
