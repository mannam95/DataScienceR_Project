
#Text Preprocessing for tweets

library(dplyr)
library(tm)
library(tidyverse)

#directory paths paths
train_preprocessed_csv_path = "datasets/dataset_working/pre_processed_files/train_dataset_pre1.csv"
test_preprocessed_csv_path = "datasets/dataset_working/pre_processed_files/test_dataset_pre1.csv"
output_dir_path_pre1 = "datasets/dataset_working/pre_processed_files/train_pre_dataset_to_rows.csv"
output_dir_path_pre2 = "datasets/dataset_working/pre_processed_files/test_pre_dataset_to_rows.csv"
setwd('D:/HP_Win10_OneDrive/Study/OVGU/University/Summer-2021/DSR/Github/DataScienceR') # change path accordingly 

train_text_corpus <- data.frame(read.csv( train_preprocessed_csv_path ))#reading csv file
test_text_corpus <- data.frame(read.csv( test_preprocessed_csv_path ))#reading csv file

text_preprocessing <- function(data) {
  processing<-data %>%
    
    {
      gsub('-', '', .)#removing hyphens
    } %>%
    
    {
      gsub('[[:punct:] ]+', ' ', .)#punctuation removal
    } %>%
    
    {
      gsub("\\b[IVXLCDM]+\\b", " ", .)#roman numbers removal
    } %>%
    
    tolower %>% #changing to lowercase
    removeNumbers()%>%# removing numbers from data
    removeWords(words = stopwords(kind = "en")) #removing English dictionary stopwords
  return(processing)
}

#Training Data
for(x in setdiff(colnames(train_text_corpus),c("id", "target")))
{
  train_text_corpus[[x]]=text_preprocessing(train_text_corpus[[x]])
}

#Testing Data
for(x in setdiff(colnames(test_text_corpus),c("id", "target")))
{
  test_text_corpus[[x]]=text_preprocessing(test_text_corpus[[x]])
}

#store the formatted data into a data frame
train_text_corpus_formatted <- data.frame(matrix(ncol=4,nrow=0, dimnames=list(NULL, c("Author_Id", "Tweet_Id", "Tweet_Text", "Target"))))
test_text_corpus_formatted <- data.frame(matrix(ncol=4,nrow=0, dimnames=list(NULL, c("Author_Id", "Tweet_Id", "Tweet_Text", "Target"))))


#a function split the columns to rows for train data
train_format_data <- function(row_data) {
  count <- 1
  while(count <= 100){
    train_text_corpus_formatted[nrow(train_text_corpus_formatted) + 1,] = c(train_text_corpus[row_data, "id"], count, gsub("\\s+"," ", train_text_corpus[row_data, sprintf("tweet%d", count)]), train_text_corpus[row_data, "target"])
    count <- count + 1
    assign("train_text_corpus_formatted", train_text_corpus_formatted, envir = .GlobalEnv)#globally change data
  }
}

#a function for processing test data
test_format_data <- function(row_data) {
  count <- 1
  while(count <= 100){
    test_text_corpus_formatted[nrow(test_text_corpus_formatted) + 1,] = c(test_text_corpus[row_data, "id"], count, gsub("\\s+"," ", test_text_corpus[row_data, sprintf("tweet%d", count)]), test_text_corpus[row_data, "target"])
    count <- count + 1
    assign("test_text_corpus_formatted", test_text_corpus_formatted, envir = .GlobalEnv)#globally change data
  }
}

#loop over through each row for train data
for (row in 1:nrow(train_text_corpus)) {
  train_format_data(row)
}

#loop over through each row for test data
for (row in 1:nrow(test_text_corpus)) {
  test_format_data(row)
}


#write to a csv file the train data
write_csv(train_text_corpus_formatted, output_dir_path_pre1)

#write to a csv file the test data
write_csv(test_text_corpus_formatted, output_dir_path_pre2)


