#import libraries
library(dplyr)
library(tidyverse)
library(janeaustenr)

#install.packages("tidytext")
library(tidytext)
#install.packages("coreNLP")
#install.packages("syuzhet")
library(syuzhet)

#files and directory paths
# change paths accordingly 
csvLocation_train = "datasets/dataset_working/pre_processed_files/train_pre_dataset_to_rows.csv"
csvLocation_test = "datasets/dataset_working/pre_processed_files/test_pre_dataset_to_rows.csv"
output_dir_path_fea1 = "datasets/dataset_working/feature_extraction/train_feature_extract_sentiments.csv"
output_dir_path_fea2 = "datasets/dataset_working/feature_extraction/test_feature_extract_sentiments.csv"
setwd('D:/HP_Win10_OneDrive/Study/OVGU/University/Summer-2021/DSR/Github/DataScienceR')

#Read the pre-processed csv files
pre_Pro_Data_train <- read.csv(file = csvLocation_train)
pre_Pro_Data_test <- read.csv(file = csvLocation_test)

emotions_feature_df_train <- data.frame(matrix(ncol=10,nrow=0, dimnames=list(NULL, c("anger", "anticipation", "disgust", "fear", "joy", "sadness", "surprise", "trust", "positive", "negative"))))
emotions_feature_df_test <- data.frame(matrix(ncol=10,nrow=0, dimnames=list(NULL, c("anger", "anticipation", "disgust", "fear", "joy", "sadness", "surprise", "trust", "positive", "negative"))))

#a function that will extract sentiment feature
sentiment_feature <- function(current_Row_TweetText, trainOrNot) {
  sentence_vector <- get_sentences(current_Row_TweetText)
  
  #get the emotion vector for the current tweet
  nrc_data <- get_nrc_sentiment(sentence_vector)
  
  if (trainOrNot == 'Yes') {
    emotions_feature_df_train[nrow(emotions_feature_df_train) + 1,] = c(nrc_data[1, c(1)], nrc_data[1, c(2)], nrc_data[1, c(3)], nrc_data[1, c(4)], nrc_data[1, c(5)], nrc_data[1, c(6)], nrc_data[1, c(7)], nrc_data[1, c(8)], nrc_data[1, c(9)], nrc_data[1, c(10)])
    assign("emotions_feature_df_train", emotions_feature_df_train, envir = .GlobalEnv)#globally change data
  } else {
    emotions_feature_df_test[nrow(emotions_feature_df_test) + 1,] = c(nrc_data[1, c(1)], nrc_data[1, c(2)], nrc_data[1, c(3)], nrc_data[1, c(4)], nrc_data[1, c(5)], nrc_data[1, c(6)], nrc_data[1, c(7)], nrc_data[1, c(8)], nrc_data[1, c(9)], nrc_data[1, c(10)])
    assign("emotions_feature_df_test", emotions_feature_df_test, envir = .GlobalEnv)#globally change data
  }
  
  sentence_vector_syuzhet_score <- get_sentiment(sentence_vector, method="syuzhet")
  return(sum(sentence_vector_syuzhet_score))
}

#a function that will extract sentiment feature based on the method
get_sentiment_by_method <- function(current_Row_TweetText, methodName) {
  sentence_vector <- get_sentences(current_Row_TweetText)
  sentence_vector_syuzhet_score <- get_sentiment(sentence_vector, method=methodName)
  return(sum(sentence_vector_syuzhet_score))
}


#Empty sentiment data frame declaration for train and test data
train_sentiment_feature_df <- data.frame(matrix(ncol=1,nrow=0, dimnames=list(NULL, c("Syuzhet"))))
train_sentiment_feature_bing_df <- data.frame(matrix(ncol=1,nrow=0, dimnames=list(NULL, c("Bing"))))
train_sentiment_feature_afinn_df <- data.frame(matrix(ncol=1,nrow=0, dimnames=list(NULL, c("Afinn"))))
train_sentiment_feature_nrc_df <- data.frame(matrix(ncol=1,nrow=0, dimnames=list(NULL, c("Nrc"))))
test_sentiment_feature_df <- data.frame(matrix(ncol=1,nrow=0, dimnames=list(NULL, c("Syuzhet"))))
test_sentiment_feature_bing_df <- data.frame(matrix(ncol=1,nrow=0, dimnames=list(NULL, c("Bing"))))
test_sentiment_feature_afinn_df <- data.frame(matrix(ncol=1,nrow=0, dimnames=list(NULL, c("Afinn"))))
test_sentiment_feature_nrc_df <- data.frame(matrix(ncol=1,nrow=0, dimnames=list(NULL, c("Nrc"))))

#loop over through each row in train data
for (row in 1:nrow(pre_Pro_Data_train)) {
  train_sentiment_feature_df[nrow(train_sentiment_feature_df) + 1,] = c(sentiment_feature(pre_Pro_Data_train[row, c(3)], "Yes"))
  train_sentiment_feature_bing_df[nrow(train_sentiment_feature_bing_df) + 1,] = c(get_sentiment_by_method(pre_Pro_Data_train[row, c(3)], "bing"))
  train_sentiment_feature_afinn_df[nrow(train_sentiment_feature_afinn_df) + 1,] = c(get_sentiment_by_method(pre_Pro_Data_train[row, c(3)], "afinn"))
  train_sentiment_feature_nrc_df[nrow(train_sentiment_feature_nrc_df) + 1,] = c(get_sentiment_by_method(pre_Pro_Data_train[row, c(3)], "nrc"))
}

#loop over through each row in test data
for (row in 1:nrow(pre_Pro_Data_test)) {
  test_sentiment_feature_df[nrow(test_sentiment_feature_df) + 1,] = c(sentiment_feature(pre_Pro_Data_test[row, c(3)], "No"))
  test_sentiment_feature_bing_df[nrow(test_sentiment_feature_bing_df) + 1,] = c(get_sentiment_by_method(pre_Pro_Data_test[row, c(3)], "bing"))
  test_sentiment_feature_afinn_df[nrow(test_sentiment_feature_afinn_df) + 1,] = c(get_sentiment_by_method(pre_Pro_Data_test[row, c(3)], "afinn"))
  test_sentiment_feature_nrc_df[nrow(test_sentiment_feature_nrc_df) + 1,] = c(get_sentiment_by_method(pre_Pro_Data_test[row, c(3)], "nrc"))
}

#Combine all the features together
features_extracted_train <- cbind(pre_Pro_Data_train, train_sentiment_feature_df, emotions_feature_df_train, train_sentiment_feature_bing_df, train_sentiment_feature_afinn_df, train_sentiment_feature_nrc_df)
features_extracted_test <- cbind(pre_Pro_Data_test, test_sentiment_feature_df, emotions_feature_df_test, test_sentiment_feature_bing_df, test_sentiment_feature_afinn_df, test_sentiment_feature_nrc_df)


#write to a csv file
write_csv(features_extracted_train, output_dir_path_fea1)
write_csv(features_extracted_test, output_dir_path_fea2)








