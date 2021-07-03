
#importing required libraries
library(dplyr)
library(word2vec)
library(stylo)

#setting the value of path variable to feed to the word2vec model
#change path accordingly
path  <- "/Users/priyankasingh/tweets.csv"

#Setting Hyper-parameters for Model training
set.seed(10034)


#training the model with dimensions as 25 and 20 iterations
model <- word2vec(path, dim = 25, iter = 20)

#embedding for word2vec is created after model is trained
embedding <- as.matrix(model)


#does the dendogram
dendo <- embedding[unlist(lapply(lookslike, `[`, 'term2')), ]
dendo_dist = dist.cosine(dendo) %>% as.dist
plot(as.dendrogram(hclust(dendo_dist)), horiz=F, cex=1, main="Cluster Dendogram of words closest to HateSpeech Vector")