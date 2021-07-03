#files and directory paths
csvLocation = "datasets/dataset_working/feature_extraction/train_feature_extract_sentiments.csv"
setwd('C:/Users/SrinathMannam/Desktop/Github/DataScienceR') # change path accordingly 

library(dplyr)
library(tidyverse)
#install.packages("tm")
library(tm)
library(ggplot2)
#install.packages("syuzhet")
library(syuzhet)
#install.packages("plotly")
library(plotly)
#install.packages("treemapify")
library(treemapify)

#Read the features extracted
features_Data <- read.csv(file = csvLocation)
glimpse(features_Data)

#Start of sentiments visualizations
sentiments_df <- features_Data %>%
  select(Syuzhet, Bing, Afinn, Nrc)

sentiment_types_df <- data.frame(matrix(ncol=4,nrow=0, dimnames=list(NULL, c("syuzhet", "bing", "afinn", "nrc"))))

syuzhet = 0
bing = 0
afinn = 0
nrc = 0

for (row in 1:nrow(sentiments_df)) {
  
  syuzhet = syuzhet + sentiments_df[row, c(1)]
  bing = bing + sentiments_df[row, c(2)]
  afinn = afinn + sentiments_df[row, c(3)]
  nrc = nrc + sentiments_df[row, c(4)]
  
  if(row %% 100 == 0){
    sentiment_types_df[nrow(sentiment_types_df) + 1,] = c(syuzhet/100, bing/100, afinn/100, nrc/100)
    syuzhet = 0
    bing = 0
    afinn = 0
    nrc = 0
  }
}

plot_ly(sentiment_types_df, y=~syuzhet, type="scatter", mode="jitter", name="syuzhet") %>%
  add_trace(y=~bing, mode="lines", name="bing") %>%
  add_trace(y=~afinn, mode="lines", name="afinn") %>%
  add_trace(y=~nrc, mode="lines", name="nrc") %>%
  layout(title="Different type of sentiments for Author Tweets",
         yaxis=list(title="Score"), xaxis=list(title="Number of tweets"))
#End of sentiments visualizations

#Start of Emotions Visualizations
emotions_df <- features_Data %>%
  select(anger, anticipation, disgust, fear, joy, sadness, surprise, trust)

emotions_df_column_count = colSums(emotions_df)
emotions_df_column_count_df = data.frame(count=emotions_df_column_count, Different_Emotions=names(emotions_df_column_count))

emotions_df_column_count_df <- emotions_df_column_count_df %>%
  mutate(percent = count / sum(count) * 100)

##Start of Pie chart
ggplot(emotions_df_column_count_df, 
       aes(x = "", 
           y = percent, 
           fill = Different_Emotions)) +
  geom_bar(width = 1, 
           stat = "identity", 
           color = "black") +
  geom_text(aes(label = paste0(Different_Emotions, "\n", round(percent,2))),
            position = position_stack(vjust = 0.5),
            color = "black") +
  coord_polar("y", 
              start = 0, 
              direction = -1) +
  theme_void() +
  theme(legend.position = "FALSE") +
  labs(title = "Tweets Emotion Analysis")
##End of Pie chart
#End of Emotions Visualizations

#Start of Positive Visualizations
positive_df <- features_Data %>%
  select(positive, negative)

positive_df_column_count = colSums(positive_df)
positive_df_column_count_df = data.frame(count=positive_df_column_count, Sentiment=names(positive_df_column_count))

positive_df_column_count_df <- positive_df_column_count_df %>%
  mutate(percent = count / sum(count) * 100)

qplot(Sentiment, data=positive_df_column_count_df, weight=percent, geom="bar",fill=Sentiment, ylab="Percentage", xlab="Sentiment")+ggtitle("Tweets Sentiment Analysis")
#End of Negative Visualizations

#Start of Tweet Analysis Based On Author ID
authorId <- 99

getAuthorBasedTweets <- function(author_Id){
  start <- (author_Id * 100) - 100
  end <- author_Id * 100
  
  author_features_Data <- features_Data %>% 
                            slice(start:end)
  
  author_emotions_df <- author_features_Data %>%
    select(anger, anticipation, disgust, fear, joy, sadness, surprise, trust)
  
  author_emotions_df_column_count = colSums(author_emotions_df)
  author_emotions_df_column_count_df = data.frame(count=author_emotions_df_column_count, Different_Emotions=names(author_emotions_df_column_count))
  
  author_emotions_df_column_count_df <- author_emotions_df_column_count_df %>%
    mutate(percent = count / sum(count) * 100)
  
  
  qplot(Different_Emotions, data=author_emotions_df_column_count_df, weight=percent, geom="bar",fill=Different_Emotions, ylab="Percentage", xlab="Emotions")+ggtitle("Author Emotion Analysis")
}

getAuthorBasedTweets(authorId)
#End of Tweet Analysis Based On Author ID


# ensure the results are repeatable
set.seed(7)
#library(mlbench)
#install.packages("caret")
library(caret)
# load the data
# calculate correlation matrix
correlationMatrix <- cor(features_Data[,6:13])
# summarize the correlation matrix
print(correlationMatrix)
# find attributes that are highly corrected (ideally >0.75)
highlyCorrelated <- findCorrelation(correlationMatrix, cutoff=0.5)
# print indexes of highly correlated attributes
print(highlyCorrelated)

