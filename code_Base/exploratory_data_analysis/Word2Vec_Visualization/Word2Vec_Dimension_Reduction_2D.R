
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

#UMAP Dimension Reduction
library(uwot)
viz <- umap(dendo, n_neighbors = 15, n_threads = 2)
viz