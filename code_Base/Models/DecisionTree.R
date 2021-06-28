#files and directory paths
csvLocation_train = "datasets/dataset_working/feature_extraction/train_data.csv"
csvLocation_test = "datasets/dataset_working/feature_extraction/test_data.csv"
setwd('D:/HP_Win10_OneDrive/Study/OVGU/University/Summer-2021/DSR/Github/DataScienceR') # change path accordingly 

#import libraries
#install.packages("tree")
require(tree)
library(dplyr)

#Read the features extracted
features_Data_train <- read.csv(file = csvLocation_train)
features_Data_test <- read.csv(file = csvLocation_test)

#A function that will return the test, train data
create_train_test <- function(data, size, train = TRUE) {
  n_row = nrow(data)
  total_row = size * n_row
  train_sample <- 1: total_row
  if (train == TRUE) {
    return (data[train_sample, ])
  } else {
    return (data[-train_sample, ])
  }
}

#data_train <- create_train_test(features_Data_train, 0.6, train = TRUE)
#data_test <- create_train_test(features_Data_train, 0.4, train = FALSE)
data_train <- features_Data_train
data_test <- features_Data_test

#prop.table(table(data_train$Target))
#prop.table(table(data_test$Target))

#install.packages("rpart.plot")
library(rpart)
library(rpart.plot)
fit <- rpart(Target~., data = data_train, method = 'class')
rpart.plot(fit, extra = 106)


accuracy_tune <- function(fit) {
  predict_unseen <- predict(fit, data_test, type = 'class')
  table_mat <- table(data_test$Target, predict_unseen)
  accuracy_Test <- sum(diag(table_mat)) / sum(table_mat)
  print(paste('Accuracy for test', accuracy_Test))
}

control <- rpart.control(minsplit = 6,
                         minbucket = round(5 / 3),
                         maxdepth = 30,
                         cp = 0)
tune_fit <- rpart(Target~., data = data_train, method = 'class', control = control)


accuracy_tune(fit)
accuracy_tune(tune_fit)