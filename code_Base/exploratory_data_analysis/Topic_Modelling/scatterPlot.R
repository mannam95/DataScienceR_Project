dataset<- read.csv('/Users/ramancheema/Documents/Data Sci R - Project/data/training/preprocessed_data.csv')
load("/Users/ramancheema/glove_emdeddings.RData")
library(dplyr)

# 1. who else talking around these topics?
    #pick a tweet and find tweets with least distance, top 5 -in same column or whole ?
#2. clustering authors based upon distance and color them by target - scattered plot 

#******** Implementing point 1************
#euclidean distance function 
euc.dist <- function(x1, x2) sqrt(sum((x1 - x2) ^ 2))

#column 2, cell - no 6,2, compared to all tweets in column 8 
vectors<-cbind('id','dist')
for(i in 2:299){
  v<-cbind(all_vectors[i,1],euc.dist(unlist(all_vectors[6,2]),unlist(all_vectors[i,8])))
  vectors<-rbind(vectors,v)
}  

vec<-data.frame(vectors)
colnames(vec)<-c('id','dist')
vec<-vec[-1,] #deleting extra named  col names 
vec <- as.data.frame(lapply(vec, unlist))
x<-vec[order(vec$dist),]
ids<-x[2:6,1]
fil<-dataset%>% filter(id %in% ids)

#top 5 tweets 
fil[,4]
#******** end of  point 1************

#******** Implementing point 2 ***********
#author signatures as x and y , target as colour ; scatterplot
#author signature table 
author<-cbind('id','sig')
for (i in 2:299){
  a=0
for (j in 2:101){
  a=a+unlist(all_vectors[i,j])
}
  v<-cbind(all_vectors[i,1],list(a))
  author<-rbind(author,v)
  }
colnames(author)<-c('id','sig')
author<-author[-1,]
#renaming col names for plotting
dataset[, 'target'] <- as.character(dataset[, 'target'])
dataset$target<- gsub('0', 'Non-Hate', dataset$target)
dataset$target<- gsub('1', 'Hate', dataset$target)
colnames(dataset)[3] <- "AuthorSpreading"
# pca 
authorSignatures<-t(as.data.frame(lapply(author[,2], unlist)))

######################### start plot - scatterplot PCA ################
library(ggfortify)
authSig.pca <- prcomp(authorSignatures,  center = TRUE,scale. = TRUE) 
autoplot(authSig.pca, data = dataset, colour = 'AuthorSpreading') 
################### end plot - scatterplot PCA ################



