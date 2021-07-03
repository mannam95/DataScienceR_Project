#files and directory paths
csvLocation_train = "datasets/dataset_working/feature_extraction/train_data_custom.csv"
csvLocation_test = "datasets/dataset_working/feature_extraction/test_data_custom.csv"
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

#Read the features extracted
features_Data_train <- read.csv(file = csvLocation_train)
features_Data_test <- read.csv(file = csvLocation_test)

data_train <- features_Data_train
x_train = as.matrix(data_train[!(names(data_train) %in% c('Author_Id', 'X', 'Target', 'Custom_Target'))])
y_train = data_train$Custom_Target
data_test <- features_Data_test
x_test = as.matrix(data_test[!(names(data_test) %in% c('Author_Id', 'X', 'Target', 'Custom_Target'))])
y_test = data_test$Custom_Target

#a function that will print the accuracy by comparing authors
return_accuracy <- function(predicted_data, modelName) {
  predicted_Target_df <- data.frame(matrix(ncol=1,nrow=0, dimnames=list(NULL, c("Predicted_Target"))))
  
  #loop over through he predicted targets
  for ( currVal in predicted_data){
    predicted_Target_df[nrow(predicted_Target_df) + 1,] = c(currVal)
  }
  
  model_results_df <- data.frame(matrix(ncol=3,nrow=0, dimnames=list(NULL, c("Author_Id", "Original", "Predicted"))))
  
  countZeros = 0
  countOnes = 0
  #loop over and get original, predicted authors targets
  for (row in 1:nrow(predicted_Target_df)) {
    
    if(predicted_Target_df[row, c(1)] == 0){
      countZeros = countZeros + 1
    } else {
      countOnes = countOnes + 1
    }
    
    if(row+1 == nrow(data_test)){
      
    } else if(row == nrow(data_test)){
      model_results_df[nrow(model_results_df) + 1,] = c(nrow(model_results_df) + 1, data_test[row, c(37)], if(countOnes >= countZeros) 1 else 0)
      countZeros = 0
      countOnes = 0
    } else {
      if(data_test[row, c(2)] != data_test[row+1, c(2)]){
        model_results_df[nrow(model_results_df) + 1,] = c(nrow(model_results_df) + 1, data_test[row, c(37)], if(countOnes >= countZeros) 1 else 0)
        countZeros = 0
        countOnes = 0
      }
    }
  }
  
  table_mat <- table(model_results_df$Original, model_results_df$Predicted)
  accuracy_Test <- sum(diag(table_mat)) / sum(table_mat)
  print(paste('Confusion Matrix based on authors for ', modelName, " Model: "))
  confusionMatrix(table(model_results_df$Predicted, model_results_df$Original))
}

#Logistic Regression
logisticModel <- glm(Custom_Target~., data=data_train[!(names(data_train) %in% c('Author_Id', 'X', 'Target'))], family = binomial)
probabilities <- logisticModel %>% predict(data_test[!(names(data_test) %in% c('Author_Id', 'X', 'Target', 'Custom_Target'))], type = "response")
predicted_df <- ifelse(probabilities >= 0.5, 1, 0)
print(paste('Confusion Matrix based on all tweet level by Logistic Regression Model: ' ))
confusionMatrix(table(predicted_df, y_test))
return_accuracy(predicted_df, "Logsitic Regression")

#LASSO
cv.lasso <- cv.glmnet(x_train, y_train, alpha = 1, family = "binomial")
lassoModel <- glmnet(x_train, y_train, alpha = 1, family = "binomial", lambda = cv.lasso$lambda.min)
lasso_probabilities <- lassoModel %>% predict(newx = x_test)
lasso_predicted_df <- ifelse(lasso_probabilities >= 0.5, 1, 0)
print(paste('Confusion Matrix based on all tweet level by LASSO Model: '))
confusionMatrix(table(lasso_predicted_df, y_test))
return_accuracy(lasso_predicted_df, "LASSO")
