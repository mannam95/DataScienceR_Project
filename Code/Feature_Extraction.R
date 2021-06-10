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
csvLocation = "dataset_working/pre_processed_files/pre_dataset_to_rows.csv"
output_dir_path_fea = "dataset_working/feature_extraction/feature_extract_srinath.csv"
setwd('D:/HP_Win10_OneDrive/Study/OVGU/University/Summer-2021/DSR/Github/DataScienceR') # change path accordingly 

#Read the pre-processed csv file
pre_Pro_Data <- read.csv(file = csvLocation)
glimpse(pre_Pro_Data)

emotions_feature_df <- data.frame(matrix(ncol=8,nrow=0, dimnames=list(NULL, c("anger", "anticipation", "disgust", "fear", "joy", "sadness", "surprise", "trust"))))

#a function that will extract sentiment feature
sentiment_feature <- function(current_Row_TweetText) {
  sentence_vector <- get_sentences(current_Row_TweetText)
  
  #get the emotion vector for the current tweet
  nrc_data <- get_nrc_sentiment(sentence_vector)
  
  #store the tweet into a df
  emotions_feature_df[nrow(emotions_feature_df) + 1,] = c(nrc_data[1, c(1)], nrc_data[1, c(2)], nrc_data[1, c(3)], nrc_data[1, c(4)], nrc_data[1, c(5)], nrc_data[1, c(6)], nrc_data[1, c(7)], nrc_data[1, c(8)])
  
  assign("emotions_feature_df", emotions_feature_df, envir = .GlobalEnv)#globally change data
  
  sentence_vector_syuzhet_score <- get_sentiment(sentence_vector, method="syuzhet")
  return(sum(sentence_vector_syuzhet_score))
}


#Empty sentiment data frame declaration
sentiment_feature_df <- data.frame(matrix(ncol=1,nrow=0, dimnames=list(NULL, c("Sentiment"))))

#loop over through each row
for (row in 1:nrow(pre_Pro_Data)) {
  sentiment_feature_df[nrow(sentiment_feature_df) + 1,] = c(sentiment_feature(pre_Pro_Data[row, c(3)]))
}

#Combine all the features together
features_extracted <- cbind(pre_Pro_Data, sentiment_feature_df, emotions_feature_df)


#write to a csv file
write_csv(features_extracted, output_dir_path_fea)



#below is for extraction of bi-grams and tri-grams

# #extract bi-grams
# tweet_text_bg <- pre_Pro_Data %>%
#   unnest_tokens(bigram_trigram, Tweet_Text, token = "ngrams", n = 2)
# 
# #extract tri-grams
# tweet_text_tg <- pre_Pro_Data %>%
#   unnest_tokens(bigram_trigram, Tweet_Text, token = "ngrams", n = 3)
# 
# #merge bi-grams and tri-grams
# everything <-rbind(tweet_text_bg, tweet_text_tg)







