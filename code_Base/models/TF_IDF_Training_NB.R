library(tidyverse)
library(stringr)
library(tidytext)



#setwd('C:/Users/Anish Singh/OneDrive/Documents/DWR/DataScienceR')
preprocessed_data<- read.csv("dataset_working/pre_processed_files/pre_processed.csv")
preprocessed_data_test<- read.csv("dataset_working/pre_processed_files/pre_processed_test_data_cols.csv")


library(tidyverse)
library(tidytext)
library(SnowballC)
library(quanteda)
library(dplyr)


tweet <- preprocessed_data %>% # for tf-idf 
  unite("tweets", tweet1:tweet100)%>%select(-target)
tweet_test <- preprocessed_data_test %>% # for tf-idf 
  unite("tweets", tweet1:tweet100)%>%select(-target)

#-----TF-IDF for training
tf_idf<- tweet%>%
  unnest_tokens(word, tweets) %>%
  anti_join(get_stopwords(), by = "word") %>%
  mutate(stem = wordStem(word)) %>%
  count(id, stem) %>%
  bind_tf_idf(stem, id, n) %>%
  cast_dfm(id, stem, tf_idf)
tf_idF_matrix <- as.matrix(tf_idf)
tf_idF_DF <- cbind(Label = preprocessed_data$target, data.frame(tf_idF_matrix))

#-----TF-IDF for Test Data
tf_idf_test<- tweet_test %>%
  unnest_tokens(word, tweets) %>%
  anti_join(get_stopwords(), by = "word") %>%
  mutate(stem = wordStem(word)) %>%
  count(id, stem) %>%
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

cfm <- caret::confusionMatrix(data = test_predicted,
                              tf_idF_DF_test$Label)
caret::confusionMatrix(table(test_predicted, tf_idF_DF_test$Label)) 










a<-tf_idF_DF[,3:ncol(tf_idF_DF)]
names(tf_idF_DF) <- make.names(names(tf_idF_DF))


colnames(tf_idF_matrix)[1:50]
View(tf_idF_matrix[1:20, 1:100])
dim(tf_idF_matrix)

tf_idf<-data.frame(tf_idf)
write.csv(tf_idf,'tf_idf.csv')


