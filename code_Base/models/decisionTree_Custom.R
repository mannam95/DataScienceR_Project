#files and directory paths
csvLocation_train = "datasets/dataset_working/feature_extraction/train_data_custom.csv"
csvLocation_test = "datasets/dataset_working/feature_extraction/test_data_custom.csv"
setwd('C:/Users/SrinathMannam/Desktop/Github/DataScienceR') # change path accordingly 

#import libraries
#install.packages("tree")
require(tree)
#install.packages("dplyr")
library(dplyr)

#Read the features extracted
features_Data_train <- read.csv(file = csvLocation_train)
features_Data_test <- read.csv(file = csvLocation_test)

data_train <- features_Data_train
data_test <- features_Data_test


#install.packages("rpart.plot")
library(rpart)
library(rpart.plot)

#model fitting
fit <- rpart(Custom_Target~., data = data_train[!(names(data_test) %in% c('Author_Id', 'X', 'Target'))], method = 'class')
rpart.plot(fit, extra = 106)

pred_test <- predict(fit, data_test[!(names(data_test) %in% c('Author_Id', 'X', 'Target'))], type = 'class')
table_mat <- table(features_Data_test$Custom_Target, pred_test)
accuracy_Test <- sum(diag(table_mat)) / sum(table_mat)


#a function that will print the accuracy by comparing authors
return_accuracy <- function(predicted_data) {
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
  print(paste('Accuracy based on authors', accuracy_Test))
}

print(paste('Accuracy based on all tweets:', accuracy_Test))
return_accuracy(pred_test)