#a function that will return the evaluation metric
evaluation_Metric <- function(target, predicted, modelName) {
  conf_matrix <- as.matrix(table(Actual = target, Predicted = predicted))
  TP = conf_matrix[4]
  TN = conf_matrix[1]
  FP = conf_matrix[3]
  FN = conf_matrix[2]
  
  
  accuracy = (TP + TN)/(TP + TN + FP +FN)
  precision = TP/(TP + FP)
  recall = TP/(TP + FN)
  f1 = 2 * ((precision * recall) / (precision + recall))
  
  model_eval_df <- data.frame(matrix(ncol=5,nrow=0, dimnames=list(NULL, c("Model", "Accuracy", "Precision", "Recall", "F1_Score"))))
  model_eval_df[nrow(model_eval_df) + 1,] = c(modelName, round(accuracy, 2), round(precision, 2), round(recall, 2), round(f1, 2))
  
  return(model_eval_df)
}


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
  
  #print(paste('Confusion Matrix based on authors for ', modelName, " Model: "))
  eval_df <- evaluation_Metric(model_results_df$Original, model_results_df$Predicted, modelName)
  return(eval_df)
}