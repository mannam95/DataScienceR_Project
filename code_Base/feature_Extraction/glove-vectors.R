library(tidyverse)
library(tidytext)
library(SnowballC)
library(quanteda)
library(dplyr)
library(readr)
library(stringr)
library(knitr)
library(gplots)

# get pre trained vectors for words 
path <- "/Users/ramancheema/Downloads/glove.twitter.27B/glove.twitter.27B.25d.txt";
# set dimensions for vector
dims <- 25
# naming dimensions as d1,d2... 
col_names <- c("term", str_c("d", 1:dims))
# dat has dictionary , each word has vector 
dat <- read_delim(file = path,delim = " ",quote = "",col_names = col_names)
# conversion glove vectors data to dataframe 
dat<-data.frame(dat)
rownames(dat) <- dat$term
dat <- dat[,-1]
dat <- as.matrix(dat)

head(dat)
terms <- row.names(dat)
terms<-data.frame(terms)

# ------ getting tweets
#  1. set of tokens 
#  2. for every token , get vector 
# 3. add all vectors to get vector of tweet 
data<- read.csv('preprocessed.csv')
data<-text_corpus


# tokenisation 
for(x in setdiff(colnames(data),"id"))
{
  data[[x]]=tokenize_word(data[[x]])
}

#---- complete code get tweet vectors 
data<-data[-2] #deleting target 
r<- nrow(data)
c<-ncol(data)

all_vectors<-colnames(data) # starting point for all vectors
for(i in 1:r){
  # binding id in each row for ientification
  vectors<-rbind(data['id'][i,])
  for(j in 2:c){
    # get tweet at specified location
    tweet<-data[i,j]
    # unlist dimensions to get single word
    words<-unlist(tweet)
    # get rid of blank spaces 
    words<-words[!words %in% " "]
    # this code will give vector, sum up for all vectors of words
    #and then normalise by number of words. 
    vecs=0
    for (word in words) {
      tryCatch( { vec <- dat[word,];},
                error = function(e) {vec <<- 0})
      vecs<-vecs+vec
    }
    vectors<-cbind(vectors,list(vecs/length(words)))
  }
  # format of data - id , vectors of tweets 
  all_vectors<- rbind(all_vectors,vectors)
}


