library(tidyverse)
library(tidytext)
library(stringr)
library(DT)
library(knitr)
library('wordcloud')
library(igraph)
library(ggraph)
library(tm)
library(topicmodels)
library(caret)
library(syuzhet)
library(text2vec)
library(data.table)
library("readr")
library(glmnet)

rm(list=ls())

dataset<- read.csv('/Users/ramancheema/Documents/Data Sci R - Project/data/training/preprocessed_data.csv')
train <- dataset %>% # for tf-idf 
  unite("tweets", tweet1:tweet100)

train_words_target <- train %>%
  unnest_tokens(word, tweets) %>%
  # remove stopwords
  anti_join(stop_words, by = "word") %>%
  count(target, word) %>%
  ungroup()

#word cloud 
train_words_all <- train_words_target %>%
  group_by(word) %>%
  summarise(n = sum(n)) %>%
  ungroup()
#show word cloud 
wordcloud(train_words_all$word, train_words_all$n,
          max.words = 200, scale = c(1.8, 0.5),
          colors = RColorBrewer::brewer.pal(9, "YlOrRd")[3:9])

################## start plot - bar plot for all tweets ###########
theme_set(theme_minimal())
train_words_all %>%
  top_n(50, n) %>%
  arrange(n) %>%
  mutate(word = factor(word, levels = word)) %>%
  ggplot() +
  labs(y='Frequency of Words',x='Words')+
  geom_col(aes(word, n), color = "gray80", fill = "lightgreen") +
  coord_flip()
################## end plot - bar plot for all tweets ###########

# group words by hate and non hate 
train_words_target[, 'AuthorSpreading'] <- as.character(train_words_target[, 'AuthorSpreading'])
train_words_target$AuthorSpreading<- gsub('0', 'Non-Hate', train_words_target$AuthorSpreading)
train_words_target$AuthorSpreading<- gsub('1', 'Hate', train_words_target$AuthorSpreading)
colnames(train_words_target)[1] <- "AuthorSpreading"

#################### start plot #####################
train_words_target %>%
  group_by(AuthorSpreading) %>%
  top_n(20, n) %>%
  ungroup() %>%
  group_by(word) %>%
  mutate(tot_n = sum(n)) %>%
  ungroup() %>%
  arrange(desc(tot_n)) %>%
  mutate(word = factor(word, levels = rev(unique(word)))) %>%
  ggplot() +
  geom_point(aes(AuthorSpreading, word, size = n, color = n), show.legend = FALSE) +
  geom_text(aes(AuthorSpreading, word, label = n), hjust = -1) +
  scale_color_distiller(palette = "YlOrRd") +
  labs(y='Words Usage',x='Class')+
  scale_size_continuous(range = c(1, 10))
#################### end plot #####################


# word cloud
TargetWordCloud <- function(class) {
  train_words_target %>%
    filter(AuthorSpreading == class) %>%
    with(wordcloud(word, n, max.words = 200,
                   scale = c(1.8, 0.5),
                   random.order = FALSE,
                   rot.per = 0, 
                   colors = RColorBrewer::brewer.pal(9, "YlOrRd")[3:9]))
}
############### start of bar plot - word cloud #######################
TargetWordBars <- function(class) {
  train_words_target %>%
    filter(AuthorSpreading == class) %>%
    top_n(50, n) %>%
    arrange(n) %>%
    mutate(word = factor(word, levels = word)) %>%
    ggplot() +
    geom_col(aes(word, n), color = "gray80", fill = "lightgreen") +
    labs(x='Words',y='Word frequency')+
    coord_flip() 
}
#plot 1 
TargetWordBars('Hate')
#plot 2
TargetWordBars('Non-Hate')
###################### end plot ###########################

#word cloud 
TargetWordCloud('Hate')
TargetWordBars('Non-Hate')

