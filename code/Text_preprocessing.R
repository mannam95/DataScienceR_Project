
#Text Preprocessing for tweets

library(dplyr)
library(tm)
library(tidyverse)

#directory paths paths
first_preprocessed_csv_path = "dataset_working/pre_processed_files/dataset_pre1.csv"
output_dir_path_pre2 = "dataset_working/pre_processed_files/pre_dataset_to_rows.csv"
setwd('D:/HP_Win10_OneDrive/Study/OVGU/University/Summer-2021/DSR/Github/DataSciR') # change path accordingly 

text_corpus <- data.frame(read.csv( first_preprocessed_csv_path ))#reading csv file

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

for(x in setdiff(colnames(text_corpus),c("id", "target")))
{
  text_corpus[[x]]=text_preprocessing(text_corpus[[x]])
}

#store the formatted data into a data frame
text_corpus_formatted <- data.frame(matrix(ncol=4,nrow=0, dimnames=list(NULL, c("Author_Id", "Tweet_Id", "Tweet_Text", "Target"))))


#a function split the columns to rows
format_data <- function(row_data) {
  count <- 1
  while(count <= 100){
    text_corpus_formatted[nrow(text_corpus_formatted) + 1,] = c(text_corpus[row_data, "id"], count, gsub("\\s+"," ", text_corpus[row_data, sprintf("tweet%d", count)]), text_corpus[row_data, "target"])
    count <- count + 1
    assign("text_corpus_formatted", text_corpus_formatted, envir = .GlobalEnv)#globally change data
  }
}

#loop over through each row
for (row in 1:nrow(text_corpus)) {
  format_data(row)
}

#write to a csv file
write_csv(text_corpus_formatted, output_dir_path_pre2)


