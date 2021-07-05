#files and directory paths
setwd('C:/Users/SrinathMannam/Desktop/Github/DataScienceR') # change path accordingly 
preprocessed_data<- read.csv("datasets/dataset_working/pre_processed_files/pre_processed.csv")
preprocessed_data_test<- read.csv("datasets/dataset_working/pre_processed_files/pre_processed_test_data_cols.csv")
output_Path1 = "datasets/dataset_working/model_results/model_eval_authors.csv"

#import libraries
library(tidyverse)
library(stringr)
library(tidytext)
library(SnowballC)
library(quanteda)
library(dplyr)
source("code_Base/models/reuse_functions.R")

#Read the old evaluation metrics
if(file.exists(output_Path1)){
  curr_eval__authors_df <- read.csv(file = output_Path1)
} else {
  curr_eval__authors_df <- data.frame(matrix(ncol=5,nrow=0, dimnames=list(NULL, c("Model", "Accuracy", "Precision", "Recall", "F1_Score"))))
}


tweet <- preprocessed_data %>% # for tf-idf 
  unite("tweets", tweet1:tweet100)%>%select(-target)
tweet_test <- preprocessed_data_test %>% # for tf-idf 
  unite("tweets", tweet1:tweet100)%>%select(-target)

#-----TF-IDF for training
tf_idf<- tweet%>%
  unnest_tokens(word, tweets) %>%
  anti_join(get_stopwords(), by = "word") %>%
  mutate(stem = wordStem(word)) %>%
  dplyr::count(id, stem) %>%
  bind_tf_idf(stem, id, n) %>%
  cast_dfm(id, stem, tf_idf)
tf_idF_matrix <- as.matrix(tf_idf)
tf_idF_DF <- cbind(Label = preprocessed_data$target, data.frame(tf_idF_matrix))

#-----TF-IDF for Test Data
tf_idf_test<- tweet_test %>%
  unnest_tokens(word, tweets) %>%
  anti_join(get_stopwords(), by = "word") %>%
  mutate(stem = wordStem(word)) %>%
  dplyr::count(id, stem) %>%
  bind_tf_idf(stem, id, n) %>%
  cast_dfm(id, stem,tf_idf)
tf_idF_matrix_test <- as.matrix(tf_idf_test)
tf_idF_DF_test <- cbind(Label = preprocessed_data_test$target, data.frame(tf_idF_matrix_test))

##Classifier training using naive bayes

classifier <- e1071::naiveBayes(
  as.matrix(tf_idF_DF[,3:ncol(tf_idF_DF)]),
  tf_idF_DF$Label,
  laplace = 0.5) 


#########Predicting on test data########

test_predicted <- 
  predict(classifier,
          as.matrix(tf_idF_DF_test[,3:ncol(tf_idF_DF_test)]))

#caret::confusionMatrix(table(test_predicted, tf_idF_DF_test$Label)) 

eval_df <- evaluation_Metric(tf_idF_DF_test$Label, test_predicted, "TF-IDF Naive Bayes")
#write to a csv file
write_csv(rbind(curr_eval__authors_df, eval_df), output_Path1)












