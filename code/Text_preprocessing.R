#Text Preprocessing for tweets

library(dplyr)
library(tm)

text_corpus <- data.frame(read.csv("C:/Users/Anish Singh/OneDrive/Documents/DWR/datascir21/tweets.csv"))#reading csv file

text_preprocessing <- function(data) {
  processing<-data %>%
    
    {
      gsub('-', '', .)#removing hyphens
    } %>%
    
    {
      gsub('[[:punct:] ]+', ' ', .)#punctuations removal
    } %>%
    
    {
      gsub("\\b[IVXLCDM]+\\b", " ", .)#roman numbers removal
    } %>%
    
    tolower %>% #changing to lowercase
    removeNumbers()%>%# removing numbers from data
    removeWords(words = stopwords(kind = "en")) #removing English dictionary stopwords
  return(processing)
}

for(x in setdiff(colnames(text_corpus),"id"))
{
  text_corpus[[x]]=text_preprocessing(text_corpus[[x]])
}