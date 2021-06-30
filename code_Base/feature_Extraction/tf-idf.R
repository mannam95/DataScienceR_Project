library(tidyverse)
library(tidytext)
library(SnowballC)
library(quanteda)
library(dplyr)

data<-read.csv('preprocessed.csv')
# combining all tweets together for tf-idf 
tweet <- data %>% 
  unite("tweets", tweet1:tweet100)%>%select(-target)

#-----TF-IDF 
tf_idf<- tweet %>%
  unnest_tokens(word, tweets) %>%
  anti_join(get_stopwords(), by = "word") %>%
  mutate(stem = wordStem(word)) %>%
  count(id, stem) %>%
  bind_tf_idf(stem, id, n) %>%
  cast_dfm(id, stem, tf_idf)
tf_idf<-data.frame(tf_idf)
write.csv(tf_idf,'tf_idf.csv')
